const ERS = require('./ERS')
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
        this.ers = new ERS(2)
        if (this.ers.readyGame()) {
            this.startGame()
            //broadast ready
        }
    }

    startGame() {
        this.monitorStatus()
        const adapter = this.adapter
        const room = this.room
        const ers = this.ers
        adapter.emit('startGame')
        this.playerOne.emit('id', {id: 0})
        this.playerTwo.emit('id', {id: 1})
        this.playerOne.on('playCard', function() {
            logger.log('Player 1 has played a card')
            adapter.to(room).emit('cardPlayed', ers.playCard(0))
        })
        this.playerTwo.on('playCard', function() {
            logger.log('Player 2 has played a card')
            adapter.to(room).emit('cardPlayed', ers.playCard(1))
        })
        this.playerOne.on('slapStack', function() {
            logger.log('Player 1 has slapped the stack')
            adapter.to(room).emit('stackSlapped', ers.slapStack(0))
        })
        this.playerTwo.on('slapStack', function() {
            logger.log('Player 2 has slapped the stack')
            adapter.to(room).emit('stackSlapped', ers.slapStack(1))
        })
    }

    monitorStatus() {
        this.playerOne.on('disconnect', function() {
            logger.log('Player 1 disconnected')
        })
        this.playerTwo.on('disconnect', function() {
            logger.log('Player 2 disconnected')
        })
    }
}

module.exports = Game
