"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const dotenv_1 = __importDefault(require("dotenv"));
const db_1 = __importDefault(require("./db/db"));
const user_controller_1 = require("./controllers/user_controller");
const contacts_controller_1 = require("./controllers/contacts_controller");
const auth_1 = require("./middleware/auth");
dotenv_1.default.config();
const PORT = parseInt(process.env.PORT, 10);
const DB_URI = process.env.MONGO;
const app = (0, express_1.default)();
app.use(express_1.default.json());
app.use((0, cors_1.default)());
app.use((0, helmet_1.default)());
app.post("/login", user_controller_1.login);
app.post("/signup", user_controller_1.signup);
app.post("/refresh-token", auth_1.authorization, user_controller_1.refreshToken);
app.get("/", (_, res) => res.send("Hello World"));
app.post("/createContact", auth_1.authorization, contacts_controller_1.createContact);
app.get("/contacts", auth_1.authorization, contacts_controller_1.getContacts);
app.put("/updateContact", auth_1.authorization, contacts_controller_1.updateContact);
app.delete("/deleteContact", auth_1.authorization, contacts_controller_1.deleteContact);
(0, db_1.default)(DB_URI)
    .then(() => app.listen(PORT, () => console.log(`Listening at port: ${PORT}`)))
    .catch((err) => console.log(err));
