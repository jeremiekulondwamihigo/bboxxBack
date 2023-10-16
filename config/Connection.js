const mongoose = require('mongoose')

const connectDB = async () => {
  await mongoose.connect(process.env.MONGO_LOCAL, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    // useFindAndModify: false,
    // useCreateIndex: true,
  })
  console.log('MongoDB connect')
}

module.exports = connectDB
