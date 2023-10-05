import { mongoose } from "mongoose";

const responseSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  isCorrect: {
    type: Boolean,
    required: true,
  },
});

const questionSchema = new mongoose.Schema({
  question: {
    type: String,
    required: true,
  },
  responses: [responseSchema], // Les réponses sont imbriquées dans le modèle de question
});

export const Question = mongoose.model("Question", questionSchema);
