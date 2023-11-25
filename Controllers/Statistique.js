const modelDemande = require('../Models/Demande')

module.exports = {
  readPeriodeGroup: (req, res) => {
    try {
      modelDemande
        .aggregate([{ $group: { _id: '$lot' } }])
        .then((response) => {
          res.send(response)
        })
    } catch (error) {
      console.log(error)
    }
  },
}
