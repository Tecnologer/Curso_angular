var _services=angular.module('ngServices.empresas',[]);

_services.factory('servEmpresas', ['$http', function($http){

	var listar=function(id_empresa, nb_empresa){

		return $http(
				{
					url: "componentes/cfproxy.cfc?method=proxy",
					method: 'POST',
					data:{
						component: 'empresas',
						execMethod: 'listar',
						argumentcollection: {
							id_empresa: id_empresa,
							nb_empresa: nb_empresa
						}
					}
				}
			);
	};

	var agregar=function(nb_empresa, de_direccion, nu_telefono, nu_codigoPostal){

		var params={
			nb_empresa: nb_empresa,
			de_direccion: de_direccion,
			nu_telefono: nu_telefono,
			nu_codigoPostal: nu_codigoPostal
		};

		return $http(
				{
					url: "componentes/cfproxy.cfc?method=proxy",
					method: 'POST',
					data:{
						component: 'empresas',
						execMethod: "agregar",
						argumentcollection: params
					}
				}
			);
	};

	var editar=function(id_empresa, nb_empresa, de_direccion, nu_telefono, nu_codigoPostal){

		var params={
			id_empresa: id_empresa,
			nb_empresa: nb_empresa,
			de_direccion: de_direccion,
			nu_telefono: nu_telefono,
			nu_codigoPostal: nu_codigoPostal
		};

		return $http(
				{
					url: "componentes/cfproxy.cfc?method=proxy",
					method: 'POST',
					data:{
						component: 'empresas',
						execMethod: "editar",
						argumentcollection: params
					}
				}
			);
	};

	var eliminar=function(id_empresa){

		var params={
			id_empresa: id_empresa
		};

		return $http(
				{
					url: "componentes/cfproxy.cfc?method=proxy",
					method: 'POST',
					data:{
						component: 'empresas',
						execMethod: "eliminar",
						argumentcollection: params
					}
				}
			);
	};
	/** Autor: Rey David Dominguez
		Fecha: 30/09/2014
		Obtiene la informacion de empresa (id_empresa, nb_empresa) para llenar un combo
	*/
	var getCombo=function(){

	};

	return {
		listar: listar,
		agregar: agregar,//function(nb_empresa,de_direccion,nu_telefono,nu_codigoPostal){return agregar(nb_empresa,de_direccion,nu_telefono,nu_codigoPostal);},
		editar: editar,//function(id_empresa,nb_empresa,de_direccion,nu_telefono,nu_codigoPostal){return editar(id_empresa,nb_empresa,de_direccion,nu_telefono,nu_codigoPostal);},
		eliminar: eliminar//function(id_empresa){return eliminar(id_empresa);},
	};
}]);