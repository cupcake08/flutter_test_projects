"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getErrorMessage = void 0;
function getErrorMessage(err) {
    if (err instanceof Error) {
        return err.message;
    }
    return String(err);
}
exports.getErrorMessage = getErrorMessage;
