const mongoose = require("mongoose");
const modelDemande = require("./Demande");

const schema = new mongoose.Schema(
  {
    codeClient: { type: String, required: false }, //BDRC
    codeCu: { type: String, required: false },
    clientStatut: { type: String, required: false },
    PayementStatut: { type: String, required: false },
    consExpDays: { type: Number, required: false },
    idDemande: { type: String, required: true, unique: true },
    text: { type: String, required: true },
    jOrH: { type: String, required: false },
    dateSave: { type: Date, required: true },
    codeAgent: { type: String, required: true },
    nomClient: { type: String, required: true },
    action: { type: String, required: false },
    region: { type: String, required: false, default: "" },
    shop: { type: String, required: false, default: "" },
  },
  { timestamps: true }
);
schema.post("save", function (doc, next) {
  next();
  modelDemande
    .findOneAndUpdate({ idDemande: doc.idDemande }, { $set: { valide: true } })
    .then((response) => {})
    .catch(function (err) {});
});
const model = mongoose.model("Reponse", schema);
module.exports = model;
