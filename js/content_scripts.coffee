do =>
	"use strict"

	getSelector = (elem, selector)->
		parent = elem.parentElement
		return selector if !parent
		for child, i in parent.children
			continue if child isnt elem
			selector = "*:nth-child(#{i+1}) #{selector}"
			break
		getSelector parent, selector

	for name in ['click', 'blur']
		@addEventListener name, (evn) ->
			selector = getSelector evn.srcElement
			chrome.extension.sendMessage {
				'command' : 'event'
				'name' : evn.type
				'selector' : selector
			}
