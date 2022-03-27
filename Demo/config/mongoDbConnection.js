const MongoClient = require('mongodb').MongoClient;
const url = "mongodb://localhost:27017";
const dbName = "myDatabase"

// 存放连接到数据库后，MongoClient 返回的数据库实例，节省创建和销毁连接的时间
let _db = null;
async function connectDb() {
    if (!_db) {
        // 第二个参数是配置项，设置 useUnifiedTopology 是因为 MongoDB 提示 Server Discover and Monitoring engine(服务发现和监控引擎）要过时了，把它设置为 true 可以避免这个警告
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
