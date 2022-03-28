
// const form = document.querySelector('form')
// const username = document.querySelector('#username')
// const password = document.querySelector('#password')
// const firstName = document.querySelector('#first_name')
// const lastName = document.querySelector('#last_name')
// const address = document.querySelector('#address')
// const profession = document.querySelector('#profession')
// const email = document.querySelector('#email')
// const cell = document.querySelector('#cell')
// form.onsubmit = checkAndAddUser

// function checkAndAddUser() {
    // let userData = { 'username': username.value , 'password': password.value , 'first_name': firstName.value, 'last_name': lastName.value}

    // const col = await userCollection();
    // const result = await col.insertOne(user);
    // save(userData)
    // .then(
    //     alert('success!')
    // )
    // .catch(console.error)
    // .finally(() => client.close());
// }

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