const express = require('express')
const userControl = require('../controllers/userControl')
const router = express.Router()

router.use('/create', userControl.createUser)
router.use('/get', userControl.getAllUsers)
router.use('/get/:handle', userControl.getUserByHandle)
router.use('/get/:email', userControl.getUserByEmail)
router.use('/update/:id', userControl.updateUser)
router.use('/delete/:id', userControl.deleteUser)

module.exports = router;
