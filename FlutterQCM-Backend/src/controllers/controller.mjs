export class Controller {
  repository;

  constructor(repository) {
    this.repository = repository;
  }

  getThreeQuestions(req, res) {
    this.repository
      .getThreeRandomQuestions()
      .then((questions) => {
        console.log(">>> THEN");
        res.json(questions);
      })
      .catch((err) => {
        console.log(">>> CATCH");
        console.log(err);
        res
          .sendStatus(500)
          .json({ error: "Error reading questions collection" });
      });
  }
}
