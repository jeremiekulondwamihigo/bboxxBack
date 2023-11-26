const modelDemande = require('../Models/Demande')
const modelAgent = require('../Models/Agent')
const asyncLab = require('async')
const { generateNumber } = require('../Static/Static_Function')
const ModelPeriode = require("../Models/Periode")

module.exports = {
  demande: (req, res) => {
    try {
      const {
        codeAgent,
        codeZone,
        codeclient,
        typeImage,
        latitude, // si la photo est prise dans l'appli ce champs est obligatoire sinon il n'est pas obligatoire
        altitude, // si la photo est prise dans l'appli ce champs est obligatoire sinon il n'est pas obligatoire
        longitude, // si la photo est prise dans l'appli ce champs est obligatoire sinon il n'est pas obligatoire
        statut,
        raison,
        // N'oublies pas de supprimer la propriété "adresse" car elle n'existe plus,
        file,
        province, //Placeholder = Province
        country, // placeholder = Country/District
        sector, //placeholder = Sector/constituency
        cell, //placeholder = Cell/Ward
        reference, //placeholder = Reference
        sat, //placeholder = SAT
      } = req.body
      const { filename } = req.file
      let annee = new Date().getFullYear().toString()

      const idDemande = `${annee.substr(
        2,
        3,
      )}${new Date().getMonth()}${generateNumber(5)}`
      if (
        !codeAgent ||
        !codeZone ||
        !typeImage ||
        !statut ||
        !province ||
        !country ||
        !sector ||
        !cell ||
        !reference ||
        !sat
      ) {
        return res.status(201).json('Veuillez renseigner les champs')
      }
      asyncLab.waterfall(
        [
          function (done) {
            modelAgent
              .findOne({ codeAgent, active: true })
              .then((agentFound) => {
                if (agentFound) {
                  done(null, agentFound)
                } else {
                  return res.status(201).json('Agent introuvable')
                }
              })
              .catch(function (err) {
                return res.status(201).json('Erreur')
              })
          },
         
          function (agent, done) {
            modelDemande
              .findOne({ idDemande })
              .then((response) => {
                if (response) {
                  return res.status(201).json('Veuillez relancer la demande')
                } else {
                  done(null, agent)
                }
              })
              .catch(function (err) {
                
                return res.status(201).json('Erreur')
              })
          },
          function(agent, done){
            ModelPeriode.findOne({})
              .limit(1)
              .then((response) => {
                if (response) {
                  done(null, agent, response);
                } else {
                  return res.status(201).json("Aucune période en cours");
                }
              })
              .catch(function (err) {
                return res.status(201).json("Erreur");
              });
          },

          function (agent, periode, done) {
            modelDemande
              .create({
                codeAgent: agent.codeAgent,
                codeZone,
                typeImage,
                coordonnes: { latitude, altitude, longitude },
                statut,
                raison,
                codeclient,
                file,
                lot : periode.periode,
                idDemande,
                province,
                country,
                sector,
                cell,
                reference,
                sat,
                file: filename,
              })
              .then((demande) => {
                if (demande) {
                  done(demande)
                } else {
                  return res
                    .status(201)
                    .json("Erreur d'enregistrement de la demande")
                }
              })
              .catch(function (err) {
                if (err.message) {
                  return res.status(201).json(err.message.split(':')[2])
                } else {
                  return res.status(201).json('Erreur')
                }
              })
          },
        ],
        function (demande) {
          return res.status(200).json(demande)
        },
      )
    } catch (error) {
      console.log(error)
      return res.status(200).json('Erreur')
    }
  },
  DemandeAttente: (req, res) => {
    try {
      const { id, valide } = req.params
      let value = valide === '1' ? true : false

      modelDemande
        .aggregate([
          { $match: { codeAgent: id, valide: value } },
          {
            $lookup: {
              from: 'agents',
              localField: 'codeAgent',
              foreignField: 'codeAgent',
              as: 'agent',
            },
          },
          {
            $lookup: {
              from: 'zones',
              localField: 'codeZone',
              foreignField: 'idZone',
              as: 'zone',
            },
          },
          { $unwind: '$agent' },
          { $unwind: '$zone' },
        ])
        .then((response) => {
          return res.status(200).json(response)
        })
        .catch(function (err) {
          console.log(err)
        })
    } catch (error) {
      console.log(error)
    }
  },
  ToutesDemande: (req, res) => {
    try {
      const { id } = req.params
      const valide = id === '1' ? true : false

      modelDemande
        .aggregate([
          { $match: { valide } },
          {
            $lookup: {
              from: 'agents',
              localField: 'codeAgent',
              foreignField: 'codeAgent',
              as: 'agent',
            },
          },

          {
            $lookup: {
              from: 'zones',
              localField: 'codeZone',
              foreignField: 'idZone',
              as: 'zone',
            },
          },
          {
            $lookup: {
              from: 'reponses',
              localField: 'idDemande',
              foreignField: 'idDemande',
              as: 'reponse',
            },
          },
          { $unwind: '$agent' },
          { $unwind: '$zone' },
        ])
        .then((response) => {
          return res.status(200).json(response)
        })
        .catch(function (err) {
          console.log(err)
        })
    } catch (error) {
      console.log(error)
    }
  },
  ToutesDemandeAgent: (req, res) => {
    try {
      const { id } = req.params
      modelDemande
        .aggregate([
          { $match: { codeAgent: id } },
          {
            $lookup: {
              from: 'reponses',
              localField: 'idDemande',
              foreignField: 'idDemande',
              as: 'reponse',
            },
          },
          {
            $lookup: {
              from: 'reclamation',
              localField: 'idDemande',
              foreignField: 'idDemande',
              as: 'conversation',
            },
          },
        ])
        .then((response) => {
          return res.status(200).json(response)
        })
        .catch(function (err) {
          console.log(err)
        })
    } catch (error) {
      console.log(error)
    }
  },
  updateOneDemande: (req, res) => {
    try {
      const { id, value, propriete } = req.body
      modelDemande
        .findByIdAndUpdate(
          id,
          {
            $set: {
              [propriete]: value,
            },
          },
          { new: true },
        )
        .then((response) => {
          if (response) {
            return res.status(200).json(response)
          }
        })
      console.log(id, value, propriete)
    } catch (error) {}
  },
  lectureDemandeBd: (req, res) => {
    try {
      const {body} = req
      let match = {
        $match: body,
      }
      modelDemande
        .aggregate([
          match,
          {
            $lookup: {
              from: 'reponses',
              localField: 'idDemande',
              foreignField: 'idDemande',
              as: 'reponse',
            },
          },
          {
            $lookup: {
              from: 'conversations',
              localField: 'idDemande',
              foreignField: 'idDemande',
              as: 'conversation',
            },
          },
          {
            $lookup: {
              from: 'agents',
              localField: 'codeAgent',
              foreignField: 'codeAgent',
              as: 'agent',
            },
          },
          {
            $unwind : "$agent"
          }
        ])
        .then((response) => {
          if (response) {
            return res.status(200).json(response.reverse())
          }
        })
    } catch (error) {
      console.log(error)
    }
  },
  lectureDemandeMobile: (req, res) => {
    try {
      const {lot, codeAgent} = req.params
      let match = {
        $match: {lot, codeAgent},
      }
      modelDemande
        .aggregate([
          match,
          {
            $lookup: {
              from: 'reponses',
              localField: 'idDemande',
              foreignField: 'idDemande',
              as: 'reponse',
            },
          },
          {
            $lookup: {
              from: 'conversations',
              localField: 'idDemande',
              foreignField: 'idDemande',
              as: 'conversation',
            },
          },
          {
            $lookup: {
              from: 'agents',
              localField: 'codeAgent',
              foreignField: 'codeAgent',
              as: 'agent',
            },
          },
          {
            $unwind : "$agent"
          }
        ])
        .then((response) => {
          if (response) {
            return res.status(200).json(response.reverse())
          }
        })
    } catch (error) {
      console.log(error)
    }
  },
}
