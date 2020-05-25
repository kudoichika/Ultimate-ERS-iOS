const LocalStrategy = require('passport-local').Strategy
const control = require('../controllers/userControl')

module.exports = function(passport) {
    const custom = {
        usernameField: 'userid',
        passwordField: 'password'
    }
    passport.use(new LocalStrategy(
        custom,
        control.authenticate
    ))
    passport.serializeUser(function(user, done) {
        console.log("Serializing User\n", user)
        done(null, user.id)
    })
    passport.deserializeUser(function(id, done) {
        console.log("Attempting to Deserialize User")
        console.log(id)
        control.findUserById(id, function(err, user) {
            if (err) done(err)
            console.log("Deserializing User\n", user)
            done(null, user)
        })
    })
}
