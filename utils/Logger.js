const chalk = require('chalk')
//Customize Colors for each seperate Class/Entity
class Logger {
    constructor(from) {
        this.from = from
    }
    log() {
        let msg = this.parseMessage(arguments)
        console.log('LOG', new Date(), '|', chalk.rgb(244,120,33)(this.from), '|', msg)
    }
    error() {
        let msg = this.parseMessage(arguments)
        console.log('%cERROR', new Date(), '|', chalk.rgb(244,120,33)(this.from), '|', msg)
    }
    parseMessage(args) {
        let msg = ""
        for (let i = 0; i < args.length; i++) {
            msg += args[i] + ' '
        }
        return msg
    }
}

module.exports = Logger