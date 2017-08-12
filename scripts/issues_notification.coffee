module.exports = (robot) ->
  robot.router.post '/github/webhook/issues', (req, res) ->

    event_type = req.get 'X-Github-Event'
    data = req.body
    action = data.action
    issue = data.issue

    switch event_type
      when 'issues'
        message = "Issueに<#{issue.html_url}|#{action}>のアクションを検知"
      when 'issue_comment'
        message = "Issueに<#{issue.html_url}|#{action}>のアクションを検知した"

    robot.send {room: "#github"}, message
    res.end ""
