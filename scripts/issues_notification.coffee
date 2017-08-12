module.exports = (robot) ->
  robot.router.post '/github/webhook/issues', (req, res) ->

    data = req.body
    action = data.action
    issue = data.issue
    title = issue.title

    message = "Issueに<#{issue.html_url}|#{action}>のアクションを検知"

    robot.send {room: "#github"}, message
    res.end ""
