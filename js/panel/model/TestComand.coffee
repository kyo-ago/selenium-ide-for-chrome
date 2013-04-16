"use strict"

@TestCommand = Backbone.Model.extend({
	'defaults' : {
		# command name(ex. 'click', 'text')
		'name' : ''
		# command value(for 'text')
		'value' : ''
		# css selector
		'selector' : ''
		# selected item(for ui)
		'selected' : false
	}
})