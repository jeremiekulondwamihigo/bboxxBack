const mongoose = require("mongoose");

const conversatn = new mongoose.Schema(
  {
    sender: { type: String, required: true },
    message: { type: String, required: true },
    idDemande: { type: String, required: true },
    valide: { type: Boolean, required: true, default: false },
  },
  { timestamps: true }
);

const model = mongoose.model("Conversation", conversatn);
module.exports = model;
