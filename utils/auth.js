exports.checkAuth = function(req, res, next) {
    if (!req.isAuthenticated()) {
        return next()
    }
    return res.json({message: 'not authenticated'})
}

exports.checkNotAuth = function(req, res, next) {
    if (req.isAuthenticated()) {
        return res.json({message: 'authenticated'})
    }
    return next()
}
