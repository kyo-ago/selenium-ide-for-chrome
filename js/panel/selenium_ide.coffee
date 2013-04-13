"use strict"

@SeleniumIDE = class SeleniumIDE
	init : (param = {}) ->
		@ajax = new SeleniumAjax param.server || 'http://localhost:9515'
		@desiredCapabilities = param.desiredCapabilities || {}
		@requiredCapabilities = param.requiredCapabilities || {}
		@windowName = param.windowName || ''
		@getSessionId().next((result) =>
			@ajax.set('sessionId', result.sessionId)
		).next(@setWindowName.bind(@)).next(@setUrl.bind(@))

		@

	getSessionId : ->
		@ajax.post('/session', {
			'desiredCapabilities' : @desiredCapabilities
			'requiredCapabilities' : @requiredCapabilities
		})

	setWindowName : (name = @windowName) ->
		return if not name
		@ajax.post('/session/:sessionId/window', {
			'name' : name
		})

	setUrl : (url) ->
		@ajax.post('/session/:sessionId/url', {
			'url' : 'http://frtrt.net/'
		})

	send : () ->
#		param = @scopes.testCommandCtrl.getTestCase()

	quit : ->
		@ajax.delete('/session/:sessionId')

class SeleniumAjax
	constructor : (@server, @param = {}) ->

	set : (key, val) ->
		@param[key] = val

	ajax : (param) ->
		param.data = JSON.stringify param.data if typeof param.data isnt 'string'
		param.url = param.url.replace /:(\w+)/g, (all, name) =>
			@param[name]

		defer = Deferred()
		xhr = new XMLHttpRequest()
		xhr.onreadystatechange = =>
			return if xhr.readyState isnt 4
			return if xhr.status isnt 200
			defer.call JSON.parse xhr.responseText
		xhr.open param.method, @server + param.url
		xhr.send param.data
		defer

	post : (url, param = '') ->
		@ajax {
			'url' : url
			'data' : param
			'method' : 'POST'
		}

	get : (url) ->
		@ajax {
			'url' : url
			'method' : 'GET'
		}

	delete : (url, param = '') ->
		@ajax {
			'url' : url
			'data' : param
			'method' : 'DELETE'
		}
