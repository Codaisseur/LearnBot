# Description:
#   Search the Reader and provide links to the first 3 articles
#
# Dependencies:
#   none
#
# Configuration:
#   HUBOT_READER_EMAIL
#   HUBOT_READER_TOKEN
#
# Commands:
#   learnbot reader me <query> - Search for the query
#
# Author:
#   wrdevos

module.exports = (robot) ->
  robot.respond /reader me (.*)/i, (msg) ->
    searchQuery = msg.match[1]

    articleSearch msg, searchQuery

articleSearch = (msg, searchQuery) ->
  data = ""
  msg.http("https://read.codaisseur.com/search.json")
    .query
      search: encodeURIComponent(searchQuery)
      user_email: process.env.HUBOT_READER_EMAIL
      user_token: process.env.HUBOT_READER_TOKEN
    .get( (err, req)->
      req.addListener "response", (res)->
        output = res

        output.on 'data', (d)->
          data += d.toString('utf-8')

        output.on 'end', ()->
          parsedData = JSON.parse(data)

          if parsedData.error
            msg.send "Error searching Reader: #{parsedData.error}"
            return

          if parsedData.length > 0
            results = for article in parsedData[0..3]
              link = "https://read.codaisseur.com/topics/#{article.topics[0].slug}/articles/#{article.slug}"
              topics = for topic in article.topics
                topic.title

              {
                fallback: "<#{link}|#{article.title}>"
                color: "#c1272d"
                title: article.title
                title_link: link
                fields: [
                  {
                    title: "Topics",
                    value: topics.join(", ")
                    short: false
                  }
                ]
              }

            richMessage = {
              text: "I found #{parsedData.length} articles in the reader about *#{searchQuery}:"
              attachments: results
              channel: msg.envelope.room
              username: msg.robot.name
            }

            if parsedData.length-3 > 0
              console.log "Moaarrrr"
              richMessage.attachments.push {
                fallback: "<View #{parsedData.length-3} more results|https://read.codaisseur.com/search?search=#{encodeURIComponent(searchQuery)}"
                title: "View #{parsedData.length-3} more results"
                title_link: "https://read.codaisseur.com/search?search=#{encodeURIComponent(searchQuery)}"
                color: "warning"
              }

            msg.robot.adapter.customMessage richMessage

          else
            msg.reply "No articles found matching that search."
    )()
