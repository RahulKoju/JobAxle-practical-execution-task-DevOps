const express = require("express");
const app = express();
const PORT = process.env.PORT || 3000;

app.get("/", (req, res) =>
  res.json({ message: "Hello from DevOps Node App!" }),
);
app.get("/health", (req, res) => res.json({ status: "ok" }));
app.get("/users", (req, res) => res.json({ users: ["Ram", "Shyam"] }));

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
