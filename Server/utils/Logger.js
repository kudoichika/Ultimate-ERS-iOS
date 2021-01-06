const chalk = require('chalk')
//Customize Colors for each seperate Class/Entity
class Logger {
    constructor(from) {
        this.from = from
    }
    log() {
        let structure = 'LOG ' + this.getStructure()
        console.log.apply(console, [structure].concat(Array.prototype.slice.call(arguments)))
    }
    error() {
        let structure = 'ERROR ' + this.getStructure()
        console.log.apply(console, [structure].concat(Array.prototype.slice.call(arguments)))
    }
    getStructure() {
        let now = (new Date()).toLocaleString()
        return chalk.rgb(232, 89, 251)(now) + ' | ' + chalk.rgb(244,120,33)(this.from) + ' | '
    }
}

module.exports = Logger
