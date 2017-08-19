module.exports = parsedUser: (login) ->
  login.replace /-/g, "_"
