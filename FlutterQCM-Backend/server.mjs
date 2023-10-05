import express from "express";
import { engine } from "express-handlebars";
import { mongoose } from "mongoose";
import { Question } from "./src/database/question.schema.mjs";

import { routes } from "./src/routes/routes.mjs";
import { Controller } from "./src/controllers/controller.mjs";
import { MongoRepository } from "./src/repositories/repository.mjs";

import dotenv from "dotenv";
dotenv.config();

// Retrieve environment variables
const PORT = process.env.NODE_PORT || 4000;
const MONGO_PORT = process.env.MONGO_PORT || 27017;
const MONGO_CONNECTION_STRING =
  "mongodb://mongodb:" + MONGO_PORT + "/qcm?authSource=admin" ||
  "mongodb://mongodb:27017/qcm?authSource=admin";
const MONGO_ADMIN_USERNAME = process.env.MONGO_USERNAME || "admin";
const MONGO_ADMIN_PASSWORD = process.env.MONGO_PASSWORD || "password";

// Setup the application
const app = express();

console.log(PORT);

const QcmRepository = new MongoRepository();
const QcmController = new Controller(QcmRepository);

app.engine("hbs", engine({ extname: ".hbs" }));
app.set("view engine", "hbs");
app.set("views", "./src/views");

app.use(
  express.urlencoded({
    extended: true,
  })
);

app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept"
  );
  next();
});

app.use(express.json());
app.use(express.static("src/assets"));

app.use("/", routes(QcmController));

mongoose.set("strictQuery", false);

mongoose.connect(
  MONGO_CONNECTION_STRING,
  {
    user: MONGO_ADMIN_USERNAME,
    pass: MONGO_ADMIN_PASSWORD,
  },
  (error) => {
    if (error) throw error;
    console.info("Database successfully connected");
  }
);

app.listen(PORT, () => {
  console.info("Server listening on port", PORT);
});

// mongoose.connect(
//   MONGO_CONNECTION_STRING,
//   {
//     user: "admin",
//     pass: "password",
//   },
//   (error) => {
//     if (error) throw error;
//     console.info("Database successfully connected");
//   }
// );

//----------------------------------
// console.log("AAAAA");
// const response1 = {
//   name: "Réponse 1",
//   isCorrect: true,
// };

// const response2 = {
//   name: "Réponse 2",
//   isCorrect: false,
// };

// const questionData = {
//   question: "Ceci est une question ?",
//   responses: [response1, response2],
// };
// console.log("TEST");
// // Création d'une instance de Question
// const question = new Question(questionData);
// console.log("TEST 2");
// // Enregistrement de la question dans la base de données
// question.save((error, savedQuestion) => {
//   if (error) {
//     console.error("Erreur lors de l'enregistrement de la question :", error);
//   } else {
//     console.log("Question enregistrée avec succès :", savedQuestion);
//   }
// });
