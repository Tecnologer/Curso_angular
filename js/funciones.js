var $curso=angular.module('curso', ['ui.bootstrap']);

var $jsonCiudades=[];
var $title='Agregar Ciudad';

var $sn_edit=false;
var idCiudad;

$curso.controller('ciudades',function($scope)
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
			//se crea un objeto ciudad, con atributos de nombre de estado y nombre ciudad
			var $id_ciudad=$jsonCiudades.length;
			var $ciudad={
							"id_ciudad":$id_ciudad,
							"nb_estado":$scope.nb_estado,
							"nb_ciudad":$scope.nb_ciudad
						};
			//se agrega un objeto ciudad al arreglo de ciudades			
			$jsonCiudades.push($ciudad);

			//limpiamos los textbox de interfaz
			$scope.nb_estado='';
			$scope.nb_ciudad='';
		}
		//si esta en modo edicion, se modificara la informacion
		else
		{
			//obtenemos la ciudad a modificar
			var $ciudad=$jsonCiudades[idCiudad];
				//actualizamos los valores correspondientes a estado y/o ciudad
				$ciudad.nb_estado=$scope.nb_estado;
				$ciudad.nb_ciudad=$scope.nb_ciudad;

			//limpiamos los textbox de interfaz
			$scope.nb_estado='';
			$scope.nb_ciudad='';

			//cambiar titulo
			$scope.ac_ciudad="Agregar Ciudad";

			//cambiar la bandera de editar a false
			$sn_edit=false;
		}
		
		console.log($jsonCiudades);
	};
});

$curso.controller('cdListar',function($scope)
{
	$scope.lbl="Mostrar";
	$scope.ciudades=$jsonCiudades;

	$scope.editar=function(ciudad){		
		$scope.$$childTail.$parent.$parent.ac_ciudad="Editar la ciudad de "+ciudad.nb_ciudad;
		$scope.$$childTail.$parent.$parent.nb_estado=ciudad.nb_estado;
		$scope.$$childTail.$parent.$parent.nb_ciudad=ciudad.nb_ciudad;
		idCiudad=ciudad.id_ciudad;
		$sn_edit=true;
	};

	$scope.eliminar=function(ciudad)
	{
		if(confirm("Desea eliminar la ciudad"))
			$jsonCiudades.splice(ciudad.id_ciudad,1);
	};

	$scope.mostrar=function(){
		$scope.check=!$scope.check;
		$scope.lbl=$scope.lbl=='Mostrar'?'Ocultar':'Mostrar';
	};

});