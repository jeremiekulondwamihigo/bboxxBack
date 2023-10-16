const jwt = require("jsonwebtoken");
const Model_Agent = require("../Models/Agent");

module.exports = {
  protect: async (req, res, next) => {
    let token;
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith("Bearer")
    ) {
      token = req.headers.authorization.split(" ")[1];
    }

    if (!token) {
      return res.status(404).json("Token invalide");
    }

    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      const user = await Model_Agent.findById(decoded.id);

      if (!user) {
        return res.status(404).json("Token invalide");
      }

      req.user = user ? user : null;
      next();
    } catch (error) {
      return res.status(404).json("Token invalide");
    }
  },
};
