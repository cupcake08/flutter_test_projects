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
exports.deleteContact = exports.updateContact = exports.createContact = exports.getContacts = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
const contact_1 = __importDefault(require("../models/contact"));
const getContacts = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { limit, skip } = req.query;
        const result = yield contact_1.default.find({ userId: req.user._id })
            .skip(skip)
            .limit(limit ? limit : 10);
        console.log(result);
        return res.status(200).send({ message: "Contacts fetched successfully", result: result });
    }
    catch (error) {
        console.log(error);
        return res.status(500).send({ message: "Internal server error" });
    }
});
exports.getContacts = getContacts;
const createContact = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const contact = new contact_1.default(req.body);
        contact.userId = req.user._id;
        const newContact = yield contact_1.default.create(contact);
        console.log("new contact", newContact);
        return res.status(200).send({ message: "contact created", result: newContact });
    }
    catch (err) {
        console.log(err);
        res.status(500).send({ message: "Interval server error" });
    }
});
exports.createContact = createContact;
const updateContact = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.query;
        const { name, phone, countryCode } = req.body;
        const contact = yield contact_1.default.findById(id).exec();
        if (!contact) {
            return res.status(401).send({ message: "Contact Not Found" });
        }
        contact.name = name;
        contact.phone = phone;
        contact.countryCode = countryCode;
        yield contact.save();
        return res.status(200).send({ message: "User updated" });
    }
    catch (err) {
        console.log(err);
        return res.status(500).send({ message: "Internal servor error" });
    }
});
exports.updateContact = updateContact;
const deleteContact = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.query;
        const validId = mongoose_1.default.Types.ObjectId.isValid(id);
        if (!validId) {
            res.status(400).send({ message: "User id is not valid" });
        }
        yield contact_1.default.findByIdAndDelete(id).exec();
        return res.status(200).send({ message: "user deleted" });
    }
    catch (err) {
        console.log(err);
        res.status(500).send({ message: "Interval servor error" });
    }
});
exports.deleteContact = deleteContact;
