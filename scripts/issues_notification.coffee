module.exports = (robot) ->
  robot.router.post '/github/webhook/issues', (req, res) ->
    event_type = req.get 'X-Github-Event'
    data = req.body

    switch event_type
      when 'issues'
        message = postIssue data
      when 'issue_comment'
        message = postIssueComment data
      else
        message = ""

    robot.send {room: "#issues"}, message
    res.end ""

  postIssue = (data) ->
    action = data.action
    issue = data.issue
    assignee = data.assignee
    switch action
      when 'opened'
        slackUser = eval("process.env.#{issue.user.login}")
        message = "#{slackUser}さんが <#{issue.html_url}|#{issue.title} \##{issue.number}>を作成しました"
      when 'closed'
        slackUser = eval("process.env.#{issue.user.login}")
        message = "#{slackUser}さんが <#{issue.html_url}|#{issue.title} \##{issue.number}>を終了しました"
      when 'reopened'
        slackUser = eval("process.env.#{issue.user.login}")
        message = "#{slackUser}さんが <#{issue.html_url}|#{issue.title} \##{issue.number}>を再開しました"
      when 'assigned'
        slackUser = eval("process.env.#{assignee.login}")
        message = "@#{slackUser} <#{issue.html_url}|#{issue.title} #{issue.number}>の担当になりました"
      when 'unassigned'
        slackUser = eval("process.env.#{assignee.login}")
        message = "@#{slackUser} <#{issue.html_url}|#{issue.title} \##{issue.number}>の担当ではなくなりました"
      else
        message = ""
    return message

  postIssueComment = (data) ->
    action = data.action
    issue_comment = data.comment
    assignee = data.issue.assignee
    targetSlackUser = eval("process.env.#{assignee.login}")
    sourceSlackUser = eval("process.env.#{issue_comment.user.login}")
    switch action
      when 'created'
        message = "@#{targetSlackUser} #{issue_comment.body} by #{sourceSlackUser}"
      else
        message = ""
    return message
