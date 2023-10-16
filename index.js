"use strict";

const express = require("express");
const path = require("path");
const cors = require("cors");
const dotenv = require("dotenv");
const http = require("http");
const { Server } = require("socket.io");
const asyncLab = require("async");
const connectDB = require("./config/Connection");
const { isEmpty, generateString } = require("./Static/Static_Function");
const app = express();
dotenv.config();
app.use(cors());
const bodyParser = require("body-parser");
app.use(bodyParser.urlencoded({ limit: "50mb", extended: false }));
app.use(bodyParser.json());

const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "http://localhost:5173",
    methods: ["GET", "POST"],
  },
});
const port = process.env.PORT || 5000;

const bboxx = require("./Routes/Route");
app.use("/bboxx/support", bboxx);
app.use("/bboxx/image", express.static(path.resolve(__dirname, "Images")));

// Middleware

app.use(express.json());
connectDB();
// API Routes
// const messagesRouter = require("./Routes/Route");
// app.use('/messages', messagesRouter);

// // Start server
server.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

// // Socket.IO
io.on("connection", (socket) => {
  // socket.on("sendDemande", (message) => {
  //   try {
  //     const {
  //       codeAgent,
  //       codeZone,
  //       codeclient,
  //       typeImage,
  //       latitude,
  //       altitude,
  //       longitude,
  //       dateSave,
  //       statut,
  //       raison,
  //       adresse,
  //       file,
  //     } = message;
  //     const idDemande = `${new Date().getMonth()}${generateString(7)}`;
  //     if (
  //       isEmpty(codeAgent) ||
  //       isEmpty(codeZone) ||
  //       isEmpty(typeImage) ||
  //       isEmpty(statut) ||
  //       isEmpty(adresse) ||
  //       isEmpty(dateSave)
  //     ) {
  //     }
  //     asyncLab.waterfall(
  //       [
  //         function (done) {
  //           modelAgent
  //             .findOne({ codeAgent })
  //             .then((agentFound) => {
  //               if (agentFound) {
  //                 done(null, agentFound);
  //               } else {
  //               }
  //             })
  //             .catch(function (err) {
  //               console.log(err);
  //             });
  //         },
  //         function (agent, done) {
  //           ModelDemande.findOne({ idDemande })
  //             .then((response) => {
  //               if (response) {
  //                 return res.status(200).json("Veuillez relancer la demande");
  //               } else {
  //                 done(null, agent, response);
  //               }
  //             })
  //             .catch(function (err) {
  //               console.log(err);
  //               return res.status(200).json("Erreur two");
  //             });
  //         },
  //         function (agent, response, done) {
  //           ModelMoi.findOne({ active: true })
  //             .then((mois) => {
  //               if (mois) {
  //                 done(null, mois);
  //               } else {
  //               }
  //             })
  //             .catch(function (err) {
  //               console.log(err);
  //             });
  //         },
  //         function (mois, done) {
  //           ModelDemande.create({
  //             codeAgent,
  //             codeZone,
  //             typeImage,
  //             codeMoi: mois.id,
  //             coordonnes: { latitude, altitude, longitude },
  //             statut,
  //             raison,
  //             adresse,
  //             codeclient,
  //             file,
  //             idDemande,
  //             dateSave,
  //           })
  //             .then((demande) => {
  //               if (demande) {
  //                 done(demande);
  //               } else {
  //               }
  //             })
  //             .catch(function (err) {});
  //         },
  //       ],
  //       function (demande) {
      
  //         ModelDemande.aggregate([
  //           { $match: { _id: demande._id } },
  //           {
  //             $lookup: {
  //               from: "agents",
  //               localField: "codeAgent",
  //               foreignField: "codeAgent",
  //               as: "agent",
  //             },
  //           },
  //           {
  //             $lookup: {
  //               from: "zones",
  //               localField: "codeZone",
  //               foreignField: "idZone",
  //               as: "zone",
  //             },
  //           },
  //           { $unwind: "$agent" },
  //           { $unwind: "$zone" },
  //         ]).then((response) => {
  //           if (response) {
  //             io.emit("messageDemande", response);
  //           }
  //         });
  //       }
  //     );
  //   } catch (error) {
  //     console.log(error);
  //     return res.status(200).json("Erreur quatre");
  //   }
  // });
  // socket.on("sendMessage", (message) => {
  //   try {
  //     const {
  //       idDemande,
  //       codeClient,
  //       codeCu,
  //       clientStatut,
  //       PayementStatut,
  //       consExpDays,
  //       text,
  //     } = message;

  //     if (
  //       isEmpty(idDemande) ||
  //       isEmpty(codeClient) ||
  //       isEmpty(clientStatut) ||
  //       isEmpty(PayementStatut) ||
  //       isEmpty(consExpDays) ||
  //       isEmpty(text)
  //     ) {
  //     }
  //     asyncLab.waterfall([
  //       function (done) {
  //         ModelDemande.findOne({ idDemande })
  //           .then((response) => {
  //             if (response) {
  //               done(null, response);
  //             } else {
  //             }
  //           })
  //           .catch(function (err) {});
  //       },
  //       function (demande, done) {
  //         ModelReponse.create({
  //           idDemande: demande.idDemande,
  //           codeClient,
  //           codeCu,
  //           clientStatut,
  //           PayementStatut,
  //           consExpDays,
  //           text,
  //           dateSave: new Date(),
  //         })
  //           .then((response) => {
  //             if (response) {
  //               done(null, response);
  //             } else {
  //             }
  //           })
  //           .catch(function (err) {});
  //       },
  //       function (response, done) {
  //         if (response) {
  //           ModelDemande.aggregate([
  //             { $match: { idDemande: response.idDemande } },
  //             {
  //               $lookup: {
  //                 from: "reponses",
  //                 localField: "idDemande",
  //                 foreignField: "idDemande",
  //                 as: "reponse",
  //               },
  //             },
  //           ]).then((respo) => {
  //             if (respo) {
  //               io.emit("message", respo);
  //             }
  //           });

  //           // return res.status(200).json(response);
  //         }
  //       },
  //     ]);
  //   } catch (error) {
  //     console.log(error);
  //   }
  // });

  socket.on("disconnect", () => {
    console.log(`Socket ${socket.id} disconnected`);
  });
});
