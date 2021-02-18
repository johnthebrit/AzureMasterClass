var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { pic: '/images/pic.jpg' , link: '/2'});
});

router.get('/2', function(req, res, next) {
  res.render('index', {  pic: '/images/pic2.jpg', link: '/2zoom' });
});

router.get('/2zoom', function(req, res, next) {
  res.render('index', {  pic: '/images/pic2zoom.jpg', link: '/' });
});


module.exports = router;
