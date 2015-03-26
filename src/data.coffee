###
MongoDB based recording data accessor.
###
class MongoRecordAccesser

  bluebird = require 'bluebird'
  mongo = bluebird.promisifyAll require 'mongodb'

  constructor: (url, user, password) ->
    @docClient = mongo.MongoClient.connectAsync url, user, password

  ###
  Fetch all the records, optionally specify the start offset and the maximum
  records.
  ###
  fetchRecords: ({start, length}) ->
    start = start or 0
    length = length or 10
    @docClient.then (db) ->
      collection = db.collection 'records'
      query = collection.find
        ttl: $gte: new Date()
      .sort
        time: -1
      bluebird.all [
        query.countAsync()
        query.skip(start).limit(length).toArrayAsync()
      ]
      .spread (count, recs) ->
        start: start
        count: count
        records: recs
  ###
  Fetch all the records, optionally specify the start offset and the maximum
  records.
  ###
  fetchRecordsByTopic: (topic, {start, length}) ->
    start = start or 0
    length = length or 10
    @docClient.then (db) ->
      collection = db.collection 'records'
      query = collection.find
        topic: topic
        ttl: $gte: new Date()
      .sort
        time: -1
      bluebird.all [
        query.countAsync()
        query.skip(start).limit(length).toArrayAsync()
      ]
      .spread (count, recs) ->
        start: start
        count: count
        records: recs

  ###
  Add a record.
  ###
  addRecord: ({content, topic, ttl}) ->
    if content and content.length and content.indexOf('<script') < 0 and content.indexOf('<iframe') <0
      @docClient.then (db) ->
        collection = db.collection 'records'
        collection.insertAsync
          content: content
          topic: topic
          ttl: ttl
          time: new Date()
        ,
          w: 1
    else
      bluebird.reject 'Potential malicious content!'

module.exports = MongoRecordAccesser
