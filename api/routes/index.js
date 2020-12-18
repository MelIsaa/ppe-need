var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  const signedIn = req.signedCookies.username;
  res.send(signedIn);
});

module.exports = router;
