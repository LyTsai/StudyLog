const userCollection = require('../config/mongoDbConnection').getCollection("users");

exports.save = async (user) => {
    try {
        const col = await userCollection();
        const result = await col.insertOne(user);
        return result.ops && result.ops[0];
    }catch (error) {
        throw "failed to save user" + error;
    }
}

// https://zxuqian.cn/videos/express/express-mongo-crud/