//Server.js

//Load environment variables
require('dotenv').config()

//Required Packages
const express = require('express')
const app = express()
const server = require('http').createServer(app)
const io = require('socket.io')(server)

//Choose Server Port
const SERVER_PORT = process.env.ERS_PORT || 6000

//Load SocketIO Logic Module
require('./socket')(io)

//Listen on Server
server.listen(SERVER_PORT)
