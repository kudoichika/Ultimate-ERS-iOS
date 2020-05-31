const checkSlap = require('../utils/patternChecker')
const Logger = require('./Logger')
const logger = new Logger('GAME')

class Game {
    //Decide on public/private variables
    constructor(adapter, room, playerOne) {
        logger.from = 'GAME ROOM: ' + room
        logger.log('New Game Initialized')
        this.adapter = adapter
        this.room = room
        this.status = 'waiting'
        this.playerOne = playerOne
        this.playerTwo = null
        this.cardStack = []
        this.turn = 0
        this.moves = []
        //resign + winner needed
    }

    //Actual Gameplay
    addPlayerAndStart(playerTwo) {
        logger.log('Request to join game from socket:', playerTwo.id)
        if (playerTwo === this.playerOne) {
            logger.log('Request denied for socket:', playerTwo.id)
            return
        }
        logger.log('Request approved from socket:', playerTwo.id)
        this.playerTwo = playerTwo
        this.status = 'playing'
        logger.log('Starting Game')
        this.startGame()
    }

    startGame() {
        const adapter = this.adapter
        const room = this.room
        this.playerOne.on('playCard', function(data) {
            logger.log('Player 1 has played a card')
            adapter.to(room).emit('cardPlayed')
        })
        this.playerTwo.on('playCard', function(data) {
            logger.log('Player 2 has played a card')
            adapter.to(room).emit('cardPlayed')
        })
        this.playerOne.on('disconnect', function() {
            logger.log('Player 1 disconnected')
        })
        this.playerTwo.on('disconnect', function() {
            logger.log('Player 2 disconnected')
        })
    }
}

module.exports = Game