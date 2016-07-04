# Description
#   Use hubot to search rubygems.org for a specific gem.
#
# Commands:
#   hubot gem me <query> - Search rubygems.org for a gem
#
# Author:
#   Jon Rohan <yes@jonrohan.codes>


module.exports = (robot) ->
  robot.respond /gem( me)? (.+)/i, (msg) ->
    query = msg.match[2]
    robot.http("https://rubygems.org/api/v1/search.json")
      .query({
        query: query
      })
      .get() (err, res, body) ->

        return msg.send "Error :: #{err}" if err
        try
          gems = JSON.parse(body)
        catch error
          return msg.send "Error :: rubygems api error."

        gem = gems.reverse().pop()

        return msg.send "Your search failed. Refactor your search inputz plix" unless gem

        richMessage = {
          text: "I found:#{gem.name} - #{gem.info}"
          attachments: results
          channel: msg.envelope.room
          username: msg.robot.name
        }

          richMessage.attachments.push {
            text: "latest release: #{gem.version}"
            text: "Link to rubygems.org gem page: #{gem.project_uri}"
            text: "Ruby gem documentation: #{gem.documentation_uri}"
            text: "Github gem source code: #{gem.source_code_uri}"
            text: "Hugzs&Kisses W."
            color: "warning"
          }

        msg.robot.adapter.customMessage richMessage
