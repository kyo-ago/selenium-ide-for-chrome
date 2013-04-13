"use strict"

@testCommandCtrl = ($scope) ->
	$scope.testCase = new TestCase()
	$scope.commandList = [
		{
			'value' : 'text'
			'text' : 'text'
		}
		{
			'value' : 'click'
			'text' : 'click'
		}
	]

	$scope.add = (command) ->
		$scope.testCase.unshift command
		$scope.$apply()

	@
