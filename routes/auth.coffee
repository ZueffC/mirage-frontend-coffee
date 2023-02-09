SHA384 = require('crypto-js/sha384')
axios = require('axios')

getRightUrl = (url, adding) ->
  if url[url.length - 1] == '/'
    query_url = url + adding
  else
    query_url = url + '/' + adding

loginRoute = (req, res) ->
  token = res.generateCsrf()
  res.view 'login',
    'title': 'Login to Mirage'
    'token': token
  return

registrationRoute = (req, res) ->
  token = res.generateCsrf()
  res.view 'registration',
    'title': 'Registration to Mirage'
    'token': token
  return

loginPostRoute = (req, res) ->
  data = req.body
  query_url = ''
  node_url = ''
  query_url = getRightUrl(data.node_url, 'users/auth')
  node_url = data.node_url
  if Array.isArray(data.node_url)
    query_url = getRightUrl(data.node_url[1], 'users/auth')
    node_url = data.node_url[1]
  console.log query_url, node_url, data
  axios.post(query_url,
    type: 'login'
    nick: data.nick
    email: data.email
    password: SHA384(data.password).toString()).then (response) ->
    if response.data.ID > 0 and response.data.nick.length > 0
      req.session.node_url = node_url
      req.session.id = response.data.ID
      req.session.nick = response.data.nick
      req.session.email = response.data.email
      req.session.save()
    return
  res.redirect '/'
  return

registerPostRoute = (req, res) ->
  if req.body.node_url
    data = req.body
    query_url = ''
    node_url = ''
    query_url = getRightUrl(data.node_url, 'users/auth')
    node_url = data.node_url
    if Array.isArray(data.node_url)
      query_url = getRightUrl(data.node_url[1], 'users/auth')
      node_url = data.node_url[1]
    axios.post query_url,
      type: 'registration'
      nick: data.nick
      email: data.email
      password: SHA384(data.password).toString()
    res.redirect '/login'
  else
    res.redirect '/'
  return

module.exports =
  loginRoute: loginRoute
  registrationRoute: registrationRoute
  loginPostRoute: loginPostRoute
  registerPostRoute: registerPostRoute
  getRightUrl: getRightUrl

