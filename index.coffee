express = require 'express'
network = require './src/network-connection'
games = require './src/game-manager'
ports = require './ports'

# create servers instances
app = express()
sockets = network.createServer app

# express configuration
app.set 'view engine', 'jade'

# express middlewares
app.use express.compress()
app.use '/public', express.static 'public'

# controllers
homeCtrl = require './controllers/home'
lobbyCtrl = require './controllers/lobby'
gameCtrl = require './controllers/game'

# get
app.get '/', homeCtrl.index
app.get '/lobby', lobbyCtrl.index
app.get '/game/:gameId?', gameCtrl.index

# post
app.get '/newgame', (request, response) ->
	console.log request.query
	games.newGame request.query['game-name'], request.query['game-count']

	response.redirect 301, '/lobby'

# servers running
app.listen ports.express, () -> console.log 'info: server started'
sockets.server.listen ports.sockets
network.connection sockets.io
