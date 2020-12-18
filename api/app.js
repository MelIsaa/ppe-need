var createError = require('http-errors');
var express = require('express');
var path = require('path');
// var cookieParser = require('cookie-parser');

var logger = require('morgan');
var bodyParser = require('body-parser'); // Body Parser
// Database
var mysql = require('mysql'); // DB Connection
const dbconfig = require("./dbconfig"); // Database configuration

var cors = require("cors"); // Requires Cors

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/auth');
var userRouter = require('./routes/user') // User routes
var testAPIRouter = require("./routes/testAPI"); // requiring test api
var formsRouter = require("./routes/forms"); // Forms Route
var searchRouter = require("./routes/searches"); // Search Route
var providersRouter = require("./routes/providers"); // Providers Route
var itemsRouter = require("./routes/items"); // Items Route
var itemRouter = require("./routes/item"); // Item Route

/* CONSTANTS */
const TWO_HOURS = 1000 * 60 * 60 * 2;

const {
  SESS_LIFETIME = TWO_HOURS,
  SESS_NAME = 'sid',
  SESS_SECRET = 'a4f6ae85',
  NODE_ENV = 'development'
} = process.env;

const IN_PROD = NODE_ENV === 'production';

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(cors())

// app.use(cookieParser(SESS_SECRET));
// app.use(cookie);


app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
// app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies


app.use('/', indexRouter);
app.use('/users', usersRouter);

// Test route
app.use("/testAPI", testAPIRouter);
app.use("/searches", searchRouter); // Forms Router
app.use("/forms", formsRouter); // Forms Router
app.use("/providers", providersRouter); // Providers Router
app.use("/items", itemsRouter); // Items Router
app.use("/item", itemRouter); // Item Router
app.use("/user", userRouter); // User Router

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
