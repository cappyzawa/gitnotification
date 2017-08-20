userParser = require('./user_parser').userParser

module.exports = (robot) ->
  robot.router.post '/github/webhook/pullrequests', (req, res) ->
    event_type = req.get 'X-Github-Event'
    data = req.body

    switch event_type
      when 'pull_request'
        postPullRequest data
      when 'pull_request_review'
        postPullRequestReviewComment data
      else
        return

    res.end ""

  postPullRequest = (data) ->
    action = data.action
    pullRequest = data.pull_request
    reviewer = data.requested_reviewer
    switch action
      when 'opened'
        slackUser = eval("process.env.#{userParser pullRequest.user.login}")
        color = "#c8ff00"
        word = "を作成しました"
        makeAttachments data, slackUser, color, word, "pull_request"
      when 'closed'
        slackUser = eval("process.env.#{userParser pullRequest.user.login}")
        color = "#dc4000"
        word = "をクローズしました"
        makeAttachments data, slackUser, color, word, "pull_request"
      when 'review_requested'
        slackUser = eval("process.env.#{userParser reviewer.login}")
        color = "#0000ff"
        word = "にレビュー依頼があります"
        makeAttachments data, slackUser, color, word, "review_request"
      when 'review_request_removed'
        slackUser = eval("process.env.#{userParser reviewer.login}")
        color = "#d2d2d3"
        word = "へのレビュー依頼が取り消されました"
        makeAttachments data, slackUser, color, word, "review_request"
      else
        return
    return

  postPullRequestReviewComment = (data) ->
    action = data.action
    pullRequest = data.pull_request
    assignee = pullRequest.assignee
    switch action
      when 'submitted'
        targetSlackUser = eval("process.env.#{assignee.login}")
        color = "#34adc6"
        word = "にコメントがあります"
        makeAttachments data, targetSlackUser, color, word, "comment"
      else
        return
    return

  makeAttachments = (data, slackUser, color, word, type) ->
    reviewersList = []
    for reviewerBody in data.pull_request.requested_reviewers
      reviewer = eval("process.env.#{reviewerBody.login}")
      reviewer = "@#{reviewer}"
      reviewersList.push(reviewer)
    reviewerStrForNotification = reviewersList.join ', '
    reviewerStrForDisplay = reviewersList.join '\n'
    register = eval("process.env.#{data.sender.login}")
    pretext = ""
    text = ""
    if type is 'pull_request'
      pretext = "#{slackUser}が *【Pull Request】* #{word}"
      text = "#{data.pull_request.body}"
    else if type is 'review_request'
      pretext = "#{register}から#{reviewerStrForNotification}に#{word}"
      text = "#{data.pull_request.body}"
    else if type is "comment"
      pretext = "#{register}から#{slackUser}#{word}"
      text = "#{data.review.body}"
      register = "@#{register}"

    message = {
      "attachments": [
        {
          "fallback": "#{pretext}",
          "color": "#{color}",
          "pretext": "#{pretext}",
          "title": "#{data.pull_request.title}",
          "title_link": "#{data.pull_request.html_url}",
          "mrkdwn": true,
          "text": "#{text}",
          "mrkdwn_in": ["pretext", "text"],
          "fields": [
            {
              "title": "assignee",
              "value": "#{register}",
              "short": true
            },
            {
              "title": "reviewer",
              "value": "#{reviewerStrForDisplay}"
              "short": true
            }
          ],
          "thumb_url": "#{data.sender.avatar_url}",
          "footer": "Github",
          "footer_icon": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7G9JTqB8z1AVU-Lq7xLy1fQ3RMO-Tt6PRplyhaw75XCAnYvAYxg",
          "ts": data.pull_request.created_at
        }
      ]
    }

    robot.send {room: "#pullrequests"}, message
