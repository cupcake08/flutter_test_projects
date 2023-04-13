import mongoose from "mongoose";

async function connectToDB(db_uri: string) {
	try {
		const conn = await mongoose.connect(db_uri);
		console.log(`mongodb connected: ${conn.connection.host}`);
	}catch (err) {
		console.log(err);
		process.exit(1);
	}
}

export default connectToDB;
