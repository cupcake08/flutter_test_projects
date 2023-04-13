import { Request, Response } from "express";
import mongoose, { Types } from "mongoose";
import ContactModel from "../models/contact";

export const getContacts = async (req: Request, res: Response) => {
    try {
        const { limit, skip } = req.query;
        const result = await ContactModel.find({ userId: req.user._id })
            .skip(skip as unknown as number)
            .limit(limit ? limit as unknown as number : 10);
        console.log(result);
        return res.status(200).send({ message: "Contacts fetched successfully", result: result });
    } catch (error) {
        console.log(error);
        return res.status(500).send({ message: "Internal server error" });
    }
}

export const createContact = async (req: Request, res: Response) => {
    try {
        const contact = new ContactModel(req.body);
        contact.userId = req.user._id;
        const newContact = await ContactModel.create(contact);
        console.log("new contact", newContact);
        return res.status(200).send({ message: "contact created", result: newContact });
    } catch (err) {
        console.log(err);
        res.status(500).send({ message: "Interval server error" });
    }
}

export const updateContact = async (req: Request, res: Response) => {
    try {
        const { id } = req.query;
        const { name, phone, countryCode } = req.body;
        const contact = await ContactModel.findById(id).exec();
        if (!contact) {
            return res.status(401).send({ message: "Contact Not Found" });
        }
        contact.name = name;
        contact.phone = phone;
        contact.countryCode = countryCode;
        await contact.save();
        return res.status(200).send({ message: "User updated" });
    } catch (err) {
        console.log(err);
        return res.status(500).send({ message: "Internal servor error" });
    }
}

export const deleteContact = async (req: Request, res: Response) => {
    try {
        const { id } = req.query;
        const validId = mongoose.Types.ObjectId.isValid(id as string);
        if (!validId) {
            res.status(400).send({ message: "User id is not valid" });
        }
        await ContactModel.findByIdAndDelete(id).exec();
        return res.status(200).send({ message: "user deleted" });
    } catch (err) {
        console.log(err);
        res.status(500).send({ message: "Interval servor error" });
    }
}
