import express from "express";
import cors from "cors";
import helmet from "helmet";
import dotenv from "dotenv";
import connectToDB from "./db/db";
import { login, refreshToken, signup } from "./controllers/user_controller";
import { createContact, deleteContact, getContacts, updateContact } from "./controllers/contacts_controller";
import { authorization } from "./middleware/auth";

dotenv.config();
const PORT: number = parseInt(process.env.PORT as string, 10);
const DB_URI = process.env.MONGO as string;

const app = express();

connectToDB(DB_URI);

app.use(express.json());
app.use(cors());
app.use(helmet());

app.post("/login", login);
app.post("/signup", signup);
app.post("/refresh-token", authorization, refreshToken);
app.get("/", (_, res) => res.send("Hello World"));
app.post("/createContact", authorization, createContact);
app.get("/contacts", authorization, getContacts);
app.put("/updateContact", authorization, updateContact);
app.delete("/deleteContact", authorization, deleteContact);

app.listen(PORT, () => console.log(`Listening at port: ${PORT}`));
