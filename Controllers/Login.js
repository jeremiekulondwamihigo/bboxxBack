const { ObjectId } = require("mongodb");
const ModelAgent = require("../Models/Agent");
const jwt = require("jsonwebtoken");
const asyncLab = require("async");
const { response } = require("express");

exports.login = async (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(201).json("Veuillez renseigner les champs");
  }
  try {
    //const user = await Model_User.aggregate([ look])
    const user = await ModelAgent.findOne({
      codeAgent: username,
      active: true,
    }).select("+password");

    if (!user) {
      return res.status(201).json("Accès non autorisée");
    }

    const isMatch = await user.matchPasswords(password);

    if (!isMatch) {
      return res.status(201).json("Accès non autorisée");
    }

    sendToken(user, 200, res);
  } catch (error) {
    res.status(404).json({ success: false, error: error.message });
  }
};
exports.readUser = (req, res) => {
  try {
    let token;
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith("Bearer")
    ) {
      token = req.headers.authorization.split(" ")[1];
    }
    if (token === "null") {
      return res.status(200).json(false);
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    ModelAgent.findOne(
      { _id: new ObjectId(decoded.id), active: true },
      { password: 0 }
    )
      .then((response) => {
        if (response) {
          return res.status(200).json(response);
        } else {
          return res.status(201).json("Accès non autorisée");
        }
      })
      .catch(function (err) {
        console.log(err);
      });
  } catch (error) {}
};
exports.resetPassword = (req, res) => {
  try {
    const { id } = req.body;
    asyncLab.waterfall(
      [
        function (done) {
          ModelAgent.findById(id).then((response) => {
            if (response) {
              done(null, response);
            } else {
              return res.status(201).json("Agent introuvable");
            }
          });
        },
        function (agent, done) {
          ModelAgent.findByIdAndDelete(agent._id).then((repose) => {
            if (repose) {
              done(null, agent);
            }
          });
        },
        function (agent, done) {
          const {
            nom,
            codeAgent,
            codeZone,
            fonction,
            shop,
            telephone,
            active,
            zones,
          } = agent;
          ModelAgent.create({
            nom,
            codeAgent,
            codeZone,
            fonction,
            password:"1234",
            shop,
            telephone,
            active,
            zones,
            id: new Date(),
          }).then((response) => {
            done(response);
          });
        },
      ],
      function (response) {
        if (response) {
          return res.status(200).json("Opération effectuée");
        }
      }
    );
  } catch (error) {
    console.log(error);
  }
};

const sendToken = (user, statusCode, res) => {
  return res.status(statusCode).json(user);
};
