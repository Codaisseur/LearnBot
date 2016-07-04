# Description:
#   Random responses. We can all make one.

module.exports = (robot) ->

  haters = [
    "https://media.giphy.com/media/lXiRKeGZeOyEpRHkk/giphy.gif",
    "https://media.giphy.com/media/jBI8UR5hZ5vdm/giphy.gif",
    "http://mrwgifs.com/wp-content/uploads/2013/03/Flower-The-Skunk-Haters-Gonna-Hate-Bambi-Gif.gif",
    "http://cdn.smosh.com/sites/default/files/legacy.images/smosh-pit/052011/haters-car.gif",
  ]

  robot.hear /(^|\s)hat(e|i)(r|s|ng)?(\s|.?$)/i, (msg) ->
    msg.send "*Haters gonna hate* #{msg.random haters}"

  robot.hear /phew/i, (msg) ->
    msg.reply "_That's a relief!_"
