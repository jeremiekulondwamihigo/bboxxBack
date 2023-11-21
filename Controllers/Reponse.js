const ModelReponse = require("../Models/Reponse");
const asyncLab = require("async");
const ModelDemande = require("../Models/Demande");
const ModelAgent = require("../Models/Agent");

module.exports = {
  reponse: (req, res) => {
    try {
      console.log(req.body);
      const {
        idDemande,
        codeClient,
        codeCu,
        clientStatut,
        PayementStatut,
        consExpDays,
        text,
        nomClient,
        message,
        jOrH,
        codeAgent,
      } = req.body;
      if (
        (text === "demande" &&
          (!idDemande ||
            !codeAgent ||
            !codeClient ||
            !clientStatut ||
            !PayementStatut ||
            !consExpDays ||
            !jOrH)) ||
        (text === "texte" && !message)
      ) {
        return res.status(400).json("Veuillez renseigner les champs");
      }

      asyncLab.waterfall(
        [
          function (done) {
            ModelDemande.findOne({ idDemande })
              .then((response) => {
                if (response) {
                  if (
                    response.concerne === "" || response.concerne === undefined ||
                    response.concerne === codeAgent
                  ) {
                    done(null, response);
                  } else {
                    return res
                      .status(400)
                      .json("Cette demande est reservee a un autre C.O");
                  }
                } else {
                  return res.status(400).json("Demande introuvable ");
                }
              })
              .catch(function (err) {
                console.log(err);
                return res.status(400).json("Erreur");
              });
          },
          function (demande, done) {
            ModelAgent.findOne({ codeAgent: codeAgent })
              .then((agent) => {
                if (agent) {
                  done(null, demande, agent);
                } else {
                  return res.status(400).json("Agent introuvable");
                }
              })
              .catch(function (err) {
                console.log(err);
              });
          },

          function (demande, agent, done) {
            const dates = new Date().toISOString();
            ModelReponse.create({
              idDemande: demande.idDemande,
              codeClient,
              codeCu,
              clientStatut,
              PayementStatut,
              consExpDays,
              nomClient,
              jOrH,
              text,
              codeAgent: agent.codeAgent,
              dateSave: dates.split("T")[0],
            })
              .then((response) => {
                if (response) {
                  done(response);
                } else {
                  return res.status(400).json("Erreur d'enregistrement");
                }
              })
              .catch(function (err) {
                console.log(err);
                return res.status(400).json("Erreur");
              });
          },
        ],
        function (result) {
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
                return res.status(400).json("Erreur");
              }
            })
            .catch(function (err) {
              console.log(err);
            });
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
