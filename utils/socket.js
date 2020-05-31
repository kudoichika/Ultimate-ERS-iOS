const sync = require('./sync')
const auth = require('./auth')
const Game = require('../classes/Game')

module.exports = function(io) {
  const gameSocket = io.of('/game')
  let roomGame = {}

  gameSocket.on('connection', function(socket) {
    
    console.log("Connected to Game Socket", socket.id)
    socket.on('join', function(room) {
      console.log('Request to join room', room)
      socket.join(room)
      if (!roomGame[room]) {
        console.log('Initializing Game in room', room)
        roomGame[room] = new Game(gameSocket, room, socket)
      } else {
        console.log('New player in room', room)
        roomGame[room].addPlayerAndStart(socket)
      }
    })

    socket.on('disconnect', function() {
      console.log('A Player has disconnected')
    })

  })
}
