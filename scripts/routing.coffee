module.exports = (robot) ->
  robot.router.post '/github/webhook', (req, res) ->
    event_type = req.get 'X-Github-Event'
    payload = ""

    switch true
      when /^issue.*/.test(event_type)
        payload = "issues"
        routingPostData req, payload
      when /^pull_request.*/.test(event_type)
        payload = "pullrequests"
        routingPostData req, payload
      when /^project.*/.test(event_type)
        payload = "projects"
        routingPostData req, payload
      else
        console.log "else"
        return

    res.end ""

  routingPostData = (req, payload) ->
    data = JSON.stringify req.body
    event_type = req.get 'X-Github-Event'
    robot.http("#{process.env.HUBOT_URL}github/webhook/#{payload}")
      .header('Content-Type', 'application/json')
      .header('X-Github-Event', event_type)
      .post(data) () ->
        return
