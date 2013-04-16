"use strict"

@menuPanelCtrl = ($scope) ->
	$scope.operationRecording = true

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