const asyncLab = require('async')
const modelDemande = require('../Models/Demande')
const modelReclamation = require('../Models/Reclamation')
const { ObjectId } = require('mongodb')
const _ = require('lodash')

module.exports = {
  Reclamation: (req, res) => {
    try {
      const { _id, message, sender, codeAgent } = req.body
      if (!_id || !message || !sender || !codeAgent) {
        return res.status(201).json('Error')
      }
      asyncLab.waterfall(
        [
          function (done) {
            modelReclamation
              .create({
                message,codeAgent,
                sender,
                code : new ObjectId(_id),
              })
              .then((response) => {
                if (response) {
                  done(response)
                }
              })
              .catch(function (errr) {
                console.log(errr)
                if (errr) {
                  return res.status(201).json('Try again')
                }
              })
          },
        ],
        function (result) {
          return res.status(200).json(result)
        },
      )
    } catch (error) {
      console.log(error)
    }
  },
  ReadMessage: (req, res) => {
    try {
      const {id} = req.params
      modelReclamation
        .aggregate([
          {
            $match : {codeAgent : id}
          },
          {
            $lookup: {
              from: 'demandes',
              localField: 'code',
              foreignField: '_id',
              as: 'demandeId',
            },
          },
          {
            $lookup: {
              from: 'reponses',
              localField: 'code',
              foreignField: '_id',
              as: 'reponseId',
            },
          },
        ])
        .then((response) => {
          return res.status(200).json(response)
        })
    } catch (error) {
      console.log(error)
    }
  },
  MakeFalse: (req, res) => {
    try {
      const { id } = req.params
      modelReclamation
        .findByIdAndUpdate(id, { $set: { valide: true } }, { new: true })
        .then((response) => {
          if (response) {
            return res.status(200).json(response)
          }
        })
        .catch(function (err) {
          console.log(err)
        })
    } catch (error) {
      console.log(error)
    }
  },
}
