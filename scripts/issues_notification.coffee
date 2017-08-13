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
        slackUser = eval("process.env.#{issue.user.login}")
        message = "#{issue.title} #{issue.number} が@#{slackUser}により <#{issue.html_url}|作成>されました"
      when 'closed'
        slackUser = eval("process.env.#{issue.user.login}")
        message = "#{issue.title} #{issue.number} が@#{slackUser}により <#{issue.html_url}|終了>されました"
      when 'reopened'
        slackUser = eval("process.env.#{issue.user.login}")
        message = "#{issue.title} #{issue.number} が@#{slackUser}により <#{issue.html_url}|再開>されました"
      when 'assigned'
        slackUser = eval("process.env.#{issue.assignee.login}")
        message = "@#{slackUser} <#{issue.html_url}|#{issue.title} #{issue.number}>の担当になりました"
      when 'unassigned'
        slackUser = eval("process.env.#{issue.assignee.login}")
        message = "@#{slackUser} <#{issue.html_url}|#{issue.title} #{issue.number}>の担当ではなくなりました"
    return message

  postIssueComment = (data) ->
    action = data.action
    issue_comment = data.comment
    slackUser = eval("process.env.#{issue_comment.user.login}")
    switch action
      when 'created'
        message = "@#{slackUser}さんが #{issue_comment.body}って言ってますよ"
      when 'deleted'
        message = "@#{slackUser}さんが #{issue_comment.body}を取り消したよ"
    return message
