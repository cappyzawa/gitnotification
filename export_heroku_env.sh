#!/usr/bin/env bash
heroku config:set HUBOT_SLACK_BOTNAME='gibot'
heroku config:set TZ='Asia/Tokyo'
heroku config:set HUBOT_HEROKU_KEEPALIVE_URL=`heroku config:set HUBOT_HEROKU_KEEPALIVE_URL=$(heroku apps:info -s | grep web.url | cut -d= -f2)`
# add  your env
## must
heroku config:set HEROKU_URL=
heroku config:set HUBOT_URL=`heroku config:get HEROKU_URL`
heroku config:set HUBOT_SLACK_TOKEN=
heroku config:set HUBOT_SLACK_TEAM=
heroku config:set HUBOT_GITHUB_TOKEN=



## parse github user -> slack user
# heroku config:set shu920921=zawamaru
