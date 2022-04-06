const data = require('../data.json');

exports.getAllUsers = (req, res) => {
    console.log('heee')
    res.json(data)
}

exports.addUser = (req, res) => {
    let info = req.body
    
}

exports.checkName = (req, res) => {
    let name = req.params.username;

}

exports.editUser = (req, res) => {

}

exports.deleteUser = (req, res) => {
    let id = req.params.id;

}