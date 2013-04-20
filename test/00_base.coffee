"use strict"

do =>
	@expect = chai.expect
	mocha.globals(['setTimeout', 'setInterval', 'clearTimeout', 'clearInterval', 'XMLHttpRequest'])
	Deferred.next = Deferred.next_default;

	@mocha.sinon = {}
	@mocha.sinon.testBefore = (callback) ->
		->
			@sandbox = sinon.sandbox.create()
			@sandbox.useFakeServer()
			@sandbox.useFakeTimers()
			callback.apply(@, arguments)

	@mocha.sinon.testAfter = (callback) ->
		->
			@sandbox.verifyAndRestore()
			callback.apply(@, arguments)

	if 'undefined' isnt typeof console
		sinon.log = ->
#			console.log.apply console, arguments

	Deferred.onerror = (e) ->
		throw e
