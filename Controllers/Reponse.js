const ModelReponse = require("../Models/Reponse");
const asyncLab = require("async");
const ModelDemande = require("../Models/Demande");
const ModelAgent = require("../Models/Agent");
const ModelParametre = require("../Models/Parametre");
const ModelPeriode = require("../Models/Periode");
const { dateActuelle } = require("../Static/Static_Function");

module.exports = {
  reponse: (req, res) => {
    try {
      console.log(req.body)
      const {
        idDemande,
        codeClient,
        codeCu,
        clientStatut,
        PayementStatut,
        consExpDays,
        nomClient,
        codeAgent,
      } = req.body;
      if (
        !idDemande ||
        !codeAgent ||
        !codeClient ||
        !clientStatut ||
        !PayementStatut ||
        !consExpDays
      ) {
        return res.status(400).json("Veuillez renseigner les champs");
      }
      const dates = new Date().toISOString();

      asyncLab.waterfall(
        [
          function (done) {
            ModelDemande.findOne({ idDemande })
              .then((response) => {
                if (response) {
                  console.log("response");
                  if (
                    response.concerne === "" ||
                    response.concerne === undefined ||
                    response.concerne === codeAgent
                  ) {
                    done(null, response);
                  } else {
                    done("Cette demande est reservee a un autre C.O");
                  }
                } else {
                  done("Demande introuvable ");
                }
              })
              .catch(function (err) {
                done("Erreur");
              });
          },
          function (demande, done) {
            ModelAgent.findOne({ codeAgent: codeAgent })
              .then((agent) => {
                if (agent) {
                  done(null, demande, agent);
                } else {
                  done("Agent introuvable");
                }
              })
              .catch(function (err) {
                console.log(err);
              });
          },
          function (demande, agent, done) {
            ModelParametre.findOne({ customer: codeClient })
              .then((customer) => {
                done(null, customer, demande, agent);
              })
              .catch(function (err) {
                done("Erreur");
              });
          },

          function (customer, demande, agent, done) {
            ModelPeriode.findOne({})
              .limit(1)
              .then((response) => {
                if (response) {
                  done(null, response, customer, demande, agent);
                } else {
                  done("Aucune période en cours");
                }
              })
              .catch(function (err) {
                console.log(err);
              });
          },
          function (periode, customer, demande, agent, done) {
            ModelReponse.aggregate([
              { $match: { codeClient } },
              {
                $lookup: {
                  from: "agents",
                  localField: "codeAgent",
                  foreignField: "codeAgent",
                  as: "agent",
                },
              },
              {
                $unwind: "$agent",
              },
              {
                $lookup: {
                  from: "demandes",
                  localField: "idDemande",
                  foreignField: "idDemande",
                  as: "demande",
                },
              },
              {
                $unwind: "$demande",
              },
            ]).then((result) => {
              console.log(result);
              if (
                result.length > 0 &&
                agent.fonction === result[0].agent.fonction &&
                periode.periode === result[0].demande.lot
              ) {
                done(`Cette demande a été repondue le ${dateActuelle(
                  result[0].dateSave
                )}
                à ${new Date(result[0].createdAt).toLocaleTimeString()}
                pour ${result[0].agent.nom} code :
                   ${result[0].agent.codeAgent} `);
              } else {
                done(null, periode, customer, demande, agent);
              }
            });
          },

          function (periode, customer, demande, agent, done) {
            ModelReponse.create({
              idDemande: demande.idDemande,
              codeClient,
              region: customer ? customer.region : "",
              shop: customer ? customer.shop : "",
              codeCu,
              clientStatut,
              PayementStatut,
              consExpDays,
              nomClient,
              jOrH: "j",
              text: periode.periode, // La periode
              codeAgent: agent.codeAgent,
              dateSave: dates.split("T")[0],
            })
              .then((response) => {
                if (response) {
                  done(response);
                } else {
                  done("Erreur d'enregistrement");
                }
              })
              .catch(function (err) {
                done("Erreur");
              });
          },
        ],
        function (result) {
          if (result.idDemande) {
            ModelDemande.aggregate([
              { $match: { idDemande: result.idDemande } },
              {
                $lookup: {
                  from: "agents",
                  localField: "codeAgent",
                  foreignField: "codeAgent",
                  as: "agent",
                },
              },

              {
                $lookup: {
                  from: "zones",
                  localField: "codeZone",
                  foreignField: "idZone",
                  as: "zone",
                },
              },
              {
                $lookup: {
                  from: "reponses",
                  localField: "idDemande",
                  foreignField: "idDemande",
                  as: "reponse",
                },
              },
              { $unwind: "$agent" },
              { $unwind: "$zone" },
            ])
              .then((response) => {
                if (response) {
                  return res.status(200).json(response[0]);
                } else {
                  done("Erreur");
                }
              })
              .catch(function (err) {
                console.log(err);
              });
          } else {
            return res.status(400).json(result);
          }
        }
      );
    } catch (error) {
      console.log(error);
    }
  },
  OneReponse: (req, res) => {
    try {
      const { id } = req.params;
      ModelReponse.aggregate([
        { $match: { codeClient: id } },
        {
          $lookup: {
            from: "demandes",
            localField: "idDemande",
            foreignField: "idDemande",
            as: "demande",
          },
        },
        { $unwind: "$demande" },
      ]).then((response) => {
        res.send(response);
      });
    } catch (error) {
      console.log(error);
    }
  },
  updateReponse: (req, res) => {
    try {
      const { idReponse, data } = req.body;

      ModelReponse.findByIdAndUpdate(idReponse, data, { new: true }).then(
        (response) => {
          return res
            .status(200)
            .json("Modification effectuée id " + response._id);
        }
      );
    } catch (error) {}
  },
};
