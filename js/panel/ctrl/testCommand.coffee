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
	$scope.selectedCommand = undefined

	$scope.add = (command) ->
		$scope.testCase.push command
		$scope.$apply()
		wrap = document.querySelector('[ng-controller="testCommandCtrl"] .commandsWrap')
		wrap.scrollTop = wrap.scrollHeight

	$scope.selectLine = (command) ->
		selected = command.get 'selected'
		for sel in $scope.testCase.where({'selected' : true})
			sel.set 'selected', false
		command.set 'selected', !selected
		$scope.selectedCommand = command

	$scope.getTestCase = ->
		cmds = for cmd in $scope.testCase.toArray() then cmd.attributes
		cmds

	$scope.$on 'click', (arg, event) ->
		table = document.querySelector('[ng-controller="testCommandCtrl"] .commands')
		return undefined if table is (elem = event.srcElement)
		active = document.activeElement.tagName?.toLocaleLowerCase()
		return undefined if active is 'input' or active is 'textarea' or active is 'select' or active is 'button'
		while elem = elem.parentNode
			return undefined if table is elem

		for sel in $scope.testCase.where({'selected' : true})
			sel.set 'selected', false
		$scope.selectedCommand = undefined
		$scope.$apply()

	$scope.$on 'keyup', (arg, event) ->
		return if event.keyCode isnt 46
		last = undefined
		for sel, idx in $scope.testCase.where({'selected' : true})
			last = $scope.testCase.at($scope.testCase.indexOf(sel) + 1) or last
			$scope.testCase.remove sel

		if last
			last.set 'selected', true
			$scope.selectedCommand = last

		$scope.$apply()

	@
