module.exports = userParser: (login) ->
  login.replace /-/g, "_"
