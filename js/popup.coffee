"use strict"

chrome.windows.create {
	'url' : '/html/panel.html'
	'type' : 'panel'
	'focused' : false
	'top' : 0
	'left' : 0
	'height' : 500
	'width' : 300
}
