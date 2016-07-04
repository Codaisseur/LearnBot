# Description
#   Translate erb (html) into a slim version
#
# Commands
#   learnbot erb2slim <your code here>
#
# Authors:
#   Aeshta and Rosiene

module.exports = (robot) ->
  robot.respond /html2slim (.*)|erb2slim (.*)/ , (msg) ->
    if msg.match[1]
      code = msg.match[1]
    else
      code = msg.match[2]

    open_erb2slim msg, code

open_erb2slim = (msg, code) ->
  data = ""

  msg.http("http://erb2slim.com/convert.json")
    .query
      raw_text: code
      conversion_type: "slim"
    .post( (err, req)->
      req.addListener "response", (res)->
        output = res

        output.on 'data', (d)->
          data  = d.toString('utf-8')

        output.on 'end', ()->
          parsedData = JSON.parse(data)

          if parsedData.error
            msg.send "Error: #{parsedData.error}"
            return

          msg.send parsedData.converted_txt

    )()
