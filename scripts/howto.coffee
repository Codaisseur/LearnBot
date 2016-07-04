module.exports = (robot) ->

  githash = {}

  githash["one"] = ["git init", "Create an empty Git repository or reinitialize an existing one", "https://git-scm.com/docs/git-init"]
  githash["two"] = ["git add <filename(s)>", "Add file contents to the index", "https://git-scm.com/docs/git-add"]
  githash["three"] = ["git commit -m <'message'>", "Record changes to the repository", "https://git-scm.com/docs/git-commit"]
  githash["four"] = ["git remote add origin <SSH/HTTPS url>", "Manage set of tracked repositories", "https://git-scm.com/docs/git-remote"]
  githash["five"] = ["git push -u origin master", "Update remote refs along with associated objects", "https://git-scm.com/docs/git-push"]

  what = ['Google it', 'I dont know this', 'lalalaicanthearyoulalala', 'I am on a break']

  robot.hear /how to (.*)/i, (msg) ->
    subject = msg.match[1].toLowerCase()
    if subject is "git"
      msg.reply "How to set up a new Git project:\n"
      counter = 0
      for key, value of githash
        infotitle = value[0]
        infocontent = value[1]
        infourl = value[2]
        counter += 1
        msg.reply "Step #{counter}/#{Object.keys(githash).length} - #{infocontent}:\nDocumentation: #{infourl}\nIn your project directory type:\n>>> #{infotitle}\n"
    else
      msg.reply msg.random what

  robot.hear /howtolist/i, (msg) ->
    msg.reply "Available subjects: git.\nType 'how to <subject>' to learn more."
