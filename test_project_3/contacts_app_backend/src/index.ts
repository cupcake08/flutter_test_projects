import express from "express";
import cors from "cors";
import helmet from "helmet";
import dotenv from "dotenv";
import connectToDB from "./db/db";
import { login, refreshToken, signup } from "./controllers/user_controller";
import { getContacts } from "./controllers/contacts_controller";

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
app.post("/refresh-token", refreshToken);

app.get("/", (_, res) => res.send("Hello World"));
app.get("/contacts", getContacts);

app.listen(PORT, () => console.log(`Listening at port: ${PORT}`));
