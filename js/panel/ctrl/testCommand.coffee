"use strict"

@testCommandCtrl = ($scope) ->
	$scope.testCase = new TestCase()
	$scope.testCase.add([
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselectorselector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
		{
		'name' : 'text'
		'value' : 'value'
		'selector' : 'selector'
		},
	])
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
	$scope.selectedCommand = undefined

	$scope.add = (command) ->
		$scope.testCase.push command
		$scope.$apply()
		wrap = document.querySelector('[ng-controller="testCommandCtrl"] .commandsWrap')
		wrap.scrollTop = wrap.scrollHeight

	$scope.selectLine = (command) ->
		for sel in $scope.testCase.where({'selected' : true})
			sel.set 'selected', false
		command.set 'selected', true
		$scope.selectedCommand = command

	$scope.getTestCase = ->
		cmds = for cmd in $scope.testCase.toArray() then cmd.attributes
		cmds

	$scope.$on 'click', ->
		for sel in $scope.testCase.where({'selected' : true})
			sel.set 'selected', false
		$scope.$apply()

	@
