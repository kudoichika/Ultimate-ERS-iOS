const express = require('express')
const app = express()
const server = require('http').createServer(app)
const io = require('socket.io')(server)
const bodyParser = require('body-parser')
const mongoose = require('mongoose')
require('./utils/config')

const SERVER_PORT = process.env.ERS_PORT || 3000

app.use('/', bodyParser.urlencoded({extended: true}))
app.use('/', bodyParser.json())

require('./utils/database')(mongoose)
require('./utils/socket')(io)

app.use('api/user', require('./api/users'))

server.listen(SERVER_PORT)
