const express = require('express')
const control = require('../controllers/userControl')
const auth = require('../utils/auth')
const passport = require('passport')
const router = express.Router()

router.post('/register', auth.checkNotAuth, control.createUser)
router.post('/login', auth.checkNotAuth, control.loginUser)
router.post('/logout', auth.checkAuth, control.logoutUser)
router.get('/', control.getAllUsers)
router.get('/h/:handle', control.getUserByHandle)
router.get('/e/:email', control.getUserByEmail)
router.put('/:id', auth.checkAuth, control.updateUser)
router.delete('/:id', auth.checkAuth, control.deleteUser)

module.exports = router;
