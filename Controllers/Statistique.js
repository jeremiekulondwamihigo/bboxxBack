const modelDemande = require("../Models/Demande");

module.exports = {
  readPeriodeGroup: (req, res) => {
    try {
      const { codeAgent } = req.params;
      let lookupDemande = codeAgent === "tout" ? {
        $lookup: {
          from: "demandes",
          localField:"_id",
          foreignField:"lot",
          as: "demande",
        },
      } : {
        $lookup: {
          from: "demandes",
          pipeline: [{ $match: { codeAgent } }],
          as: "demande",
        },
      }
      modelDemande
        .aggregate([
          { $group: { _id: "$lot" } },
          lookupDemande,
          {
            $lookup: {
              from: "reponses",
              localField: "demande.idDemande",
              foreignField: "idDemande",

              as: "reponse",
            },
          },
        ])
        .then((response) => {
          if (response) {
           res.send(response);
          }
          
        });
    } catch (error) {
      console.log(error);
    }
  },
};
