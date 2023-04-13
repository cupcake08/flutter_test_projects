"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.refreshToken = exports.signup = exports.login = void 0;
const user_1 = __importDefault(require("../models/user"));
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const login = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const user = new user_1.default(req.body);
        const foundUser = yield user_1.default.findOne({ email: user.email });
        if (!foundUser) {
            return res.status(404).send({ message: "Account not found" });
        }
        const isMatch = yield bcryptjs_1.default.compare(user.password, foundUser.password);
        if (isMatch) {
            const token = jsonwebtoken_1.default.sign({ id: foundUser._id }, process.env.JWT_SECRET, {
                expiresIn: "2 days",
            });
            return res.status(200).send({ message: "Login Success", foundUser, authToken: token });
        }
        return res.status(401).send({ message: "Incorrect credentials" });
    }
    catch (error) {
        console.log(error);
        return res.status(500).send({ message: "Internal server error" });
    }
});
exports.login = login;
const signup = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const user = new user_1.default(req.body);
        const newUser = yield user.save();
        user.save().then(() => {
            const token = jsonwebtoken_1.default.sign(newUser, process.env.JWT_SECRET, {
                expiresIn: "2 days",
            });
            return res.status(201).send({ message: "User created successfully", newUser, authToken: token });
        }).catch((_) => res.status(401).send({ message: "Account already exist!" }));
    }
    catch (error) {
        console.log(error);
        return res.status(500).send({ message: "Internal server error" });
    }
});
exports.signup = signup;
const refreshToken = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { token } = req.headers;
        const decoded = jsonwebtoken_1.default.verify(token, process.env.JWT_SECRET);
        const newToken = jsonwebtoken_1.default.sign(decoded, process.env.JWT_SECRET, {
            expiresIn: "2 days",
        });
        return res.status(200).send({ token: newToken });
    }
    catch (error) {
        console.log(error);
        return res.status(500).send({ message: "Internal server error" });
    }
});
exports.refreshToken = refreshToken;
