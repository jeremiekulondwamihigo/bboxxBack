const express = require("express");
const router = express.Router();
const { Zone, ReadZone, AffecterZone } = require("../Controllers/Zone");
const { protect } = require("../MiddleWare/protect");
const { AddAgent, ReadAgent, BloquerAgent } = require("../Controllers/Agent");
const { login, readUser, resetPassword } = require("../Controllers/Login");
const { demande, DemandeAttente, ToutesDemande, ToutesDemandeAgent } = require("../Controllers/Demande");
const { Parametre, ReadParametre } = require("../Controllers/Parametre");

const multer = require('multer');
const { reponse, OneReponse, updateReponse } = require("../Controllers/Reponse");
const {Rapport} = require("../Controllers/Rapport");
const { Reclamation, ReadReclamation } = require("../Controllers/Reclamation");

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
router.get("/reclamation/:id", ReadReclamation)

router.get("/parametreRead", ReadParametre)
router.get("/touteDemande/:id", ToutesDemande)
//Rapport visite ménage
router.post("/rapport", Rapport)
router.get("/oneReponse/:id", OneReponse)
//Create

router.post("/paramatre", Parametre);
router.post("/postzone", Zone);
router.post("/postAgent", AddAgent);
router.post("/reponsedemande", reponse)
router.post("/reclamation", Reclamation)
//Update
router.put("/zone", AffecterZone)
router.put("/reponse", updateReponse)
router.put("/bloquer", BloquerAgent)
router.put("/reset", resetPassword)

//Mobiles
router.get("/demandeReponse/:id",ToutesDemandeAgent)
router.get("/readDemande/:id/:valide", DemandeAttente);
router.post("/demande", upload.single("file"), demande);


router.post("/demandeImage", upload.single("file"));

router.post("/login", login);

module.exports = router;
