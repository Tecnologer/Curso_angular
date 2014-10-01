<cfcomponent>

	<cffunction name="agregar" access="public" returntype="Struct">
		<cfargument name="nb_empresa" 	type="string" required="true"/>
		<cfargument name="de_direccion" type="string" required="true"/>
		<cfargument name="nu_telefono"  type="string" required="true"/>
		<cfargument name="nu_codigoPostal" type="string" required="true"/>
		
		<cfset Local.BR=structNew()>

		<cfif Arguments.nb_empresa EQ '' OR Arguments.nb_empresa EQ 'undefined'>
				<cfset Local.BR.hasError=true>
				<cfset Local.BR.msg='El nombre de la empresa es requerido'>
			<cfelse>
				<cfset Local.argumentos=structNew()>
				<cfset Local.argumentos.nb_empresa=Arguments.nb_empresa>

				<cfif Arguments.de_direccion NEQ '' OR Arguments.de_direccion EQ 'undefined'>
					<cfset Local.argumentos.de_direccion=Arguments.de_direccion>
				</cfif>

				<cfif Arguments.nu_telefono NEQ ''>
					<cfset Local.argumentos.nu_telefono=Arguments.nu_telefono>
				</cfif>

				<cfif Arguments.nu_codigoPostal NEQ ''>
					<cfset Local.argumentos.nu_codigoPostal=Arguments.nu_codigoPostal>
				</cfif>

				<cfinvoke component="Curso_angular.componentes.DAO.empresas"
						  method="nextId"
						  returnvariable="Local.id_empresa"/>

				<cfset Local.argumentos.id_empresa=Local.id_empresa>
				
				<cfinvoke component="Curso_angular.componentes.DAO.empresas"
						  method="agregar"
						  argumentcollection="#Local.argumentos#"/>

				<cfset Local.BR.hasError=false>				
		</cfif>


		<cfreturn Local.BR>
	</cffunction>

	<cffunction name="listar" access="remote" returntype="Struct">
		<cfargument name="id_empresa" type="string" required="true"/>
		<cfargument name="nb_empresa" type="string" required="true"/>

		<cfset Local.BR=structNew()>

		<cfset Local.params=structNew()>

		<cfif Arguments.id_empresa NEQ ''>
			<cfset Local.params.id_empresa=Arguments.id_empresa>
		</cfif>
		
		<cfif Arguments.nb_empresa NEQ ''>
			<cfset Local.params.nb_empresa=Arguments.nb_empresa>
		</cfif>

		<cfinvoke component="Curso_angular.componentes.DAO.empresas"
				  method="listar"
				  argumentcollection="#Local.params#"
				  returnvariable="Local.rs">

		

		<cfset Local.BR.hasError=false>
		<cfset Local.BR.Query=Local.rs>
		
		<cfreturn Local.BR />
	</cffunction>

	<cffunction name="editar" access="public" returntype="Struct">
		<cfargument name="id_empresa" type="string" required="true"/>
		<cfargument name="nb_empresa" 	type="string" required="true"/>
		<cfargument name="de_direccion" type="string" required="true"/>
		<cfargument name="nu_telefono"  type="string" required="true"/>
		<cfargument name="nu_codigoPostal" type="string" required="true"/>

		<cfset Local.BR=structNew()>

		<!--- Validamos las reglas de negocio --->
		<!--- Regla 1.- NO debe de existir empresas con su nombre vacio --->
		<cfif Arguments.nb_empresa EQ ''>
				<!--- Si es vacio, decimos que hay un error --->
				<cfset Local.BR.hasError=true>
				<!--- y asigamos el mensaje de error --->
				<cfset Local.BR.msg='El nombre de la empresa es requerido'>
			<!--- SI NO es vacio, continuamos con las siguientes validaciones --->
			<cfelse>

				<!--- Creamos una estructura de parametros, dicha estructura contendra los argumentos que
					 recibira la funcion del DAO --->
				<cfset Local.params=structNew()>

				<!--- Estos son los campos que son requeridos y es necesario enviarlos a la funcion del DAO --->
				<!--- El id_empresa (que viene desde angular) nos ayudara a identificar en la DB a que empresa 
					  haremos las modificaciones siguientes --->
				<cfset Local.params.id_empresa=Arguments.id_empresa>
				<cfset Local.params.nb_empresa=Arguments.nb_empresa>

				<!--- Regla 2.- Los campos de direccion, numero de telefono y codigo postal,
					  pueden tener valores nulos (NULL) --->
				<!--- Aqui se hace la evaluacion de los campos que NO son requeridos, y se enviaran
				 	solamente cuando NO esten vacios --->
				<cfif Arguments.de_direccion NEQ ''>
					<cfset Local.params.de_direccion=Arguments.de_direccion>
				</cfif>
				<cfif Arguments.nu_telefono NEQ ''>
					<cfset Local.params.nu_telefono=Arguments.nu_telefono>
				</cfif>
				<cfif Arguments.nu_codigoPostal NEQ ''>
					<cfset Local.params.nu_codigoPostal=Arguments.nu_codigoPostal>
				</cfif>

				<!--- Una vez que se ha generado la estructura de argumentos, se ejecuta la funcion del DAO --->
				<!--- Como es una funcion de editar, el DAO no responde nada, por lo que "returnVariable"  se puede omitir--->
				<cfinvoke component="Curso_angular.componentes.DAO.empresas"
				          method="editar"
				          argumentcollection="#Local.params#">

				<!--- Indicamos a hasError que no hay error --->
				<cfset Local.BR.hasError=false>

		</cfif>
		
		<cfreturn Local.BR />
	</cffunction>

	<cffunction name="eliminar" access="public" returntype="Struct">
		<cfargument name="id_empresa" type="string" required="true"/>

		<cfset Local.BR=structNew()>

		<cfif Arguments.id_empresa EQ ''>
			<cfset Arguments.id_empresa='0'>
		</cfif>

		<cfinvoke component="Curso_angular.componentes.DAO.empresas"
		          method="eliminar"
		          id_empresa="#Arguments.id_empresa#"/>
		
		<cfset Local.BR.hasError=false>

		<cfreturn Local.BR />
	</cffunction>
</cfcomponent>