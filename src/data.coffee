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
  fetchRecords: (start=0, length=10) ->
    @docClient.then (db) ->
      collection = db.collection 'records'
      collection.find
        ttl: $gte: new Date()
      .skip(start).limit(length).toArrayAsync()

  ###
  Add a record.
  ###
  addRecord: ({content, ttl}) ->
    if content.indexOf('<script') < 0 and content.indexOf('<iframe') <0
      @docClient.then (db) ->
        collection = db.collection 'records'
        collection.insertAsync
          content: content
          ttl: ttl
        ,
          w: 1
    else
      bluebird.reject 'Potential malicious content!'

module.exports = MongoRecordAccesser
