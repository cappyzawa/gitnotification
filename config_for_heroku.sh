#!/usr/bin/env bash
heroku config:set HUBOT_SLACK_TOKEN='xoxb-225226567635-gHcjqYDR0WVu5jTIahNIy2UB'
heroku config:set HEROKU_URL='https://shu-gibot.herokuapp.com'
heroku config:set HUBOT_SLACK_TEAM='kutsuzawa.inc'
heroku config:set HUBOT_SLACK_BOTNAME='gibot'
heroku config:set HUBOT_HEROKU_WAKEUP_TIME=9:00
heroku config:set HUBOT_HEROKU_SLEEP_TIME=1:00
heroku config:set TZ='Asia/Tokyo'
heroku config:set HUBOT_HEROKU_KEEPALIVE_URL=$(heroku apps:info -s | grep web_url | cut -d= -f2)
