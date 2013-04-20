"use strict"

@menuPanelCtrl = ($scope) ->
	$scope.operationRecording = true
	$scope.operationSpeed = 0

	$scope.executeTestCase = ->
		tests = scopes['testCommandCtrl'].getTestCase()
		return if not tests.length
		return if not $scope.baseURL

		$scope.testExecuting = true
		selenium.send({
			'baseURL' : $scope.baseURL
			'tests' : tests
		}).next ->
			$scope.testExecuting = false
			$scope.$apply()

	$scope.changeOperationSpeed = ->
		selenium.setSpeed($scope.operationSpeed)

	$scope.quitBrowser = ->
		selenium.quit()

	@