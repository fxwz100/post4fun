# depends on moment.js
# depends on jQuery

# set the default locale.
moment.locale 'zh-CN'

# load the records. The selected element should be a <ul>.
window.loadRecords = oadRecords = (selector) ->
  $recs = $ selector
  template = $recs.data 'template'
  url = if location.href[location.href.length-1] == '/' then 'records.json' else location.href + '/records.json';
  loadRecords.run = ->
    $.get(url).success (data) ->
      if data and data.records and data.records.length
        $recs.empty()
        for it in data.records
          it.timeText = moment(it.time).fromNow()
          $recs.append template.replace /{{(\w+)}}/g, (a, t) -> it[t] 
    if loadRecords.timer
      clearTimeout loadRecords.timer
    loadRecords.timer = setTimeout loadRecords.run, 1000
  loadRecords.run()

