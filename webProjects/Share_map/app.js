const http = require('http')

// models
const User = require('./models/users')

const queryString = require('querystringify')

const app = http.createServer()
app.on('request', async (req, res) => {
    const method = req.method
    const pathName = req.url // url.parse(req.url)
    
    if (method === 'GET') {
        if (pathName == '/add') {
            let list = `
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <title>Users Management</title>
                <script src="app.js" defer></script>
                <script src="../Models/user.js" defer></script>
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
           res.end(list)
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
        }
    }
})

app.listen(3000, () =>
    console.log(`Express server listening at http://localhost:3000`)
);