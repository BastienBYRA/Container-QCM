import { Router } from "express";

export const routes = (controller) => {
  const router = Router();

  router.get("/", (req, res) => {
    controller.getThreeQuestions(req, res);
  });

  return router;
};
