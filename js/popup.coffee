"use strict"

do =>
	create_window = ->
		chrome.windows.create {
			'url' : '/html/panel.html'
			'type' : 'panel'
			'focused' : false
			'top' : 0
			'left' : 0
			'height' : 500
			'width' : 300
		}, (win) =>
			localStorage.window_id = win.id
	if localStorage.window_id
		chrome.windows.get localStorage.window_id|0, (win) ->
			if win
				chrome.windows.update win.id, {
					'focused' : true
				}
			else
				create_window()
	else
		create_window()