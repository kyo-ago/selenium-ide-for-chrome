do =>
	global = @
	"use strict"

	controllers = ['menuPanelCtrl', 'testCaseCtrl', 'testCommandCtrl', 'messagesCtrl']

	mod = angular.module 'ng'
	for name in controllers
		mod.controller name, ['$scope', global[name]]

	@addEventListener 'DOMContentLoaded', ->
		scopes = {};
		for name in controllers
			scopes[name] = angular.element(document.querySelector('[ng-controller="'+name+'"]')).scope()

		chrome.extension.onMessage.addListener (msg)->
			return if msg.command isnt 'event'
			delete msg.command
			scopes['testCommandCtrl'].add msg

