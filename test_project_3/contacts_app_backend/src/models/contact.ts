import mongoose, { Schema, Types } from "mongoose";

export interface I_Contact extends mongoose.Document {
    name: string;
    phone: number;
    userId: Types.ObjectId;
    countryCode: number;
}

const ContactSchema = new mongoose.Schema<I_Contact>({
    name: {
        type: String,
        required: true,
    },
    phone: {
        type: Number,
        required: true,
    },
    userId: {
        type: Schema.Types.ObjectId,
        required: true,
    },
    countryCode: {
        type: Number,
        required: true,
    },
}, { collection: "contacts" });

const ContactModel = mongoose.model<I_Contact>("Contact", ContactSchema);

export default ContactModel;
