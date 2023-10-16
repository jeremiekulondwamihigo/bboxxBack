const mongoose = require("mongoose");
const modelDemande = require("./Demande");

const schema = new mongoose.Schema({
  codeClient: { type: String, required: false }, //BDRC
  codeCu: { type: String, required: false },
  clientStatut: { type: String, required: false },
  PayementStatut: { type: String, required: false },
  consExpDays: { type: Number, required: false },
  idDemande: { type: String, required: true, unique:true },
  dateSave: { type: Date, required: true },
  text: { type: String, required: false, enum: ["demande", "texte"] },
});
schema.post("save", function (doc, next) {
  next();
  modelDemande
    .findOneAndUpdate({ idDemande: doc.idDemande }, { $set: { valide: true } })
    .then((response) => {
      console.log(response);
    })
    .catch(function (err) {
      console.log(err);
    });
});
const model = mongoose.model("Reponse", schema);
module.exports = model;
