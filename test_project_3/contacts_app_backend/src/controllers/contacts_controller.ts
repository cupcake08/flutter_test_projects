import { Request, Response } from "express";
import UserModel from "../models/user";
import mongoose from "mongoose";

export const getContacts = async (req: Request, res: Response) => {
    try {
        console.log(req.query);
        const { id, limit, skip } = req.query;
        const validId = mongoose.Types.ObjectId.isValid(id as string);
        if (validId === false) {
            return res.status(400).send({ message: "Invalid user id" });
        }
        const result = await UserModel.aggregate([
            {
                $match: {
                    _id: new mongoose.Types.ObjectId(id as string)
                },
            },
            {
                $lookup: {
                    from: 'contacts',
                    localField: 'contacts',
                    foreignField: '_id',
                    as: 'contacts'
                }
            },
            {
                $limit: limit ? parseInt(limit as string) : 10
            }, {
                $skip: skip ? parseInt(skip as string) : 0
            }
        ]).exec();
        return res.status(200).send({ message: "Contacts fetched successfully", result });
    } catch (error) {
        console.log(error);
        return res.status(500).send({ message: "Internal server error" });
    }
}