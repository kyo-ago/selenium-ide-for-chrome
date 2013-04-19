"use strict"

@SeleniumIDE = class SeleniumIDE
	init : (param = {}) ->
		@speed = 0
		@ajax = new SeleniumAjax param.server || 'http://localhost:9515'
		@desiredCapabilities = param.desiredCapabilities || {}
		@requiredCapabilities = param.requiredCapabilities || {}
		@windowName = param.windowName || ''
		@sessionId = param.sessionId || ''

		@

	setSpeed : (@speed) ->

	getSessionId : ->
		if @sessionId
			return Deferred.connect((call)=> call({'sessionId' : @sessionId}))()
		@ajax.post('/session', {
			'desiredCapabilities' : @desiredCapabilities
			'requiredCapabilities' : @requiredCapabilities
		})

	setWindowName : (name) ->
		return if not name
		@ajax.post("/session/#{@sessionId}/window", {
			'name' : name
		})

	setURL : (url) ->
		return if not url
		@ajax.post("/session/#{@sessionId}/url", {
			'url' : url
		})

	connectionError : ->
		alert 'Connection Error.\nPlease start the selenium server.'
		chrome.tabs.query {
			'active' : true
			'windowType' : 'normal'
		}, (tabs) ->
			chrome.tabs.executeScript tabs[0].id, {
				'code' : 'window.open("https://code.google.com/p/chromedriver/downloads/list")'
			}

	send : (param) ->
		@getSessionId()
			.next((data) =>
				@sessionId = data.sessionId
			).error(@connectionError.bind(@))
			.next(@setWindowName.bind(@, @windowName))
			.next(@setURL.bind(@, param.baseURL))
			.next(@executeTest.bind(@, param.tests))

	executeTest : (tests) ->
		Deferred.loop(tests.length, (i) =>
			@execute tests[i]
			return undefined if not @speed
			return Deferred.wait @speed * 30
		)

	quit : ->
		@ajax.delete "/session/#{@sessionId}"

	execute : (test) ->
		@getElementId(test.selector).next(@executeTarget.bind(@, test))

	getElementId : (selector) ->
		@ajax.post "/session/#{@sessionId}/element", {
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
		@ajax.post "/session/#{@sessionId}/element/#{ elementId }/click"

	textElement : (elementId, value) ->
		@ajax.post "/session/#{@sessionId}/element/#{ elementId }/value", {
			'value' : value.split(/(?:)/)
		}

class SeleniumAjax
	constructor : (@server) ->

	ajax : (param) ->
		param.data = JSON.stringify param.data if typeof param.data isnt 'string'

		defer = Deferred()
		xhr = new XMLHttpRequest()

		xhr.onreadystatechange = =>
			return if xhr.readyState isnt 4
			return if xhr.status isnt 200
			defer.call JSON.parse xhr.responseText

		xhr.onerror = =>
			defer.fail {
				'type' : 'error.call'
			}

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
