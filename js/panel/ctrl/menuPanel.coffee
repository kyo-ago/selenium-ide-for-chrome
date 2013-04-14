"use strict"

@menuPanelCtrl = ($scope) ->
	chrome.tabs.query {
		'active' : true
		'windowType' : 'normal'
	}, (tabs) ->
		chrome.tabs.executeScript tabs[0].id, {
			'code' : 'location.href'
		}, (results) ->
			$scope.baseURL = results[0]
			$scope.$apply()

	$scope.executeTestCase = ->
		tests = scopes['testCommandCtrl'].getTestCase()
		return if not tests.length
		return if not $scope.baseURL

		selenium.send({
			'baseURL' : $scope.baseURL
			'tests' : tests
		})

	$scope.quitBrowser = ->
		selenium.quit()

	@