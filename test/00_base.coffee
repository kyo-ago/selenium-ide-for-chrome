do =>
	@expect = chai.expect

	synch_test = (callback) ->
		->
			sandbox = @sandbox = sinon.sandbox.create()
			try
				result = callback.call(@)
				sandbox.verifyAndRestore()
				return result
			catch e
				sandbox.restore()
				throw e
				return undefined

	asynch_test = (callback) ->
		(done) ->
			origOnError = window.onerror
			sandbox = @sandbox = sinon.sandbox.create()
			window.onerror = ->
				sandbox.restore()
				origOnError.apply(@, arguments)
				window.onerror = origOnError

			try
				return callback.call @, (error) ->
					sandbox.verifyAndRestore()
					window.onerror = origOnError
					done(error)
			catch e
				sandbox.restore()
				window.onerror = origOnError
				throw e
				return undefined

	@mocha.sinon = {}
	@mocha.sinon.test = (callback) ->
		return if not callback.length
			synch_test(callback)
		else
			asynch_test(callback)


	if 'undefined' isnt typeof console
		sinon.log = ->
			console.log.apply console, arguments

	Deferred.onerror = (e) ->
		throw e
