const express = require("express");
const app = express();

app.get("/", (req, res) =>
  res.json({
    message:
      "Hello from Branch A and B merged together in develop branch simulating merge conflicts",
  }),
);

app.get("/health", (req, res) => res.json({ status: "ok" }));

app.get("/users", (req, res) => res.json({ users: ["Ram", "Shyam"] }));

module.exports = app;
