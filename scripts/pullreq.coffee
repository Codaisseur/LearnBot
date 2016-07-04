# Description:
#   Notify of any new pull requests on this bot's repo
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
  robot.router.post '/github/pull', (req, res) ->
    event = req.headers['x-github-event']
    console.log "Event: ", event

    if event == "pull_request"
      data = req.body
      console.log data

      title = data.pull_request.title
      pull_url = data.pull_request.html_url
      contributor = data.pull_request.user.login

      console.log "ACTION: ", data.action
      console.log "MERGED: ", data.merged_at

      if data.action == "opened"
        robot.messageRoom "#general", "Yay! *#{contributor}* wrote a new feature for me! *#{title}*\n > #{pull_url}"

      if data.action == "closed" && data.merged_at
        robot.messageRoom "#general", "Yay! A new feature *#{title}* by *#{contributor}* for me was merged!\n> #{pull_url}"

    res.send 'OK'
