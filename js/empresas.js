// crear el modulo de agular
var $app=angular.module('empresas', ['ui.bootstrap','ngGrid','ngServices.empresas']);

var idEmpresa='';
var sn_editar=false;

/********* Inicializar controladores ***********/
$app.controller('nuevo',["$scope","$interval","servEmpresas",'$modal','$log',
	function($scope,$interval,servEmpresas,$modal,$log){
		$scope.titulo="Agregar Empresa";
		// $scope.nb_empresa='';
		$scope.de_direccion1='';
		$scope.de_direccion2='';
		$scope.nu_telefono='';
		$scope.nu_cp='';

		//funciones constructoras
		initGuardar($scope,servEmpresas);
		initListar($scope,servEmpresas,$interval);

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
		
		
		instanciarModal($scope,$modal,$log,$interval);
			// Please note that $modalInstance represents a modal window (instance) dependency.
			// It is not the same as the $modal service used above.

		

	}
]);

function instanciarModal($scope,$modal,$log,$interval)
{
	$scope.items = {};

	  $scope.openModal = function (size,title) {
	    var modalInstance = $modal.open({
	      templateUrl: 'myModalContent.html',
	      controller: ModalInstanceCtrl,
	      size: size,
	      resolve: {
	        title: function(){
	        	return title;
	        }

	      }
	    });

	    modalInstance.result.then(function (selectedItem) {
	      $scope.selected = selectedItem;
	    }, function () {
	      $log.info('Modal dismissed at: ' + new Date());
	    });
	  };
}
var ModalInstanceCtrl = function ($scope, $modalInstance, title,$interval) 
{
  $scope.modalTitle=title;
 
  $scope.cerrarModal = function () {
    $modalInstance.close();
  };

  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };

	/*****************/
  	$scope.save=function(){
	  	var scopeGuardar=getScope("nuevo");
	  	scopeGuardar.nb_empresa=$scope.nb_empresa;
	  	scopeGuardar.de_direccion1=$scope.de_direccion1;
	  	scopeGuardar.de_direccion2=$scope.de_direccion2;
	  	scopeGuardar.nu_telefono=$scope.nu_telefono?$scope.nu_telefono:'';
	  	scopeGuardar.nu_cp=$scope.nu_cp?$scope.nu_cp:'';
		scopeGuardar.guardar();
		scopeGuardar.listar();	
	};

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
  
}

$app.controller('otroControlador', ['$scope', function($scope){
	
	$scope.getScope=function(){
		var scopePadre=getScope("nuevo");

		scopePadre.nb_empresa=$scope.nb_empresa;
	};
}]);
/********* Inicializar funciones de los scope ***********/

function initGuardar($scope,servEmpresas){
	

	$scope.guardar=function(){
		var modal=getScope("modal-body");
		if(!$scope.nb_empresa || $scope.nb_empresa=='')
		{
			modal.addAlert("El nombre de empresa es requerido","danger");
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

						modal.nb_empresa='';
						modal.de_direccion1='';
						modal.de_direccion2='';
						modal.nu_telefono='';
						modal.nu_cp='';
						$scope.listar();
						modal.cancel();
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
						modal.cancel();
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

function initListar($scope,servEmpresas,$interval){
	$scope.mySelections = [];
	$scope.empresas=[];
	$scope.gridOptions ={ 
							data: 'empresas',
							columnDefs: [
								{field: 'NB_EMPRESA', displayName: 'Empresa', enableCellEdit: true},
								{field: 'DE_DIRECCION', displayName: 'Direccion', enableCellEdit: true},
								{field: 'NU_TELEFONO', displayName: 'Telefono', enableCellEdit: true},
								{displayName: 'Acciones',cellTemplate:'<img src="img/edit.png" style="width:25px;height:25px;cursor:pointer" ng-click="editar(row)"><img src="img/delete.png" style="width:25px;height:25px;cursor:pointer" ng-click="eliminar(row)">',width: "100px", cellClass: 'acciones'}
								],
							enablePinning: false,
      						multiSelect: false
						};

	$scope.listar=function(){
		$scope.id_empresa=$scope.id_empresa?$scope.id_empresa:'';
		$scope.nb_empresaFiltro=$scope.nb_empresaFiltro?$scope.nb_empresaFiltro:'';
		
		servEmpresas.listar($scope.id_empresa,$scope.nb_empresaFiltro).success(function(data){
			if(data.ISOK)
				$scope.empresas=data.QUERY;
			else
				alert(data.MSG);
		});
	};

	$scope.editar=function(empresa){
		$scope.openModal("550","Editar Empresa");

		 var $inter=$interval(function(){
	   		$interval.cancel($inter);
	   		var modal=getScope("modal-body");		
			modal.nb_empresa=empresa.getProperty("NB_EMPRESA");
			modal.de_direccion1=empresa.getProperty("DE_DIRECCION");
			modal.nu_telefono=empresa.getProperty("NU_TELEFONO");
			modal.nu_cp=empresa.getProperty("NU_CODIGOPOSTAL");
			idEmpresa=empresa.getProperty("ID_EMPRESA");
			sn_editar=true;
			$('#nb_empresa').focus();
	   },200);
		
	};

	$scope.eliminar=function(empresa){
		if(confirm("Desea eliminar la empresa?"))
		{
			servEmpresas.eliminar(empresa.getProperty("ID_EMPRESA")).success(function(data){
				
				if(data.ISOK==true)
				{
					var type='success';
				}
				else
				{
					var type='danger';
				}
				// var type=data.ISOK?'success':'danger';
				if(data.SQL && data.SQL!='')
					data.MSG+=data.SQL+" detalle: "+data.DETAIL;
				
				$scope.addAlert(data.MSG,type);
				$scope.listar();
			});
		}
	};
}

function getScope(elemento){
	return angular.element($('#'+elemento)).scope();
}