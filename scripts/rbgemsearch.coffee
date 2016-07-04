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
        query: encodeURIComponent(query)
      })

      .get() (err, res, body) ->
        return msg.send "Error :: #{err}" if err

        try
          gems = JSON.parse(body)
        catch error
          return msg.send "Error :: rubygems api error."

        return msg.send "Your search failed. Refactor your search inputz plix" unless gems.length > 0

        results = for gem in gems[0..3]
          console.log gem

          {
            fallback: "<#{gem.project_uri}|#{gem.name}>"
            color: "#c1272d"
            title: gem.name
            title_link: gem.project_uri
            author_name: gem.authors
            author_link: gem.project_uri
            pretext: "<#{gem.project_uri}|#{gem.name}> #{gem.info}"
            fields: [
              {
                title: "Docs",
                value: gem.documentation_uri
                short: false
              },
              {
                title: "Source",
                value: gem.source_code_uri
                short: false
              }
            ]
          }

        richMessage = {
          text: "I found #{gems.length} gems:"
          attachments: results
          channel: msg.envelope.room
          username: msg.robot.name
        }

        msg.robot.adapter.customMessage richMessage
