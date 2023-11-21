const modelDemande = require("../Models/Demande");
const modelAgent = require("../Models/Agent");
const asyncLab = require("async");
const { isEmpty, generateNumber } = require("../Static/Static_Function");


module.exports = {
  demande: (req, res) => {
    
     
      try {
        const {
          codeAgent,
          codeZone,
          codeclient,
          typeImage,
          latitude,
          altitude,
          longitude,
          statut,
          raison,
          adresse,
          file,
        } = req.body;
        const { filename } = req.file;
        let annee = new Date().getFullYear().toString();
  
        const idDemande = `${annee.substr(
          2,
          3
        )}${new Date().getMonth()}${generateNumber(5)}`;
        if (
          isEmpty(codeAgent) ||
          isEmpty(codeZone) ||
          isEmpty(typeImage) ||
          isEmpty(statut) ||
          isEmpty(adresse)
        ) {
          return res.status(200).json("Veuillez renseigner les champs");
        }
        asyncLab.waterfall(
          [
            function (done) {
              modelAgent
                .findOne({ codeAgent, active: true })
                .then((agentFound) => {
                  console.log(agentFound)
                  if (agentFound) {
                    done(null, agentFound);
                  } else {
                    return res.status(400).json("Agent introuvable");
                  }
                })
                .catch(function (err) {
                  return res.status(400).json("Erreur");
                });
            },
            function (agent, done) {
              modelDemande
                .findOne({ idDemande })
                .then((response) => {
                  if (response) {
                    return res.status(200).json("Veuillez relancer la demande");
                  } else {
                    done(null, agent);
                  }
                })
                .catch(function (err) {
                  console.log(err);
                  return res.status(200).json("Erreur");
                });
            },
  
            function (agent, done) {
          
             
              modelDemande
                .create({
                  codeAgent: agent.codeAgent,
                  codeZone,
                  typeImage,
                  coordonnes: { latitude, altitude, longitude },
                  statut,
                  raison,
                  adresse,
                  codeclient,
                  file,
                  idDemande,
                 
                  file: filename,
                })
                .then((demande) => {
               
                  if (demande) {
                    
                    done(demande);
                  } else {
                    return res
                      .status(200)
                      .json("Erreur d'enregistrement de la demande");
                  }
                })
                .catch(function (err) {
                  console.log(err)
                  if (err.message) {
                    return res.status(400).json(err.message.split(":")[2]);
                  } else {
                    return res.status(200).json("Erreur");
                  }
                });
            },
          ],
          function (demande) {
          
            return res.status(200).json(demande);
          }
        );
      } catch (error) {
        return res.status(200).json("Erreur");
      }
      
  
   
  },
  DemandeAttente: (req, res) => {
    try {
      const { id, valide } = req.params;
      let value = valide === "1" ? true : false;

      modelDemande
        .aggregate([
          { $match: { codeAgent: id, valide: value } },
          {
            $lookup: {
              from: "agents",
              localField: "codeAgent",
              foreignField: "codeAgent",
              as: "agent",
            },
          },
          {
            $lookup: {
              from: "zones",
              localField: "codeZone",
              foreignField: "idZone",
              as: "zone",
            },
          },
          { $unwind: "$agent" },
          { $unwind: "$zone" },
        ])
        .then((response) => {
          return res.status(200).json(response);
        })
        .catch(function (err) {
          console.log(err);
        });
    } catch (error) {
      console.log(error);
    }
  },
  ToutesDemande: (req, res) => {
    try {
      const { id } = req.params;
      const valide = id === "1" ? true : false;

      modelDemande
        .aggregate([
          { $match: { valide,  } },
          {
            $lookup: {
              from: "agents",
              localField: "codeAgent",
              foreignField: "codeAgent",
              as: "agent",
            },
          },

          {
            $lookup: {
              from: "zones",
              localField: "codeZone",
              foreignField: "idZone",
              as: "zone",
            },
          },
          {
            $lookup: {
              from: "reponses",
              localField: "idDemande",
              foreignField: "idDemande",
              as: "reponse",
            },
          },
          { $unwind: "$agent" },
          { $unwind: "$zone" },
        ])
        .then((response) => {
          return res.status(200).json(response);
        })
        .catch(function (err) {
          console.log(err);
        });
    } catch (error) {
      console.log(error);
    }
  },
  ToutesDemandeAgent: (req, res) => {
    try {
      const { id } = req.params;
      modelDemande
        .aggregate([
          { $match: { codeAgent: id } },
          {
            $lookup: {
              from: "reponses",
              localField: "idDemande",
              foreignField: "idDemande",
              as: "reponse",
            },
          },
          {
            $lookup : {
              from :"reclamation",
              localField:"idDemande",
              foreignField:"idDemande",
              as :"conversation"
            }
          }
        ])
        .then((response) => {
          return res.status(200).json(response);
        })
        .catch(function (err) {
          console.log(err);
        });
    } catch (error) {
      console.log(error);
    }
  },

};
