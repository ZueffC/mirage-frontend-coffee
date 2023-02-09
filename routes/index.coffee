indexRoute = (req, res) ->
  res.view 'index.eta', 'title': 'Lightweight and efficient package manager'
  return

module.exports = indexRoute: indexRoute
