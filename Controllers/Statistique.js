const modelReponse = require('../Models/Reponse')

module.exports = {
  readPeriodeGroup: (req, res) => {
    try {
      modelReponse
        .aggregate([{ $group: { _id: '$text' } }])
        .then((response) => {
          res.send(response)
        })
    } catch (error) {
      console.log(error)
    }
  },
}
