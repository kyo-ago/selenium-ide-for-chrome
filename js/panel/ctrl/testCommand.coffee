"use strict"

@testCommandCtrl = ($scope) ->
	$scope.testCase = new TestCase()

	$scope.add = (command) ->
		$scope.testCase.unshift command
		$scope.$apply()
	@