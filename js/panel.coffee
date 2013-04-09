do ->
	mod = angular.module 'ng'
	mod.controller 'menuPanelCtrl', ['$scope', menuPanelCtrl]
	mod.controller 'testCaseCtrl', ['$scope', testCaseCtrl]
	mod.controller 'testCommandCtrl', ['$scope', testCommandCtrl]
	mod.controller 'messagesCtrl', ['$scope', messagesCtrl]
