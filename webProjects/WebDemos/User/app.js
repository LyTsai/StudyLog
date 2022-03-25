const { MongoClient } = require('mongodb');
// or as an es module:
// import { MongoClient } from 'mongodb'

// Connection URL
const url = 'mongodb://sharemap:LyPXwvDthnPtUi6HoFzCjIfMcb5OyD4ePaVFDB5oJ4sSVQOPBQeRCMfmqwnogqPKMhWlCdI1Ed4rdnTg8SIR4A==@sharemap.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&maxIdleTimeMS=120000&appName=@sharemap&retrywrites=false';
const client = new MongoClient(url);

// Database Name
const dbName = 'share_sample';

// add, insert many
async function insert(collectionName, insertedData) {
    // Use connect method to connect to the server
    await client.connect();
    console.log('Connected successfully to server');

    const db = client.db(dbName);
    const collection = db.collection(collectionName);

    // insert
    const insertResult = await collection.insertMany([insertedData]);
    
    console.log('Inserted documents =>', insertResult)

    return 'done.';
}

// find
async function findAll(collectionName) {
    await client.connect();
    console.log('Connected successfully to server');
    const db = client.db(dbName);
    const collection = db.collection(collectionName);

    // find
    const findResult = await collection.find().toArray();
    console.log('Found documents =>', findResult)

    return 'done.';
}

// find with condition
async function findFor(collectionName, queryCondition) {
    await client.connect();
    console.log('Connected successfully to server');
    const db = client.db(dbName);
    const collection = db.collection(collectionName);

    // find
    const findResult = await collection.find(queryCondition).toArray();
    console.log('Found documents filerted by' + queryCondition, findResult)

    return 'done.';
}

// update
async function updateOne(collectionName, oldPart, updatedPart) {
    await client.connect();
    console.log('Connected successfully to server');
    const db = client.db(dbName);
    const collection = db.collection(collectionName);

    // find
    const updatedResult = await collection.updateOne(oldPart, {$set: updatedPart});
    console.log('Updated =>', updatedResult)

    return 'done.';
}

// insert('insert', {'a':1, 'b': 22}).finally(() => client.close())
// findAll('insert').finally(() => client.close())
// findFor('insert', {a: 1}).finally(() => client.close())
// updateOne('insert', {'a': 1}, {'a': 2}).finally(() => client.close())


// main()
//     .then(console.log)
//     .catch(console.error)
//     .finally(() => client.close());