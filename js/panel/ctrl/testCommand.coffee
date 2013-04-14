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
		$scope.testCase.push command
		$scope.$apply()

	$scope.getTestCase = ->
		cmds = for cmd in $scope.testCase.toArray() then cmd.attributes
		cmds

	@
