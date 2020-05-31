class Logger {
    constructor(from) {
        this.from = from
    }
    log() {
        let msg = this.parseMessage(arguments)
        console.log('LOG', '|', this.from, '|', msg)
    }
    error() {
        let msg = this.parseMessage(arguments)
        console.log('ERROR', '|', this.from, '|', msg)
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