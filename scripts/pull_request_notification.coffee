module.exports = (robot) ->
  robot.router.post '/github/webhook/pullrequests', (req, res) ->
    event_type = req.get 'X-Github-Event'
    data = req.body

    switch event_type
      when 'pull_request'
        message = postPullRequest data
#      when 'pull_request_review'
#        message = postPullRequestReview data
#      when 'pull_request_comment'
#        message = postPullRequestComment data

    robot.send {room: "#issues"}, message
    res.end ""

  postPullRequest = (data) ->
    action = data.action
    switch action
      when 'opened'
        message = "opened"
      when 'closed'
        message = "closed"
      when 'review_requested'
        message = "review_requested"
      when 'review_request_removed'
        message = "review_request_removed"
    return message

