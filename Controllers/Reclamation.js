const asyncLab = require("async");
const modelDemande = require("../Models/Demande");
const modelReclamation = require("../Models/Reclamation");
const { ObjectId } = require("mongodb");
const _ = require("lodash");

module.exports = {
  Reclamation: (req, res) => {
    try {
      const { idDemande, message, sender, codeAgent } = req.body;

      if (!idDemande || !message) {
        return res.status(201).json("Error");
      }
      asyncLab.waterfall(
        [
          function (done) {
            modelReclamation
              .create({
                message,
                sender,
                idDemande,
              })
              .then((response) => {
                if (response) {
                  done(null, response);
                }
              })
              .catch(function (errr) {
                if (errr) {
                  return res.status(201).json("Try again");
                }
              });
          },
          function (reponse, done) {
            modelReclamation
              .find({ idDemande: reponse.idDemande })
              .then((response) => {
                if (response) {
                  done(null, response);
                }
              });
          },
          function (reponse, done) {
            if (sender === "co") {
              modelDemande
                .findOneAndUpdate(
                  { idDemande },
                  { $set: { concerne: codeAgent } }
                )
                .then((result) => {
                  if (result) {
                    done(reponse);
                  }
                })
                .catch(function (err) {
                  console.log(err);
                });
            } else {
              done(reponse);
            }
          },
        ],
        function (result) {
          return res.status(200).json(result);
        }
      );
    } catch (error) {
      console.log(error);
    }
  },
  ReadReclamation: (req, res) => {
    try {
      const { id } = req.params;

      asyncLab.waterfall(
        [
          function (done) {
            modelDemande
              .aggregate([
                { $match: { _id: new ObjectId(id) } },
                {
                  $lookup: {
                    from: "conversations",
                    localField: "idDemande",
                    foreignField: "idDemande",
                    as: "conversation",
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
              ])
              .then((response) => {
                if (response) {
                  done(response);
                }
              })
              .catch(function (err) {
                console.log(err);
              });
          },
        ],
        function (conversation) {
          return res.status(200).json({
            conversation: conversation[0].conversation,
            reponse: conversation[0].reponse,
          });
        }
      );
    } catch (error) {
      console.log(error);
    }
  },
  ReadMessage: (req, res) => {
    try {
      modelReclamation
        .aggregate([
          {
            $lookup: {
              from: "demandes",
              localField: "idDemande",
              foreignField: "idDemande",
              as: "demandeId",
            },
          },
          {
            $lookup: {
              from: "reponses",
              localField: "idDemande",
              foreignField: "idDemande",
              as: "reponseId",
            },
          },
        ])
        .then((response) => {
          return res.status(200).json(response);
        });
    } catch (error) {
      console.log(error);
    }
  },
  MakeFalse: (req, res) => {
    try {
      const { id } = req.params;
      modelReclamation
        .findByIdAndUpdate(id, { $set: { valide: true } }, { new: true })
        .then((response) => {
          if (response) {
            return res.status(200).json(response);
          }
        })
        .catch(function (err) {
          console.log(err);
        });
    } catch (error) {
      console.log(error);
    }
  },
};
