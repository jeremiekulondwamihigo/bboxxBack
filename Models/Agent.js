const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const UserSchema = new mongoose.Schema(
  {
    nom: { type: String, required: true },
    codeAgent: { type: String, required: true, unique: true, trim: true },
    codeZone: { type: String, required: true },
    fonction: {
      type: String,
      required: true,
      enum: ["admin", "co", "tech", "agent"],
    },
    password: { type: String, required: true, default: 1234 },
    shop: { type: String, required: false },
    telephone: { type: String, required: false },
    active: { type: Boolean, required: true, default: true },
    zones: { type: Array, required: false },
    id: { type: Date, required: true },
  },
  { timestamps: true }
);
UserSchema.pre("save", async function (next) {
  if (!this.isModified("password")) {
    next();
  }
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

UserSchema.methods.matchPasswords = async function (password) {
  return await bcrypt.compare(password, this.password);
};

UserSchema.methods.getSignedToken = function () {
  return jwt.sign(
    { id: this._id, fonction: this.fonction, codeAgent: this.codeAgent },
    process.env.JWT_SECRET,
    {
      expiresIn: process.env.JWT_EXPIRE,
    }
  );
};

const model = mongoose.model("Agent", UserSchema);
module.exports = model;
