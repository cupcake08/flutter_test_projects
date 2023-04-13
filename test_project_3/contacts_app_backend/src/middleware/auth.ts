import { NextFunction, Response, Request } from "express";
import jwt from "jsonwebtoken";
import UserModel from "../models/user";

export const authorization = async (req: Request, res: Response, next: NextFunction) => {
	try {
		const token = req.header("Authorization")?.replace("Bearer ", "");
		if (!token) {
			throw new Error("Token Not Found");
		}
		const decoded = <jwt.JwtPayload>jwt.verify(token, process.env.JWT_SECRET as string);
		const userFound = await UserModel.findOne({ _id: decoded['id'] });
		if (!userFound) {
			throw new Error("User not found");
		}
		req.user = userFound;
		next();
	} catch (err) {
		console.log(err);
		res.status(401).send({ message: "Unauthorized" });
	}
}
