module.exports = (robot) ->
  robot.router.post '/github/webhook/issues', (req, res) ->
    event_type = req.get 'X-Github-Event'
    data = req.body

    switch event_type
      when 'issues'
        postIssue data
      when 'issue_comment'
        postIssueComment data
      else
        return
    res.end ""

  postIssue = (data) ->
    action = data.action
    issue = data.issue
    assignee = data.issue.assignee
    slackUser = eval("process.env.#{issue.user.login}")
    color=""
    word=""
    switch action
      when 'opened'
        color = "#c8ff00"
        word = "を作成しました"
      when 'closed'
        color = "#dc4000"
        word = "をクローズしました"
      when 'reopened'
        color = "#96ffdc"
        word = "を再開しました"
      when 'assigned'
        slackUser = eval("process.env.#{assignee.login}")
        color = "#0000ff"
        word = "の担当になりました"
      when 'unassigned'
        slackUser = eval("process.env.#{assignee.login}")
        color = "#d2d2d3"
        word ="の担当ではなくなりました"
      else
        return
    makeAttachments data, slackUser, color, word, "issue"
    return

  postIssueComment = (data) ->
    action = data.action
    issue_comment = data.comment
    assignee = data.issue.assignee
    targetSlackUser = eval("process.env.#{assignee.login}")
    console.log "target: #{targetSlackUser}"
    sourceSlackUser = eval("process.env.#{issue_comment.user.login}")
    console.log "source: #{sourceSlackUser}"
    switch action
      when 'created'
        if targetSlackUser != sourceSlackUser
          console.log "ifはいった"
          color = "#c864c8"
          word = "コメントがあります"
          makeAttachments data, targetSlackUser, color, word, "comment"
        else
          console.log "else"
          return
      else
        return
    return

  makeAttachments = (data, slackUser, color, word, type) ->
    assigneeList = []
    for assigneeBody in data.issue.assignees
      assignee = eval("process.env.#{assigneeBody.login}")
      assignee = "@#{assignee}"
      assigneeList.push(assignee)
    assigneeStrForNotification = assigneeList.join ', '
    assigneeStrForDisplay = assigneeList.join '\n'
    register = eval("process.env.#{data.sender.login}")
    pretext = ""
    text = ""
    if type is 'issue'
      pretext = "#{slackUser}が issue##{data.issue.number} #{word}"
      text = "#{data.issue.body}"
    else if type is 'comment'
      pretext = "#{register}から#{assigneeStrForNotification}に#{word}"
      text = "#{data.comment.body}"

    message = {
      "attachments": [
        {
          "fallback": "#{pretext}",
          "color": "#{color}",
          "pretext": "#{pretext}",
          "title": "##{data.issue.number} #{data.issue.title}",
          "title_link": "#{data.issue.html_url}",
          "text": "#{text}",
          "fields": [
            {
              "title": "register",
              "value": "#{register}",
              "short": true
            },
            {
              "title": "assignee",
              "value": "#{assigneeStrForDisplay}"
              "short": true
            }
          ],
          "thumb_url": "#{data.sender.avatar_url}",
          "footer": "Github",
          "footer_icon": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7G9JTqB8z1AVU-Lq7xLy1fQ3RMO-Tt6PRplyhaw75XCAnYvAYxg",
          "ts": data.issue.created_at
        }
      ]
    }

    robot.send {room: "#issues"}, message
