var $curso=angular.module('curso', ['ui.bootstrap']);

var $jsonCiudades=[];
var $title='Agregar Ciudad';

var $sn_edit=false;
var idCiudad;

$curso.controller('ciudades',function($scope, $http)
{
	$scope.ac_ciudad=$title;
	$scope.guardar=function(){
		
		//valida que estado no venga vacio
		if(!$scope.nb_estado || $scope.nb_estado=='')
			alert("Nombre de estado requerido");
		//validad ciudad no venga vacio
		else if (!$scope.nb_ciudad || $scope.nb_ciudad=='')
			alert("Nombre de la ciudad es requerido");
		//se verifica que no este en modo edicion
		//si no esta en modo edicion, se agregara la ciudad al array
		else if(!$sn_edit)
		{
			var $params="nb_estado="+$scope.nb_estado+"&nb_ciudad="+$scope.nb_ciudad;
			var $myAjax=$http({
								"method":"POST",
								"url":"componentes/ciudades.cfc?method=agregar&"+$params
							  });

				$myAjax.success(function(data){
					data=angular.fromJson(data);

					if(data.ISOK)
					{
						$scope.nb_estado='';
						$scope.nb_ciudad='';
						$scope.$$childTail.buscar();
					}

					alert(data.MSG);
				});


		}
		//si esta en modo edicion, se modificara la informacion
		else
		{
			var $params="id_ciudad="+idCiudad+"&nb_estado="+$scope.nb_estado+"&nb_ciudad="+$scope.nb_ciudad;
			var $myAjax=$http({
								"method":"POST",
								"url":"componentes/ciudades.cfc?method=editar&"+$params
							  });

				$myAjax.success(function(data){
					data=angular.fromJson(data);

					if(data.ISOK)
					{
						$scope.nb_estado='';
						$scope.nb_ciudad='';
						$scope.$$childTail.buscar();
						$sn_edit=false; 
						$scope.ac_ciudad="Agregar Ciudad";
					}

					alert(data.MSG);
				});
		}
	};
});

$curso.controller('cdListar',function($scope,$http)
{
	$scope.lbl="Mostrar";
	$scope.ciudades=$jsonCiudades;

	$scope.editar=function(ciudad){		
		$scope.$$childTail.$parent.$parent.ac_ciudad="Editar la ciudad de "+ciudad.NB_CIUDAD;
		$scope.$$childTail.$parent.$parent.nb_estado=ciudad.NB_ESTADO;
		$scope.$$childTail.$parent.$parent.nb_ciudad=ciudad.NB_CIUDAD;
		idCiudad=ciudad.ID_CIUDAD;
		$sn_edit=true;
	};

	$scope.eliminar=function(ciudad)
	{
		if(confirm("Desea eliminar la ciudad"))
		{
			var $params="id_ciudad="+ciudad.ID_CIUDAD;
			var $myAjax=$http({
								"method":"POST",
								"url":"componentes/ciudades.cfc?method=eliminar&"+$params
							  });

				$myAjax.success(function(data){
					data=angular.fromJson(data);

					if(data.ISOK)
					{
						$scope.nb_estado='';
						$scope.nb_ciudad='';
						$scope.$$childTail.buscar();
					}

					alert(data.MSG);
				});
		}
	};

	$scope.mostrar=function(){
		$scope.check=!$scope.check;
		$scope.lbl=$scope.lbl=='Mostrar'?'Ocultar':'Mostrar';
	};

	$scope.buscar=function(){
		var $myAjax=$http({
							"method":"POST",
							"url":"componentes/ciudades.cfc?method=buscar"
						  });

			$myAjax.success(function(data){
				data=angular.fromJson(data);

				if(data.ISOK)
					$scope.ciudades=queryToJson(data.QUERY);
				else
					alert(data.MSG);
			});
	};
});	

function queryToJson(query)
{
	var $json=[];
	for(var $i=0;$i<query.DATA.length;$i++)
	{
		var $object={};
		for(var $j=0;$j<query.COLUMNS.length;$j++)
		{
			$object[query.COLUMNS[$j]]=query.DATA[$i][$j];
		}

		$json.push($object);
	}

	return $json;

}
