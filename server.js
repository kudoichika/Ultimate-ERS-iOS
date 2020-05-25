const express = require('express')
const app = express()
const server = require('http').createServer(app)
const io = require('socket.io')(server)
const bodyParser = require('body-parser')
const mongoose = require('mongoose')
const passport = require('passport')
const session = require('express-session')
//const flash = require('flash')
require('./utils/config')

const SERVER_PORT = process.env.ERS_PORT || 3000

app.use(bodyParser.urlencoded({extended: true}))
app.use(bodyParser.json())

require('./utils/database')(mongoose)
require('./utils/socket')(io)
require('./utils/passport')(passport)

//app.use(flash())
app.use(session({
    secret: process.env.SESS_SECRET,
    resave: false,
    saveUninitialized: true
}))

app.use(passport.initialize())
app.use(passport.session())

app.use('/api/users', require('./api/users'))

server.listen(SERVER_PORT)
