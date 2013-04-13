"use strict"

@menuPanelCtrl = ($scope) ->
	chrome.tabs.query {
		'active' : true
		'windowType' : 'normal'
	}, (tabs) ->
		chrome.tabs.executeScript tabs[0].id, {
			'code' : 'location.origin'
		}, (results) ->
			$scope.baseURL = results[0]
			$scope.$apply()

	$scope.executeTestCase = ->
		selenium.send()

	$scope.quitBrowser = ->
		selenium.quit()

	@