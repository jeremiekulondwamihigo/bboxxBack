const mongoose = require("mongoose");

const coordonne = new mongoose.Schema({
  latitude: { type: String, required: false },
  longitude: { type: String, required: false },
  altitude: { type: String, required: false },
});
const conversatn = new mongoose.Schema({
  sender : {type:String, required:true},
  message : {type:String, required:true},
}, {timestamps : true})
const schema = new mongoose.Schema(
  {
    valide: { type: Boolean, required: true, default: false },
    idDemande: { type: String, required: true, },
    codeAgent: {
      type: String,
      required: [true, "Le code agent est obligatoire"],
      ref: "Agents",
    },
    codeZone: { type: String, required: true },
    typeImage: {
      type: String,
      required: [true, "Veuillez renseigner le type d'image"],
    },
    coordonnes: { type: coordonne, required: false },
    statut: {
      type: String,
      required: [true, "Le statut du client svp!"],
      enum: ["allumer", "eteint"],
    },
    raison: { type: String, required: false },
    adresse: { type: String, required: [true, "L'adresse du client svp !"] },
    codeclient: { type: String, required: false },
    file: { type: String, required: [true, "Envoies la capture svp !"] },
    concerne : {type:String, required:false},
    conversation : {type:[conversatn], required:false}
   
  },
  {
    timestamps: true,
  }
);
const model = mongoose.model("Demande", schema);
module.exports = model;
