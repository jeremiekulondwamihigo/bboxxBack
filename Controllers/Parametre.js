const modelParametre = require("../Models/Parametre");
const modelPeriode = require("../Models/Periode");
const asyncLab = require("async");

module.exports = {
  Parametre: (req, res) => {
    try {
      const { data } = req.body;
      modelParametre
        .findOne({})
        .then((response) => {
          if (response) {
            return res
              .status(200)
              .json("Veuillez supprimer les données précédénte");
          } else {
            modelParametre
              .insertMany(data)
              .then((response) => {
                if (response) {
                  return res.status(200).json("Enregistrement effectuer");
                } else {
                  return res.status(200).json("Erreur d'enregistrement");
                }
              })
              .catch(function (err) {
                console.log(err);
              });
          }
        })
        .catch(function (err) {
          console.log(err);
        });
    } catch (error) {
      console.log(error);
    }
  },
  ReadParametre: (req, res) => {
    try {
      modelParametre
        .find({})
        .then((response) => {
          return res.status(200).json(response);
        })
        .catch(function (err) {
          console.log(err);
        });
    } catch (error) {
      console.log(error);
    }
  },
  PeriodeDemande: (req, res, next) => {
    next();
    if (new Date().getDate() <= 23) {
      const toDay = new Date();
      const periode = `${toDay.getMonth() + 1}-${toDay.getFullYear()}`;
      modelPeriode.updateOne({ $set: { periode } }).then((result) => {});
    }
  },
};
