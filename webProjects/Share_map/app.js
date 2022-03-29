const http = require('http')
const app = http.createServer()
// const express = require('express')
// const app = express()

// models
const User = require('./models/users')
const queryString = require('querystringify')

app.on('request', async (req, res) => {
    const method = req.method

    // const pathName = req.url 
    const pathURL = new URL(req.url, 'http://localhost:3000')
    const pathName = pathURL.pathname
    console.log(pathURL)

    if (method === 'GET') {
        if (pathName == '/list') {
            let users = await User.find()
            let list = `
            <!DOCTYPE html>
            <html lang="en">
        <head>
        <meta charset="utf-8">
        <title>User List</title>
        <link rel="styleSheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    </head>
    <body>
        <div class="container">
            <h6>
                <a href="/add" class="btn btn-primary">Add User</a>
            </h6>
            <table class="table table-striped table-border">
                <tr>
                    <th>Username</th>
                    <th>Full name</th>
                    <th>Profession</th>
                    <th>Email</th>
                    <th>Cell</th>
                    <th>Manage</th>
                </tr>
            `
            // all users
            users.forEach(item => {
                list += `
                <tr>
                    <td>${item.username}</td>
                    <td>${item.first_name} ${item.last_name}</td>
                    <td>
                    `
                    item.profession.forEach((one, index) => {
                        let isLast = (index === item.profession.length - 1)
                        list +=`<span>${one}${isLast ? "" : ","} </span>`
                    })
                    
                    list += `
                                    </td>
                    <td>${item.email}</td>
                    <td>${item.cell}</td>
                    <td>
                    <a href= "" class="btn btn-danger btn-xs">Delete</a>
                    <a href= "/modify?id=${item._id}" class="btn btn-success btn-xs">Modify</a>
                    </td>
                </tr>
                `
            })

            list += `
            </table>
            </div>
        </body>
    </html>
            `
            res.end(list)
        }else if (pathName == '/add') {
            let add = `
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <title>Users Management</title>
                <style>
                    html {
                        font-family: sans-serif;
                    }
                    
                    body {
                        margin: 10px auto;
                        width: 80%;
                    }
            
                    form {
                        padding: 1rem;
                        border: 1px solid #ccc;
                        border-radius: 1rem;
                    }
            
                    input,
                    textarea,
                    select,
                    button {
                        font-size: 1rem;
                        padding: 5px 5px;
                        margin: auto 5px;
                        margin-right: 10px;
                        border: 1px solid #ccc;
                    }
            
                    label {
                        position: relative;
                        width: 100px;
                        display: inline-block;
                        vertical-align: top;
                        line-height: 30px;
                        text-align: right;
                    }
            
                    p {
                        margin-bottom: 16px;
                    }
            
                    textarea {
                        height: 60px;
                    }
            
                    button {
                        background-color: white;
                        padding: 5px 15px;
                        margin: 10px auto;
                        border-radius: 4px;
                    }
            
                    .hint {
                        font-size: 0.8rem;
                    }
            
                    abbr {
                        color: red;
                    }
                </style>
            </head>
            <body>
                <!-- action="localhost:3000/user/add"  -->
                <form action="/add" method="post">
                    <h1>Add User</h1>
                    <p class="hint">Required fields are followed by *</p>
                    <p>
                        <label for="username">Username:<abbr title="required">*</abbr></label>
                        <input id="username" type="text" name="username" required>
            
                        <label for="password">Password:<abbr title="required">*</abbr></label>
                        <input id="password" type="password" name="password" required>
                    </p>
                    <p>
                        <label for="first_name">First Name:</label>
                        <input id="first_name" type="text" name="first_name">
                        <label for="last_name">Last Name:</label>
                        <input id="last_name" type="text" name="last_name">
                    </p>
                    <p>
                        <label for="address">Address:</label>
                        <textarea id="address" name="address"></textarea>
                    </p>
                    <p>
                    <label for="profession">Profession:</label>
                    <input type="checkbox" value="Medical Professional" name="profession"><span>Medical Professional</span>
                    <input type="checkbox" value="Educator" name="profession"><span>Educator</span>
                    <input type="checkbox" value="Researcher" name="profession"><span>Researcher</span>
                    </p>
                    <p>
                        <label for="email">Email:</label>
                        <input id="email" type="email" name="email">
                    </p>
                    <p>
                        <label for="cell">Cell:</label>
                        <input id="cell" type="tel" name="cell">
                    </p>
            
                    <button class="addUser" type="submit">Add</button>
                </form>
            </body>
            </html>
            `
           res.end(add)
        }
        else if (pathName === '/modify') {
            const queryId = pathURL.searchParams.get('id')
            let findUser = await User.findOne({_id: queryId})
            let modify = `
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <title>Users Management</title>
                <style>
                    html {
                        font-family: sans-serif;
                    }
                    
                    body {
                        margin: 10px auto;
                        width: 80%;
                    }
            
                    form {
                        padding: 1rem;
                        border: 1px solid #ccc;
                        border-radius: 1rem;
                    }
            
                    input,
                    textarea,
                    select,
                    button {
                        font-size: 1rem;
                        padding: 5px 5px;
                        margin: auto 5px;
                        margin-right: 10px;
                        border: 1px solid #ccc;
                    }
            
                    label {
                        position: relative;
                        width: 100px;
                        display: inline-block;
                        vertical-align: top;
                        line-height: 30px;
                        text-align: right;
                    }
            
                    p {
                        margin-bottom: 16px;
                    }
            
                    textarea {
                        height: 60px;
                    }
            
                    button {
                        background-color: white;
                        padding: 5px 15px;
                        margin: 10px auto;
                        border-radius: 4px;
                    }
            
                    .hint {
                        font-size: 0.8rem;
                    }
            
                    abbr {
                        color: red;
                    }
                </style>
            </head>
            <body>
                <form action="/modify" method="post">
                    <h1>Add User</h1>
                    <p class="hint">Required fields are followed by *</p>
                    <p>
                        <label for="username">Username:<abbr title="required">*</abbr></label>
                        <input id="username" type="text" name="username" required value=${findUser.username}>
            
                        <label for="password">Password:<abbr title="required">*</abbr></label>
                        <input id="password" type="password" name="password" required value=${findUser.password}>
                    </p>
                    <p>
                        <label for="first_name">First Name:</label>
                        <input id="first_name" type="text" name="first_name" value=${findUser.first_name}>
                        <label for="last_name">Last Name:</label>
                        <input id="last_name" type="text" name="last_name" value=${findUser.last_name}>
                    </p>
                    <p>
                        <label for="address">Address:</label>
                        <textarea id="address" name="address"></textarea>
                    </p>
                    <p>
                    <label for="profession">Profession:</label>
                    <label><input type="checkbox" value="Medical Professional" name="profession">Medical Professional</label>
                    <input type="checkbox" value="Educator" name="profession"><span>Educator</span>
                    <input type="checkbox" value="Researcher" name="profession"><span>Researcher</span>
                    </p>
                    <p>
                        <label for="email">Email:</label>
                        <input id="email" type="email" name="email">
                    </p>
                    <p>
                        <label for="cell">Cell:</label>
                        <input id="cell" type="tel" name="cell">
                    </p>
            
                    <button class="addUser" type="submit">Modify</button>
                </form>
            </body>
            </html>
            `
           res.end(modify)
        }
    }else if (method === 'POST') {
        if (pathName == '/add') {
            let formData = ""
            req.on('data', param => {
                formData += param
            })

            req.on('end', async () => {
                let user = queryString.parse(formData)
                await User.create(user)
        
                // 301: relocate
                res.writeHead(301, {
                    Location: "/list"
                })
                res.end()
            })
        }else if (pathName == '/modify') {
            const queryId = pathURL.searchParams.get('id')
            res.end('ok')
        }
    }
})

app.listen(3000, () =>
    console.log(`Express server listening at http://localhost:3000`)
);