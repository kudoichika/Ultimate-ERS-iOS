const sync = require('./sync')
const auth = require('./auth')
const Game = require('../classes/Game')
const Logger = require('../classes/Logger')

module.exports = function(io) {
  const gameSocket = io.of('/game')
  const logger = new Logger('GAMESOCKET')
  let roomGame = {}

  gameSocket.on('connection', function(socket) {
    
    logger.log('New connection to socket:', socket.id)
    socket.on('join', function(room) {
      logger.log('Request to join room:', room)
      socket.join(room)
      socket.roomId = room
      if (!roomGame[room]) {
        logger.log('New Room Created')
        roomGame[room] = new Game(gameSocket, room, socket)
      } else {
        roomGame[room].addPlayerAndStart(socket)
      }
    })

    socket.on('disconnect', function() {
      logger.log('Socket disconnected:', socket.id)
      if (socket.roomId) {
        logger.log('Player disconnected from Room', socket.roomId)
        gameSocket.in(socket.roomId).clients(function(err, clients) {
          if (clients.length === 0) {
            logger.log('All clients disconnected. Deleting room', socket.roomId)
            delete roomGame[socket.roomId]
          }
        })
      }
    })

  })
}
