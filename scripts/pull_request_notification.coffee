module.exports = (robot) ->
  robot.router.post '/github/webhook/pullrequests', (req, res) ->
    event_type = req.get 'X-Github-Event'
    data = req.body

    switch event_type
      when 'pull_request'
        message = postPullRequest data
      when 'pull_request_review'
        message = postPullRequestReview data
      when 'pull_request_comment'
        message = postPullRequestComment data

    robot.send {room: "#pullrequests"}, message
    res.end ""

  postPullRequest = (data) ->
    action = data.action
    pullRequest = data.pull_request
    reviewer = data.requested_reviewer
    switch action
      when 'opened'
        slackUser = eval("process.env.#{pullRequest.user.login}")
        message = "#{slackUser}さんが <#{pullRequest.html_url}|#{pullRequest.title} \##{pullRequest.number}>を作成しました"
      when 'closed'
        slackUser = eval("process.env.#{pullRequest.user.login}")
        message = "#{slackUser}さんが <#{pullRequest.html_url}|#{pullRequest.title} \##{pullRequest.number}>を終了しました"
      when 'review_requested'
        slackUser = eval("process.env.#{reviewer.login}")
        message = "@#{slackUser} <#{pullRequest.html_url}|#{pullRequest.title} ##{pullRequest.number}>のレビューを依頼されました"
      when 'review_request_removed'
        slackUser = eval("process.env.#{reviewer.login}")
        message = "@#{slackUser} <#{pullRequest.html_url}|#{pullRequest.title} ##{pullRequest.number}>のレビューが取り消されました"
    return message

  postPullRequestComment = (data) ->
    action = data.action
    comment = data.comment
    pullRequest = data.pull_request
    assignee = pullRequest.assignee
    switch action
      when 'created'
        targetSlackUser = eval("process.env.#{assignee.login}")
        sourceSlackUser = eval("process.env.#{comment.user.login}")
        message = "@#{targetSlackUser} #{comment.body} in <#{pullRequest.html_url}|#{pullRequest.title} ##{pullRequest.number}> by #{sourceSlackUser}"
    return message
