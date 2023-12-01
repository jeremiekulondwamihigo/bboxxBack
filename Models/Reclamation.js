const mongoose = require("mongoose");

const conversatn = new mongoose.Schema(
  {
    sender: { type: String, required: true },
    code : {type:mongoose.Types.ObjectId, required:true},
    message: { type: String, required: true },
    valide: { type: Boolean, required: true, default: false },
    codeAgent: { type: String, required: true },
  },
  { timestamps: true }
);

const model = mongoose.model("Conversation", conversatn);
module.exports = model;
