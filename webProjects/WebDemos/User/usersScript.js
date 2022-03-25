const form = document.querySelector('form')
const username = document.querySelector('#username')
const password = document.querySelector('#password')
const firstName = document.querySelector('#first_name')
const lastName = document.querySelector('#last_name')
const address = document.querySelector('#address')
const profession = document.querySelector('#profession')
const email = document.querySelector('#email')
const cell = document.querySelector('#cell')
form.onsubmit = checkAndAddUser

function checkAndAddUser() {
    insert('users', [{ 'username': username.value , 'password': password.value , 'first_name': firstName.value, 'last_name': lastName.value}])
    .then(
        alert('success!')
    )
    .catch(console.error)
    .finally(() => client.close());
}

// function User(username, password, firstname, lastname, address, profession, emails, cells) {
//     this.username = username
//     this.password = password
//     this.firstname = firstname
//     this.lastname = lastname
//     this.address = address
//     this.profession = profession
//     this.emails = emails
//     this.cells = cells
// }
