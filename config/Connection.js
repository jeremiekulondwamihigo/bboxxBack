const mongoose = require('mongoose')

const connectDB = async () => {
  await mongoose.connect("mongodb://localhost:27017/Bboxx", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    // useFindAndModify: false,
    // useCreateIndex: true,
  })
  console.log('MongoDB connect')
}

module.exports = connectDB
