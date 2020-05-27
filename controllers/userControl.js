require('../models/UserSchema')
const UserSchema = require('mongoose').model('UserSchema')
const passport = require('passport')

exports.createUser = function(req, res, next) {
  //generate hash and stuff
  console.log("ATTEMPT TO CREATE USER")
  console.log(req.body)
  const user = {
    handle: req.body.handle,
    email: req.body.email,
    pass: req.body.pass
  }
  UserSchema(user).save(function(err) {
    if (err) res.json({error: err})
    else res.json({message: 'success'})
  })
}

exports.getUserByHandle = function(req, res, next) {
  UserSchema.find({handle: req.params.handle}, function(err, user) {
    if (err) res.json({error: err})
    else res.json({user: user})
  })
}

exports.getUserByEmail = function(req, res, next) {
  UserSchema.find({email: req.params.handle}, function(err, user) {
    if (err) res.json({error: err})
    else res.json({user: user})
  })
}

exports.getAllUsers = function(req, res, next) {
  UserSchema.find({}, function(err, users) {
    if (err) res.json({error: err})
    else res.json({users: users})
  })
}

exports.updateUser = function(req, res, next) {
  if (req.user._id !== req.params.id) return
  const user = {
    handle: req.body.handle,
    email: req.body.email,
    pass: req.body.pass
  }
  UserSchema.findOneAndUpdate({_id: req.params.id}, {$set: user}, {new: true},function(err, user) {
    if (err) res.json({error: err})
    else res.json({message: 'success'})
  })
}

exports.deleteUser = function(req, res, next) {
  if (req.user._id !== req.params.id) return
  UserSchema.findOneAndDelete({_id: req.params.id}, function(err, user) {
    if (err) res.json({error: err})
    else res.json({message: 'success'})
  })
}

exports.loginUser = function(req, res, next) {
  return passport.authenticate('local', {
    failureRedirect:'',
    successRedirect:''
  })(req, res, next)
}

exports.logoutUser = function(req, res, next) {
  req.session.destroy(function (err) {
    if (err) res.json({err: err})
    else res.json({message: 'success'})
  })
}

exports.authenticate = function(username, password, done) {
  console.log("ATTEMPTING AUTHETENCATION")
  function validateUserPassword(password, pass) {
    //Replace with hashing 
    return (password === pass)
  }
  let q = (username.indexOf('@') === -1)? 
    {handle: username} : {email: username}
  UserSchema.findOne(q, function(err, user) {
    if (err) return done(err)
    if (!user) return done(null, false, {message: 'incorrect userid'})
    if (!validateUserPassword(password, user.pass)) {
      return done(null, false, 'incorrect password')
    }
    console.log('AUTH SUCCESS')
    return done(null, user)
  })
}

exports.findUserById = function(id, callback) {
  UserSchema.findById(id, callback)
}