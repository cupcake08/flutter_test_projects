import express from "express";
import cors from "cors";
import helmet from "helmet";
import dotenv from "dotenv";
import connectToDB from "./db/db";

dotenv.config();
const PORT : number = parseInt(process.env.PORT as string,10);
const DB_URI = process.env.MONGO as string;

const app = express();

connectToDB(DB_URI);

app.use(cors());
app.use(helmet());

app.listen(PORT,() => console.log(`Listening at port: ${PORT}`));
