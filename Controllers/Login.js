const ModelAgent = require("../Models/Agent");
const jwt = require("jsonwebtoken");
exports.login = async (req, res, next) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(200).json("Veuillez renseigner les champs");
  }
  try {
    //const user = await Model_User.aggregate([ look])
    const user = await ModelAgent.findOne({
      codeAgent: username,
   
    }).select("+password");

    if (!user) {
      return res.status(200).json("Identification incorrecte");
    }

    const isMatch = await user.matchPasswords(password);

    if (!isMatch) {
      return res.status(200).json("Identification incorrecte");
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

    ModelAgent.findById(decoded.id, { password: 0 })
      .then((response) => {
        if (response) {
          return res.status(200).json(response);
        } else {
          return res.status(200).json(false);
        }
      })
      .catch(function (err) {
        console.log(err);
      });
  } catch (error) {}
};

const sendToken = (user, statusCode, res) => {
  
  return res.status(statusCode).json(user);
};
