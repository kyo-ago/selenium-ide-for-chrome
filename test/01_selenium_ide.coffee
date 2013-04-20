"use strict"

describe 'SeleniumIDE', ->
	beforeEach mocha.sinon.testBefore ->
		@sel = new SeleniumIDE
		@sel.init({
			'server' : ''
		})
		spies = @spies = {}

		reg = (url) ->
			RegExp "^#{url}$"
		respond = (result) ->
			(xhr, url) ->
				spies[url] or= sinon.spy()
				spies[url].apply(@, arguments)
				xhr.respond 200, {}, result

		@sandbox.server.autoRespond = true
		@sandbox.server.autoRespondAfter = 0
		@sandbox.server.respondWith(
			reg '/(session)'
			respond JSON.stringify {
				'sessionId' : 'sid'
			}
		)
		@sandbox.server.respondWith(
			reg '/(session)/sid'
			respond '{}'
		)
		@sandbox.server.respondWith(
			reg '/session/sid/(window|url)'
			respond '{}'
		)
		@sandbox.server.respondWith(
			reg '/session/sid/(element)'
			respond JSON.stringify {
				'value' : { 'ELEMENT' : 'eid' }
			}
		)
		@sandbox.server.respondWith(
			reg '/session/sid/element/eid/(click|value)'
			respond '{}'
		)
	afterEach mocha.sinon.testAfter ->

	it 'setURL', ->
		@sandbox.spy(@sel, 'setURL')
		@sel.send({
			'baseURL' : 'http://example.com'
			'tests' : []
		})
		@sandbox.clock.tick(100)

		expect(@sel.sessionId).to.be.eq('sid')
		expect(@spies['url'].callCount).to.be.eq 1
		expect(@spies['url'].args[0][0].requestBody).to.be.eq '{"url":"http://example.com"}'

	it 'send', ->
		@sel.send({
			'baseURL' : 'http://example.com'
			'tests' : [
				{
					'name' : 'click'
					'selector' : 'hoge'
				}
				{
					'name' : 'text'
					'selector' : 'hoge'
					'value' : 'value'
				}
			]
		})
		@sandbox.clock.tick(100)

		expect(@spies['click'].callCount).to.be.eq(1)
		expect(@spies['value'].callCount).to.be.eq(1)

	it 'quit', ->
		@sel.send({})
		@sandbox.clock.tick(100)
		@spies['session'].reset()
		@sel.quit()
		@sandbox.clock.tick(100)

		expect(@spies['session'].callCount).to.be.eq(1)
