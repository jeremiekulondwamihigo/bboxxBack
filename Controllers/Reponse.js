const ModelReponse = require("../Models/Reponse");
const asyncLab = require("async");
const ModelDemande = require("../Models/Demande");

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
        message,
        jOrH,
      } = req.body;

      if (
        (text === "demande" &&
          (!idDemande ||
            !codeClient ||
            !clientStatut ||
            !PayementStatut ||
            !consExpDays ||
            !jOrH)) ||
        (text === "texte" && !message)
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
              console.log(err);
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
            jOrH,
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
              console.log(err);
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
