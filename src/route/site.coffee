# A testable router.
exports = module.exports = ({router, data}) ->

  # Home page.
  router.get '/', (req, res) ->
    res.render 'home'

  # Fetch all records.
  router.get '/records.json', (req, res) ->
    topic = req.params.topic
    start = parseInt req.query.start || 0
    data
    .fetchRecords start: start
    .then (result) ->
      res.json result
    .catch (err) ->
      res.status(500).json err: err

  # About page.
  router.get '/about', (req, res) ->
    res.render 'about'
  
  router

