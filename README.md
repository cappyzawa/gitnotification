# gibot
## 概要
slackとgithubのユーザ名の差を吸収して、githubのeventをslackに通知してくれるhubot
heroku、docker上で動作を確認した

## install

### リポジトリをcloneする
```bash
$ git clone https://github.com/kutsuzawa/gitnotification.git
```

### それぞれの環境(heroku or docker)に適した設定を行う
[Jump to heroku settings](https://github.com/kutsuzawa/gitnotification#heroku)

[Jump to docker settings](https://github.com/kutsuzawa/gitnotification#docker)


### githubのweb hooksを設定
それぞれのpayloadの設定
* project に関する通知 : http://yourhost/github/webhook/projects
* issue に関する通知 : http://yourhost/github/webhook/issues
* pull request に関する記述 : http://yourhost/github/webhook/pullrequests

*dockerで立てた場合portは8090番*


## heroku
### 環境変数の設定
`export_heroku_env.sh`に環境変数を記述

`HUBOT_SLACK_TOKEN`: hubotのアクセスを許可したslackのtoken

`HUBOT_SLACK_TEAM`: HUBOTを導入しているチーム名

`HUBOT_GITHUB_TOKEN`: GitHubのpersonal token

設定後 `export_heroku_env.sh`を実行。
初回だけでかまわない

チームメンバーが増えるたび、随時 `heroku config:set <GITHUB_NAME>=<SLACK_NAME>`を実行。

### deploy
```
$ git push heroku master
```

## docker
### 環境変数の設定
`docker.env`を`my.docker.env`としてcopy

```bash
$ cp docker.env my.docker.env
```

***my.docker.envという名前でないと動作しません***

あとはherokuの場合と同様に環境変数を記述していく

### 起動
`docker-compose`を使用

```bash
$ docker-compose build
$ docker-compose up -d
```

