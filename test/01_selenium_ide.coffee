describe 'SeleniumIDE', ->
	beforeEach ->
		@sel = new SeleniumIDE

	it 'getSessionId', mocha.sinon.test ->
		@sel.init()
		@sel.getSessionId()
		expect(@sandbox.requests).to.equal(1)
		@sandbox.requests[0].respond