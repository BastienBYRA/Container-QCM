import { Question } from "../database/question.schema.mjs";

export class MongoRepository {
  getAll() {
    return new Promise((resolve, reject) => {
      Question.aggregate([{ $sample: { size: 3 } }], (err, questions) => {
        if (err) {
          console.log("ERR CAN'T GET DATA");
          reject(err);
        } else {
          console.log("DATA SUCCESSFUL");
          console.log(questions.length);
          resolve(questions.map((question) => question.toObject()));
        }
      });
    });
  }

  getThreeRandomQuestions() {
    return new Promise((resolve, reject) => {
      Question.find((err, questions) => {
        if (err) {
          console.log("!! ERR CAN'T GET DATA");
          reject(err);
        } else {
          console.log("!! DATA SUCCESSFUL");
          console.log(questions.length);
          resolve(questions.map((question) => question.toObject()));
        }
      });
    });
  }
}
