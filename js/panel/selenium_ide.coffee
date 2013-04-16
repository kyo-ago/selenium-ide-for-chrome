"use strict"

@SeleniumIDE = class SeleniumIDE
	init : (param = {}) ->
		@speed = 0
		@ajax = new SeleniumAjax param.server || 'http://localhost:9515'
		@desiredCapabilities = param.desiredCapabilities || {}
		@requiredCapabilities = param.requiredCapabilities || {}
		@windowName = param.windowName || ''

		@

	setSpeed : (@speed) ->

	getSessionId : ->
		@ajax.post('/session', {
			'desiredCapabilities' : @desiredCapabilities
			'requiredCapabilities' : @requiredCapabilities
		})

	setWindowName : (name) ->
		return if not name
		@ajax.post('/session/:sessionId/window', {
			'name' : name
		})

	setURL : (url) ->
		return if not url
		@ajax.post('/session/:sessionId/url', {
			'url' : url
		})

	send : (param) ->
		@getSessionId()
			.next((data) =>
				if data.error is 'xhr.onerror'
					alert 'Connection Error.\nPlease start the selenium server.'
					chrome.tabs.query {
							'active' : true
							'windowType' : 'normal'
						}, (tabs) ->
							chrome.tabs.executeScript tabs[0].id, {
								'code' : 'window.open("https://code.google.com/p/chromedriver/downloads/list")'
							}
					return undefined
				@ajax.set('sessionId', data.sessionId)
			).next(@setWindowName.bind(@, @windowName))
			.next(@setURL.bind(@, param.baseURL))
			.next(@executeTest.bind(@, param.tests))

	executeTest : (tests) ->
		Deferred.loop(tests.length, (i) =>
			test = new SeleniumTest @ajax
			test.execute tests[i]
			return undefined if not @speed
			return Deferred.wait @speed * 30
		)

	quit : ->
		@ajax.delete('/session/:sessionId')

class SeleniumTest
	constructor : (@ajax) ->

	execute : (test) ->
		@getElementId(test.selector).next(@executeTarget.bind(@, test))

	getElementId : (selector) ->
		@ajax.post '/session/:sessionId/element', {
			'using' : 'css selector'
			'value' : selector
		}

	executeTarget : (test, data) ->
		id = data.value.ELEMENT
		if test.name is 'click'
			@clickElement(id)
		else
			@textElement(id, test.value)

	clickElement : (elementId) ->
		@ajax.post "/session/:sessionId/element/#{ elementId }/click"

	textElement : (elementId, value) ->
		@ajax.post "/session/:sessionId/element/#{ elementId }/value", {
			'value' : value.split(/(?:)/)
		}


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
		xhr.onerror = =>
			defer.call({
				'error' : 'xhr.onerror'
			})
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
