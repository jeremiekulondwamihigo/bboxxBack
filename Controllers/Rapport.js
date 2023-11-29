const ModelReponse = require("../Models/Reponse");
const asyncLab = require("async");

module.exports = {
  Rapport: (req, res) => {
    try {
      const { debut, fin } = req.body;
      console.log(req.body)
      if (!debut || !fin) {
        return res
          .status(200)
          .json({ error: true, message: "Veuillez renseigner les dates" });
      }
      let matches = {
        $match: {
          dateSave: {
            $gte: new Date(debut),
            $lte: new Date(fin),
          },
        },
      };
      let lookAgent = {
        $lookup: {
          from: "agents",
          localField: "codeAgent",
          foreignField: "codeAgent",
          as: "agent",
        },
      };
      let lookDemande = {
        $lookup: {
          from: "demandes",
          localField: "idDemande",
          foreignField: "idDemande",
          as: "demande",
        },
      };
    
      let unwindDemande = { $unwind: "$demande" };
      let unwindDemandeur = { $unwind: "$demandeur" };
      let unwindagent = { $unwind: "$agent" };
      let lookDemandeur = {
        $lookup: {
          from: "agents",
          localField: "demande.codeAgent",
          foreignField: "codeAgent",
          as: "demandeur",
        },
      };

      let project = {
        $project: {
          codeClient: 1,
          codeCu: 1,
          clientStatut: 1,
          PayementStatut: 1,
          consExpDays: 1,
          jOrH: 1,
          "demandeur.nom": 1,
          "demandeur.codeAgent": 1,
          "demandeur.fonction": 1,
          "agent.nom": 1,
          "demande.typeImage": 1,
          "demande.createAt": 1,
          createdAt: 1,
          "demande.coordonnes": 1,
          "demande.statut": 1,
          "demande.province": 1,
          "demande.country": 1,
          "demande.sector": 1,
          "demande.cell": 1,
          "demande.reference": 1,
          "demande.sat": 1,
          "demande.createdAt": 1,
          "demande.raison": 1,
          nomClient: 1,
          region: 1,
          shop: 1,
        },
      };
      let sort = {
        $sort: { createdAt: -1 },
      };
      asyncLab.waterfall([
        function (done) {
          ModelReponse.aggregate([
            matches,
            lookDemande,
            unwindDemande,
            lookDemandeur,
            lookAgent,
            unwindDemandeur,
            unwindagent,
            project,
            sort,
          ]).then((response) => {
            console.log(response);
            return res.status(200).json(response.reverse());
          });
        },
      ]);
    } catch (error) {
      console.log(error);
    }
  },
};
