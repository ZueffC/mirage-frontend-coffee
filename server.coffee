fastify = require('fastify')()
fs = require('fs')
fastifySession = require('@fastify/session')
fastifyCookie = require('@fastify/cookie')
path = require('node:path')
crypto = require('node:crypto')
indexRouter = require('./routes/index')
authRouter = require('./routes/auth')
profileRouter = require('./routes/profile')
packagesRouter = require('./routes/packages')

PORT = process.env.PORT or 5000
secret = crypto.randomBytes(20).toString('hex')

fastify.register require('@fastify/csrf-protection'), sessionPlugin: '@fastify/session'
fastify.register require('@fastify/formbody')
fastify.register fastifyCookie
fastify.register fastifySession,
  secret: secret
  cookie: secure: false
  expires: 1800000

fastify.register require('@fastify/static'),
  root: path.join(__dirname, 'static')
  prefix: '/static/'
  
fastify.decorateReply 'locals', null
fastify.addHook 'preHandler', (req, reply, next) ->
  reply.locals = {}
  reply.locals.session = req.session
  console.log req.session.id, req.session.nick, req.session.node_url, req.session.__csrf
  next()
  return
fastify.register require('@fastify/view'),
  engine: eta: require('eta')
  root: path.join(__dirname, 'templates')
  viewExt: 'html'
fastify.get '/', indexRouter.indexRoute
fastify.get '/profile', profileRouter.profileRoute
fastify.get '/packages', packagesRouter.getUserPackagesRouter
fastify.get '/login', authRouter.loginRoute
fastify.get '/registration', authRouter.registrationRoute
fastify.post '/registration', authRouter.registerPostRoute
fastify.post '/login', authRouter.loginPostRoute
fastify.get '/start-on-unix.sh', (req, res) ->
  buffer = fs.readFileSync('./installation')
  res.type 'text/plain'
  res.send buffer
  return
fastify.listen 10000

