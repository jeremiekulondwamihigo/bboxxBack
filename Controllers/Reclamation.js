const asyncLab = require("async");
const modelDemande = require("../Models/Demande");

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
            modelDemande
              .findOneAndUpdate(
                {
                  idDemande,
                },
                {
                  $addToSet: {
                    conversation: {
                      message,
                      sender,
                    },
                  },
                },
                { new: true }
              )
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
};
