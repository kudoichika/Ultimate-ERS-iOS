const LocalStrategy = require('passport-local').Strategy
const control = require('../controllers/userControl')
const Logger = require('../classes/Logger')

module.exports = function(passport) {
    const logger = new Logger('PASSPORT')
    const custom = {
        usernameField: 'userid',
        passwordField: 'password'
    }
    passport.use(new LocalStrategy(
        custom,
        control.authenticate
    ))
    passport.serializeUser(function(user, done) {
        logger.log('Serializing user:', user.id)
        done(null, user.id)
    })
    passport.deserializeUser(function(id, done) {
        logger.log('Attempting to deserialize user with id:', id)
        control.findUserById(id, function(err, user) {
            logger.log('Deserializing User:', user.id)
            done(err, user)
        })
    })
}