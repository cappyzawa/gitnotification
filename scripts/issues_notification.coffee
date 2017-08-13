module.exports = (robot) ->
  robot.router.post '/github/webhook/issues', (req, res) ->

    event_type = req.get 'X-Github-Event'
    data = req.body

    switch event_type
      when 'issues'
        message = postIssue data
      when 'issue_comment'
        message = postIssueComment data

    robot.send {room: "#issues"}, message
    res.end ""

  postIssue = (data) ->
    action = data.action
    issue = data.issue
    switch action
      when 'opend'
        message = "#{issue.title} #{issue.number} が#{issue.user.login}により <作成|#{issue.html_url}>されました"
      when 'closed'
        message = "#{issue.title} #{issue.number} が#{issue.user.login}により <終了|#{issue.html_url}>されました"
      when 'reopend'
        message = "#{issue.title} #{issue.number} が#{issue.user.login}により <再開|#{issue.html_url}>されました"
    return message

  postIssueComment = (data) ->
    action = data.action
    issue_comment = data.comment
    switch action
      when 'created'
        message = " #{issue_comment.user.login}さんが #{issue_comment.body}って言ってますよ"
      when 'deleted'
        message = " #{issue_comment.user.login}さんが #{issue_comment.body}を取り消したよ"
    return message
