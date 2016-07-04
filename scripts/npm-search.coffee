#  NPM search
#
# npm search <your query here>
#

npmsearch = require('npm-keywordsearch')

module.exports = (robot) ->
  robot.respond /npm search (.*)/i, (msg) ->
    searchQuery = msg.match[1]

    packageSearch msg, searchQuery

  packageSearch = (msg, searchQuery) ->
    npmsearch searchQuery, (error, packages) ->

      pkgs = for pkg in packages[0..3]
        "*#{pkg.name}*\n#{pkg.description} #{pkg.url}"

      msg.send pkgs.join("\n")
