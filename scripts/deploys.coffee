# Description:
#   Notify of any new deploys on this bot
#

module.exports = (robot) ->
  robot.router.post '/deploys', (req, res) ->
    data = req.query
    console.log data

    console.log "VERSION: ", data.release

    robot.messageRoom "#general", "Bleep! Installing new #{data.release} firmware... (#{data.head})"

    res.send 'OK'
