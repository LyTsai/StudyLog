// RESTful
const userCollection = require('../config/mongoDbConnection').getCollection("users");

exports.findAll = async () => {
    try {
      const col = await userCollection();
      return col.find({}).toArray();
    } catch (error) {
      throw "Failed to get users: " + error;
    }
};
const ObjectId = require('mongodb').ObjectId

exports.save = async (user) => {
    try {
        const col = await userCollection();
        const result = await col.insertOne(user);
        return result.ops // && result.ops[0]; // ops所有添加成功的数据
    }catch (error) {
        throw "Failed to save user: " + error;
    }
}

// exports.update = async (id, user) => {
    // try {
    //   const col = await userCollection();
    //   const result = await col.update(
    //     { _id: ObjectId(id) },
    //     { $set: user },
    //     { multi: false }
    //   );
    //   return result.value;
    // } catch (error) {
    //   throw "Failed to update user: " + error;
    // }
// };

exports.delete = async (id) => {
    try {
      const col = await userCollection();
      await col.deleteOne({ _id: ObjectId(id) });
    } catch (error) {
      throw "Failed to delelte user: " + error;
    }
  };