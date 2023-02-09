

axios = require('axios')

getUserPackagesRouter = (req, res) ->
  if !req.session.id and !req.session.node_url
    res.redirect '/login'
  else
    getInformationUrl = getRightUrl(req.session.node_url, 'packages/get')
    information = axios.post(getInformationUrl,
      type: 'all'
      id: req.session.id).then((response) ->
      res.view 'packages',
        title: 'Package'
        data: response.data
      return
    )
  return

module.exports =
  getUserPackagesRouter: getUserPackagesRouter
  postCreateRoute: postCreateRoute

# ---
# generated by js2coffee 2i2.0


postCreateRoute = (req, res) ->
  if !req.body
    return null
  else
    addPackageUrl = getRightUrl(req.session.node_url, 'packages')
    axios.post addPackageUrl,
      type: 'new_package'
      name: req.body[0]
      description: req.body[1]
      git_url: req.body[2]
      author_id: req.session.id
  return
