import UserModel from "../models/user";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { Request, Response } from "express";
import { MongooseError } from "mongoose";

export const login = async (req: Request, res: Response) => {
    try {
        const user = new UserModel(req.body);
        const foundUser = await UserModel.findOne({ email: user.email });
        if (!foundUser) {
            return res.status(404).send({ message: "User not found" });
        }
        const isMatch = await bcrypt.compare(user.password, foundUser.password);
        if (isMatch) {
            const token = jwt.sign({ id: foundUser._id }, process.env.JWT_SECRET as string, {
                expiresIn: "2 days",
            });
            return res.status(200).send({ token: token });
        }
        return res.status(401).send({ message: "Incorrect password" });
    } catch (error) {
        console.log(error)
        return res.status(500).send({ message: "Internal server error" });
    }
};

export const signup = async (req: Request, res: Response) => {
    try {
        const user = new UserModel(req.body);
        const newUser = await user.save();
        const token = jwt.sign({ id: newUser._id }, process.env.JWT_SECRET as string, {
            expiresIn: "2 days",
        });
        return res.status(201).send({ message: "User created successfully", newUser, authToken: token });
    } catch (error) {
        console.log(error);
        if (error instanceof MongooseError) {
            return res.status(400).send({ message: error.message });
        }
        return res.status(500).send({ message: "Internal server error" });
    }
};

export const refreshToken = async (req: Request, res: Response) => {
    try {
        const { token } = req.headers;
        const decoded = jwt.verify(token as string, process.env.JWT_SECRET as string);
        const newToken = jwt.sign(decoded, process.env.JWT_SECRET as string, {
            expiresIn: "2 days",
        });
        return res.status(200).send({ token: newToken });
    } catch (error) {
        console.log(error);
        return res.status(500).send({ message: "Internal server error" });
    }
}
