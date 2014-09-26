// crear el modulo de agular
var $app=angular.module('empresas', ['ui.bootstrap','ngGrid']);

var idEmpresa='';
var sn_editar=false;

/********* Inicializar controladores ***********/
$app.controller('nuevo',["$scope","$interval","servEmpresas",
	function($scope,$interval,servEmpresas){
		$scope.titulo="Agregar Empresa";
		// $scope.nb_empresa='';
		$scope.de_direccion1='';
		$scope.de_direccion2='';
		$scope.nu_telefono='';
		$scope.nu_cp='';

		//funciones constructoras
		initGuardar($scope,servEmpresas);
		initListar($scope,servEmpresas);

		$scope.listar();

		$scope.alerts=[];

		$scope.addAlert = function(msg,type) {
			$scope.closeAlert(0);
		    $scope.alerts.push({"msg": msg, "type": type});

		   var $inter=$interval(function(){
		   		$interval.cancel($inter);
		   		$scope.closeAlert(0);
		   },3000);

		};

		$scope.closeAlert = function(index) {
		    $scope.alerts.splice(index, 1);
		};

		$('#nb_empresa').focus();
		
		

	}
]);

$app.controller('controlador', ['$scope', function($scope){
	
	$scope.set=function (msg){
		$scope.campo=msg;
	};
}]);
/********* Inicializar funciones de los scope ***********/

function initGuardar($scope,servEmpresas){
	
	$scope.guardar=function(){
		if(!$scope.nb_empresa || $scope.nb_empresa=='')
		{
			$scope.addAlert("El nombre de empresa es requerido","danger");
			$('#nb_empresa').focus();
		}
		else
		{	
			if((!$scope.de_direccion1 || $scope.de_direccion1=='') && (!$scope.de_direccion2 || $scope.de_direccion2==''))
				var $dir='';
			else if(!$scope.de_direccion1 || $scope.de_direccion1=='')
				var $dir=$scope.de_direccion2;
			else if(!$scope.de_direccion2 || $scope.de_direccion2=='')
				var $dir=$scope.de_direccion1;
			else
				var $dir=$scope.de_direccion1+', '+$scope.de_direccion2;

			if(!sn_editar)
			{
				servEmpresas.agregar(
						$scope.nb_empresa,
						$dir,
						$scope.nu_telefono,
						$scope.nu_cp
					).success(function(data){
						
						var type='success';
						if(!data.ISOK)
							type='danger';

						$scope.addAlert(data.MSG,type);

						$scope.nb_empresa='';
						$scope.de_direccion1='';
						$scope.de_direccion2='';
						$scope.nu_telefono='';
						$scope.nu_cp='';
						$scope.listar();
						$('#nb_empresa').focus();
				});
			}
			else
			{
				servEmpresas.editar(
						idEmpresa,
						$scope.nb_empresa,
						$dir,
						$scope.nu_telefono,
						$scope.nu_cp
					).success(function(data){
					
					var type='success';
					if(data.ISOK)
					{
						$scope.nb_empresa='';
						$scope.de_direccion1='';
						$scope.de_direccion2='';
						$scope.nu_telefono='';
						$scope.nu_cp='';
						$scope.listar();
						$('#nb_empresa').focus();
					}
					else
						type='danger';

					$scope.addAlert(data.MSG,type);
					
				});
			}
		}
	};

	$scope.guardarEdicion=function(){

		$scope.sn_editar=false;
	};
}

function initListar($scope,servEmpresas){
	$scope.mySelections = [];
	$scope.empresas=[];
	$scope.gridOptions ={ 
							data: 'empresas',
							columnDefs: [
								{field: 'NB_EMPRESA', displayName: 'Empresa', enableCellEdit: true},
								{field: 'DE_DIRECCION', displayName: 'Direccion', enableCellEdit: true},
								{field: 'NU_TELEFONO', displayName: 'Telefono', enableCellEdit: true},
								{displayName: 'Acciones',cellTemplate:'<img src="img/edit.png" style="width:25px;height:25px;cursor:pointer" ng-click="editar(mySelections)"><img src="img/delete.png" style="width:25px;height:25px;cursor:pointer" ng-click="eliminar(empresa)">'}
								],
							enablePinning: false,
							selectedItems: $scope.mySelections,
      						multiSelect: false
						};

	$scope.listar=function(){
		servEmpresas.listar().success(function(data){
			if(data.ISOK)
				$scope.empresas=data.QUERY;
			else
				alert(data.MSG);
		});
	};

	$scope.editar=function(empresa){
		$scope.nb_empresa=empresa.NB_EMPRESA;
		$scope.de_direccion1=empresa.DE_DIRECCION;
		$scope.nu_telefono=empresa.NU_TELEFONO;
		$scope.nu_cp=empresa.NU_CODIGOPOSTAL;
		idEmpresa=empresa.ID_EMPRESA;
		sn_editar=true;
	};

	$scope.eliminar=function(empresa){
		if(confirm("Desea eliminar la empresa?"))
		{
			servEmpresas.eliminar(empresa.ID_EMPRESA).success(function(data){
				
				if(data.ISOK==true)
				{
					var type='success';
				}
				else
				{
					var type='danger';
				}
				// var type=data.ISOK?'success':'danger';
				if(data.SQL!='')
					data.MSG+=data.SQL+" detalle: "+data.DETAIL;
				
				$scope.addAlert(data.MSG,type);
				$scope.listar();
			});
		}
	};
}

/*************     SERVICIOS     *************/
$app.service('servEmpresas', ['$http', function($http){

	var listar=function(){

		return $http(
				{
					url: "componentes/cfproxy.cfc?method=proxy",
					method: 'POST',
					data:{
						component: 'empresas',
						execMethod: 'listar',
						argumentcollection: {}
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

	return {
		listar: function(){return listar();},
		agregar: function(nb_empresa,de_direccion,nu_telefono,nu_codigoPostal){return agregar(nb_empresa,de_direccion,nu_telefono,nu_codigoPostal);},
		editar: function(id_empresa,nb_empresa,de_direccion,nu_telefono,nu_codigoPostal){return editar(id_empresa,nb_empresa,de_direccion,nu_telefono,nu_codigoPostal);},
		eliminar: function(id_empresa){return eliminar(id_empresa);},
	};
	
}])