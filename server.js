const express = require('express')
const app = express()
const server = require('http').createServer(app)
const io = require('socket.io')(server)
const bodyParser = require('body-parser')
const mongoose = require('mongoose')
const passport = require('passport')
const session = require('express-session')
const MongoStore = require('connect-mongo')(session)
require('./utils/config')

const SERVER_PORT = process.env.ERS_PORT || 3000

app.use(bodyParser.urlencoded({extended: true}))
app.use(bodyParser.json())

require('./utils/database')(mongoose)
require('./utils/passport')(passport)
const sessionware = session({
    secret: process.env.SESS_SECRET,
    resave: true,
    saveUninitialized: true,
    cookie: {
        maxAge: process.env.SESS_LIFE
    },
    store: new MongoStore({
        mongooseConnection: mongoose.connection
    })
})
app.use(sessionware)
app.use(passport.initialize())
app.use(passport.session())

require('./utils/socket')(io)
io.use(function(socket, next) {
    sessionware(socket.request, {}, next)
})

io.on('connection', function(socket) {
    //console.log(socket.request.session)
})

app.use('/api/users', require('./api/users'))

server.listen(SERVER_PORT)
