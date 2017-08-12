github = require('githubot')

module.exports = (robot) ->
  robot.router.post '/github/webhook', (req, res) ->

#    data = req.body
#    if data.action not in ['assigned', 'unassigned']
#      return res.end ""

    robot.send {room: "#github"}, "yahoo"
    res.end ""

