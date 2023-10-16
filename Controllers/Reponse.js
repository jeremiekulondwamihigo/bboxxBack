const ModelReponse = require("../Models/Reponse");
const asyncLab = require("async");
const ModelDemande = require("../Models/Demande");
const { isEmpty } = require("../Static/Static_Function");

module.exports = {
  reponse: (req, res) => {
    try {
      const {
        idDemande,
        codeClient,
        codeCu,
        clientStatut,
        PayementStatut,
        consExpDays,
        text,
      } = req.body;
      console.log(req.body)
      if (
        isEmpty(idDemande) ||
        isEmpty(codeClient) ||
        isEmpty(clientStatut) ||
        isEmpty(PayementStatut) ||
        isEmpty(consExpDays)
      ) {
        return res.status(200).json("Veuillez renseigner les champs");
      }
      asyncLab.waterfall([
        function (done) {
          ModelDemande.findOne({ idDemande })
            .then((response) => {
              
              if (response) {
                done(null, response);
              } else {
                return res.status(200).json("demande introuvable");
              }
            })
            .catch(function (err) {
              console.log(err)
              return res.status(200).json("Erreur");
            });
        },
        function (demande, done) {
          ModelReponse.create({
            idDemande: demande.idDemande,
            codeClient,
            codeCu,
            clientStatut,
            PayementStatut,
            consExpDays,
            text,
          })
            .then((response) => {
              if (response) {
                done(null, response);
              } else {
                return res.status(200).json("Erreur d'enregistrement");
              }
            })
            .catch(function (err) {
              return res.status(200).json("Erreur");
            });
        },
        function (response, done) {
          if (response) {
            return res.status(200).json(response);
          }
        },
      ]);
    } catch (error) {
      console.log(error);
    }
  },
};
