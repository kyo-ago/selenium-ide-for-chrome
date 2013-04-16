"use strict"
global = @
global.scopes = {}
global.selenium = undefined

Deferred.onerror = ->
	console.debug(arguments)

DOMContentLoaded = (param) ->
	mod = angular.module 'ng'

	for elem in document.querySelectorAll('[ng-controller]')
		name = elem.getAttribute('ng-controller')
		mod.controller name, ['$scope', global[name]]
		global.scopes[name] = angular.element(elem).scope()

	global.scopes['menuPanelCtrl'].baseURL = param.LocationHref
	global.scopes['menuPanelCtrl'].$apply()

	chrome.extension.onMessage.addListener (msg)->
		return if not global.scopes['menuPanelCtrl'].operationRecording
		return if msg.command isnt 'event'
		delete msg.command
		global.scopes['testCommandCtrl'].add msg

	global.addEventListener 'click', (event) ->
		for key, val of global.scopes
			val.$emit event.type, event
	, true

	global.addEventListener 'keyup', (event) ->
		for key, val of global.scopes
			val.$emit event.type, event

LocationHref = (defer) ->
	chrome.tabs.query {
		'active' : true
		'windowType' : 'normal'
	}, (tabs) ->
		if tabs[0].url.match /^chrome:/
			alert 'Security Error.\ndoes not run on "chrome://" page.'
			global.close()
			return undefined
		defer tabs[0].url
		undefined

do =>
	global.selenium = new SeleniumIDE()
	global.selenium.init()
	Deferred.parallel({
		'load' : do ->
			defer = Deferred()
			document.addEventListener 'DOMContentLoaded', ->
				defer.call()
			defer
		'LocationHref' : Deferred.connect(LocationHref)()
	}).next(DOMContentLoaded)

