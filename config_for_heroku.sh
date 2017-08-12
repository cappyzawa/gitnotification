#!/usr/bin/env bash
export HUBOT_SLACK_TOKEN='xoxb-225226567635-gHcjqYDR0WVu5jTIahNIy2UB'
export HEROKU_URL='https://kutsuzawa-inc.herokuapp.com'
export HUBOT_SLACK_TEAM='kutsuzawa.inc'
export HUBOT_SLACK_BOTNAME='gibot'
export HUBOT_HEROKU_WAKEUP_TIME=9:00
export HUBOT_HEROKU_SLEEP_TIME=1:00
export TZ='Asia/Tokyo'
export HUBOT_HEROKU_KEEPALIVE_URL=$(heroku apps:info -s | grep web_url | cut -d= -f2)
