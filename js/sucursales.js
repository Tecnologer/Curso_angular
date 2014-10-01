var appAn=angular.module('sucursales', ['ui.bootstrap','ngServices.empresas']);

appAn.controller('body', ['$scope','servEmpresas',function($scope,servEmpresas){
	
	servEmpresas.listar().success(function(data){
		$scope.empresas=data.QUERY;
	});

}]);