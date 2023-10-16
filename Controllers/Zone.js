const modelZone = require("../Models/Zone");
const { isEmpty, generateString } = require("../Static/Static_Function");
const asyncLab = require("async");

module.exports = {
  Zone: (req, res) => {
    try {
      const { denomination } = req.body;
      console.log(req.body)
      if (isEmpty(denomination)) {
        return res.status(400).json("Veuillez renseigner la dénomination");
      }
      asyncLab.waterfall([
        function (done) {
          modelZone
            .findOne({ denomination: denomination.trim().toUpperCase() })
            .then((response) => {
              if (response) {
                return res.status(400).json("Opération déjà effectuée");
              } else {
                done(null, false);
              }
            })
            .catch(function (err) {
              return res.status(400).json("Erreur");
            });
        },
        function (zone, done) {
          modelZone
            .create({ denomination, id: new Date(), idZone: generateString(4) })
            .then((response) => {
              if (response) {
                return res.status(200).json(response);
              } else {
                return res.status(400).json("Erreur d'enregistrement");
              }
            }).catch(function(err){
                return res.status(400).json("Erreur")
            });
        },
      ]);
    } catch (error) {
      return res.status(400).jon("Erreur");
    }
  },
  ReadZone : (req, res)=>{
    try {
      modelZone.find({}).then(response=>{
        return res.status(200).json(response.reverse())
      }).catch(function(err){
        console.log(err)
      })
    } catch (error) {
      console.log(error)
    }
  }
};
