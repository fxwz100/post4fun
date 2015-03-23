bodyParser  = require 'body-parser'
cookieParser= require 'cookie-parser'
express     = require 'express'
logger      = require 'morgan'
path        = require 'path'
session     = require 'express-session'
RecordAccess= require './data'

basePath    = (args...) -> path.join.apply path, [__dirname, '..'].concat args

app         = express()

# set the port to listen
app.set 'port', process.env.PORT || 8080

# set the view directory and engine as 'jade'.
app.set 'views', basePath 'view'
app.set 'view engine', 'jade'

# log the requests.
app.use logger 'combined'

# sesion handling
app.use session
  resave            : on
  saveUninitialized : on
  secret            : 'limited-reading'

# parse the request body.
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: off
app.use cookieParser()

# Main logic.
app.use '/', require('./route/site')
  router: express.Router()
  data  : new RecordAccess(process.env.MONGO_URL)

app.listen app.get('port'), ->
  console.log "Server is running at #{app.get('port')}."
