const User = require('../models/User')

exports.createUser = function(req, res, next) {
  const user = {
    name: req.body.name,
    email: req.body.email,
    pass: req.body.pass
  }
  User.create(user, function(err) {
    if (err) res.json({error: err})
    else res.json({message: 'success'})
  })
}

exports.getUserByHandle = function(req, res, next) {
  User.get({handle: req.params.handle}, function(err, user) {
    if (err) res.json({error: err})
    else res.json({user: user})
  })
}

exports.getUserByEmail = function(req, res, next) {
  User.get({email: req.params.handle}, function(err, user) {
    if (err) res.json({error: err})
    else res.json({user: user})
  })
}

exports.getAllUsers = function(req, res, next) {
  User.get({}, function(err, users) {
    if (err) res.json({error: err})
    else res.json({users: users})
  })
}

exports.updateUser = function(req, res, next) {
  const user = {
    name: req.body.name,
    email: req.body.email,
    pass: req.body.pass
  }
  User.update({_id: req.params.id}, user, function(err, user) {
    if (err) res.json({error: err})
    else res.json({message: 'success'})
  })
}

exports.deleteUser = function(req, res, next) {
  User.delete({_id: req.params.id}, function(err, user) {
    if (err) res.json({error: err})
    else res.json({message: 'success'})
  })
}
