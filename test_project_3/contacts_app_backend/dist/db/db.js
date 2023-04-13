"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
function connectToDB(db_uri) {
    mongoose_1.default.connect(db_uri)
        .then(() => console.log("connected to DB"))
        .catch((err) => {
        console.log(err);
        process.exit(1);
    });
}
exports.default = connectToDB;
