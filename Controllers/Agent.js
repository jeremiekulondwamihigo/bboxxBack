const modelAgent = require("../Models/Agent");
const { isEmpty } = require("../Static/Static_Function");
const asyncLab = require("async");

module.exports = {
  AddAgent: (req, res) => {
    try {
      const { nom, codeAgent, fonction, telephone } = req.body.values;
      const { idZone } = req.body.zoneSelect;

      if (
        isEmpty(nom) ||
        isEmpty(codeAgent) ||
        isEmpty(idZone) ||
        isEmpty(fonction)
      ) {
        return res.status(400).json("Veuillez renseigner les champs");
      }

      asyncLab.waterfall([
        function (done) {
          modelAgent
            .findOne({ codeAgent: codeAgent.trim() })
            .then((agent) => {
              if (agent) {
                return res.status(400).json("L'agent existe déjà");
              } else {
                done(null, false);
              }
            })
            .catch(function (err) {
              return res.status(400).json("Erreur");
            });
        },
        function (agent, done) {
          if (!agent) {
            modelAgent
              .create({
                nom,
                password: 1234,
                codeAgent,
                codeZone: idZone,
                fonction,
                telephone,
                id: new Date(),
              })
              .then((response) => {
                if (response) {
                  return res.status(200).json(response);
                } else {
                  return res.status(400).json("Erreur d'enregistrement");
                }
              })
              .catch(function (err) {
                return res.status(400).json("Erreur");
              });
          } else {
            return res.status(400).json("L'agent existe déjà");
          }
        },
      ]);
    } catch (error) {
      return res.status(400).json("Erreur d'enregistrement");
    }
  },
  ReadAgent: (req, res) => {
    try {
      modelAgent
        .find({})
        .sort({ nom: 1 })
        .then((response) => {
          return res.status(200).json(response.reverse());
        });
    } catch (error) {
      console.log(error);
    }
  },
  BloquerAgent: (req, res) => {
    try {
      const { id, value } = req.body;
      modelAgent
        .findByIdAndUpdate(id, { active: value }, { new: true })
        .then((result) => {
          if (result) {
            return res.status(200).json(result);
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
