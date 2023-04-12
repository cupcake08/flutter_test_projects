import mongoose from "mongoose";
import bcrypt from "bcryptjs";

export interface I_User extends mongoose.Document {
    name: string;
    email: string;
    password: string;
    contacts?: mongoose.Types.ObjectId[] | null;
}

const UserSchema = new mongoose.Schema<I_User>({
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,
    },
    password: {
        type: String,
        required: true,
    },
    contacts: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: "contacts",
        },
    ],
}, { collection: "users" });

// Hash password before saving to DB
UserSchema.pre("save", async function (next) {
    const user = this;
    if(user.isModified("password") === false) return next();
    const hash = await bcrypt.hash(user.password, 10);
    user.password = hash;
    next();
});

const UserModel = mongoose.model<I_User>("User", UserSchema);

export default UserModel;