import mongoose from "mongoose";

function connectToDB(db_uri: string) {
	mongoose.connect(db_uri)
		.then(() => console.log("connected to DB"))
		.catch((err) => console.log(err));
}

export default connectToDB;
