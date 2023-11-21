"use strict";

const express = require("express");
const path = require("path");
const cors = require("cors");
const dotenv = require("dotenv");
const connectDB = require("./config/Connection");
const app = express();
dotenv.config();
app.use(cors());
const bodyParser = require("body-parser");

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true, limit:'200mb' }));


const port = process.env.PORT || 5000;
connectDB();
const bboxx = require("./Routes/Route");
app.use("/bboxx/support", bboxx);
app.use("/bboxx/image", express.static(path.resolve(__dirname, "Images")));

// Middleware

//Start server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

// // Socket.IO
