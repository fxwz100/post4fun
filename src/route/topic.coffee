# A testable router.
exports = module.exports = ({router, data}) ->

  # Fetch topic
  router.get '/', (req, res) ->
    res.render 'topic', topic: req.params.topic

  # Fetch records
  router.get '/records.json', (req, res) ->
    topic = req.params.topic
    start = parseInt req.query.start || 0
    data.fetchRecordsByTopic(topic, start: start).then (result) ->
      res.json result
    .catch (err) ->
      res.status(500).json err: err

  # For new record.
  router.get '/rec/new', (req, res) ->
    res.render 'new', topic: req.params.topic

  # Post a new record.
  router.post '/rec/new', (req, res) ->
    ttl = parseInt req.body.ttl
    if ttl <= 20
      data.addRecord
        content: req.body.content
        ttl: new Date(parseInt(ttl) * 60000 + (+new Date()))
        topic: req.params.topic 
      .then ->
        res.json status: 'done'
      .catch (err) ->
        console.log err
        res.status(500).json err: err
    else
      console.log req.query.ttl
      res.status(403).json err: 'Invalid ttl.'

  router
