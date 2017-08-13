module.exports = (robot) ->
  robot.router.post '/github/webhook/projects', (req, res) ->

    event_type = req.get 'X-Github-Event'
    data = req.body

    switch event_type
      when 'project_card'
        prepareForNotificationOfProjectCard data
      else
        return
    res.end ""

  prepareForNotificationOfProjectCard = (data) ->
    action = data.action
    sender = data.sender
    console.log(process.env)
    cmd = ""
    if eval("process.env.#{sender.login}")?
      cmd = "process.env.#{sender.login}"
    login_name = eval(cmd)
    switch action
      when 'created', 'deleted'
        makeAttachments data, login_name
      else return

  makeAttachments = (data, login_name) ->
    robot.http("#{data.project_card.column_url}")
      .header('Accept', 'application/vnd.github.inertia-preview+json')
      .header('Authorization', "token #{process.env.HUBOT_GITHUB_TOKEN}")
      .get() (err, res, body) ->
      parsedBody = JSON.parse body
      column_name = parsedBody.name
      color = "#000000"
      if data.action is 'created'
        color = "#36a64f"
        pretext = "にカードを追加しました"
      else if data.action is 'deleted'
        color = "#ff0000"
        pretext = "からカードを削除しました"
      message = {
        "attachments": [
          {
            "fallback": "Required plain-text summary of the attachment.",
            "color": "#{color}",
            "pretext": "@#{login_name}が 【#{column_name}】 #{pretext}",
            "author_name": "#{login_name}",
            "title": "#{data.action} card",
            "title_link": "#{data.repository.html_url}/projects/",
            "text": "#{data.project_card.note}",
            "thumb_url": "#{data.sender.avatar_url}",
            "footer": "Github",
            "footer_icon": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7G9JTqB8z1AVU-Lq7xLy1fQ3RMO-Tt6PRplyhaw75XCAnYvAYxg",
            "ts": data.project_card.created_at
          }
        ]
      }
      robot.send {room: "#projects"}, message
