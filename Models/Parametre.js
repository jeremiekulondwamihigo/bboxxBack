const mongoose = require("mongoose")

const schema = new mongoose.Schema({
    customer : {type:String, required:true},
    customer_cu : {type:String, required:false, default :""},
    id : {type:String, required:true}
})
const model = mongoose.model("Parametre", schema)
module.exports = model