var config = {
	'baseUrl' : 'http://localhost:9515'
};
jQuery.apiPost = function (url, data, callback, type) {
	if ( jQuery.isFunction( data ) ) {
		type = type || callback;
		callback = data;
		data = undefined;
	}
	return jQuery.ajax({
		'type': 'POST',
		'url': config.baseUrl + url,
		'processData' : false,
		'data': data,
		'success': callback,
		'dataType': type || 'json'
	});
};
document.addEventListener('drop', function (env) {
	var dataTransfer = env.dataTransfer;
	if (!dataTransfer.files.length) {
		return;
	}
	env.preventDefault();
	async.parallel({
		'sessionId' : function (callback) {
			$.apiPost('/session', '{"desiredCapabilities" : {}}').done(function (data) {
				callback(null, data.sessionId);
			});
		},
		'docs' : function (callback) {
			async.parallel([].slice.apply(dataTransfer.files).map(make_FileReader), callback);
		}
	}, result_FileReader);
});
function make_FileReader (file) {
	return function (callback) {
		var reader = new FileReader();
		reader.addEventListener('loadend', function () {
			var doc = document.implementation.createHTMLDocument('');
			var range=doc.createRange();
			range.selectNodeContents(doc.documentElement);
			range.deleteContents();
			doc.documentElement.appendChild(range.createContextualFragment(this.result));
			callback(null, doc);
		});
		reader.readAsText(file);
	};
}
function result_FileReader (err, res) {
	var sessionId = res.sessionId;
	async.parallel(res.docs.map(function (doc) {
		return function (callback) {
			var href = doc.querySelector('link[rel="selenium.base"]').href;
			async.series([function (callback) {
				$.apiPost('/session/'+sessionId+'/url', '{"url" : "'+href+'"}').done(function (data) {
					callback(null, data);
				});
			}], function () {
				$.ajax({
					'type' : 'DELETE',
					'url' : config.baseUrl + '/session/'+sessionId+'/window'
				}).done(function (data) {
					console.log('done');
				});
			});
		};
	}));
}
