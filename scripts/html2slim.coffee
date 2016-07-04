# Description
#   Translate erb (html) into a slim version
#
# Commands
#   learnbot erb2slim <your code here>
#
# Authors:
#   Aeshta and Rosiene

module.exports = (robot) ->
  robot.respond /(html|erb)2slim (.*)/ , (msg) ->
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

          msg.send "```\n" + parsedData.converted_txt + "\n```"

    )()
