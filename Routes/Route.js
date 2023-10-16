const express = require("express");
const router = express.Router();
const { Zone, ReadZone } = require("../Controllers/Zone");
const { protect } = require("../MiddleWare/protect");
const { AddAgent, ReadAgent } = require("../Controllers/Agent");
const { login, readUser } = require("../Controllers/Login");
const { demande, DemandeAttente, ToutesDemande } = require("../Controllers/Demande");
const { Parametre, ReadParametre } = require("../Controllers/Parametre");

const multer = require('multer');
const { reponse } = require("../Controllers/Reponse");

var storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'Images/')
  },
  filename: (req, file, cb) => {
    const image = file.originalname.split('.')

    cb(null, `${Date.now()}.${image[1]}`)
  },
  fileFilter: (req, file, cb) => {
    const ext = path.extname(file.originalname)

    if (ext !== '.jpg' || ext !== '.png') {
      return cb(res.status(400).end('only jpg, png are allowed'), false)
    }
    cb(null, true)
  },
})
var upload = multer({ storage: storage })
//Read
router.get("/zone", ReadZone);
router.get("/agent", ReadAgent);
router.get("/user", readUser);
router.get("/readDemande/:id/:valide", DemandeAttente);
router.get("/parametreRead", ReadParametre)
//Update
router.get("/touteDemande/:id", ToutesDemande)
//Delete

//Create
router.post("/login", login);
router.post("/paramatre", Parametre);
router.post("/postzone", Zone);
router.post("/postAgent", AddAgent);
router.post("/demande", upload.single("file"), demande);
router.post("/reponsedemande", reponse)

module.exports = router;
