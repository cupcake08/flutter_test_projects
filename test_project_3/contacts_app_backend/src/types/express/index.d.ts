import { I_User } from "../../models/user"

export { }

declare global {
    namespace Express {
        export interface Request {
            user: I_User;
        }
    }
}