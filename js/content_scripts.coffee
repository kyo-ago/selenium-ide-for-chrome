"use strict"

getSelector = (elem, selector = '')->
	return 'body ' + selector if elem.tagName.toLowerCase() is 'body'
	parent = elem.parentElement
	return selector if !parent
	for child, i in parent.children
		continue if child isnt elem
		selector = ">*:nth-child(#{i+1})#{selector}"
		break
	getSelector parent, selector

sendMessage = (param) ->
	message = {}
	for key, val of param
		message[key] = val
	message['command'] = 'event'
	message['orign'] = location.origin
	chrome.extension.sendMessage message

checkEvent = {
	'click' : (elem) ->
		tag = elem.tagName.toLocaleLowerCase()
		return true if tag is 'a'
		return true if tag is 'button'
		return false if tag isnt 'input'
		return false if elem.type is 'text'
		return false if elem.type is 'password'
		true
	'change' : (elem) ->
		tag = elem.tagName.toLocaleLowerCase()
		return true if tag is 'textarea'
		return true if tag is 'select'
		return false if tag isnt 'input'
		return true if elem.type is 'text'
		return true if elem.type is 'password'
		false
}

window.addEventListener 'click', (evn) ->
	elem = evn.srcElement
	return if not checkEvent['click'](elem)
	sendMessage {
		'name' : 'click'
		'selector' : getSelector elem
	}

window.addEventListener 'change', (evn) ->
	elem = evn.srcElement
	return if not checkEvent['change'](elem)
	sendMessage {
		'name' : 'text'
		'value' : elem.value
		'selector' : getSelector elem
	}
