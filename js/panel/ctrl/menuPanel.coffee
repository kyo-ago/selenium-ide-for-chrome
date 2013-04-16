"use strict"

@menuPanelCtrl = ($scope) ->
	$scope.operationRecording = true
	$scope.operationSpeed = 0

	$scope.executeTestCase = ->
		tests = scopes['testCommandCtrl'].getTestCase()
		return if not tests.length
		return if not $scope.baseURL

		selenium.send({
			'baseURL' : $scope.baseURL
			'tests' : tests
		})

	$scope.changeOperationSpeed = ->
		selenium.setSpeed($scope.operationSpeed)

	$scope.quitBrowser = ->
		selenium.quit()

	@