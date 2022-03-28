const MongoClient = require('mongodb').MongoClient;
const url = "mongodb://localhost:27017";
const dbName = "myDatabase"

// connect
let _db = null;
async function connectDb() {
    if (!_db) {
        try {
            const client = new MongoClient(url, { useUnifiedTopology: true });
            await client.connect();
            _db = await client.db(dbName);
        }catch (error) {
            throw "Failed to connect: " + error;
        }
    }
    return _db;
}

// collection
exports.getCollection = (collection) => {
    let _col = null;
    return async () => {
        if (!_col) {
            try {
                const db = await connectDb();
                _col = db.collection(collection);
            } catch (error) {
                throw 'failed to get collection:' + error
            }
        }
        return _col;
    };
};
