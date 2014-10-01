<cfcomponent>
	
	<cfset Variables.ctrl=createObject("component","Curso_angular.componentes.rrt.RedResult").init("")>

	<cffunction name="agregar" access="remote" returnformat="JSON">
		<cfargument name="nb_empresa" 	type="string" required="true"/>
		<cfargument name="de_direccion" type="string" required="true"/>
		<cfargument name="nu_telefono"  type="string" required="true"/>
		<cfargument name="nu_codigoPostal" type="string" required="true"/>

		<cftransaction>
			<cftry>

				<cfinvoke component="Curso_angular.componentes.BRO.empresas"
						  method="agregar"
						  argumentcollection="#arguments#"
						  returnvariable="Local.BRO"/>				

				<cfif Local.BRO.hasError>
						<cfset Variables.ctrl.setError(Local.BRO.msg)>
						<cftransaction action="rollback">
					<cfelse>
						<cfset Variables.ctrl.setMessage("Operacion exitosa")>
				</cfif>

				<cfcatch type="any">
					<cfset Variables.ctrl.setCatch(cfcatch)>
					<cftransaction action="rollback"/>
				</cfcatch>
			</cftry>			
		</cftransaction>

		<cfreturn Variables.ctrl.toStruct()/>
	</cffunction>

	<cffunction name="listar" access="remote" returnformat="JSON">
		<cfargument name="id_empresa" type="string" required="true"/>
		<cfargument name="nb_empresa" type="string" required="true"/>

		<cftransaction>
			<cftry>

				<cfinvoke component="Curso_angular.componentes.BRO.empresas"
						  method="listar"
						  argumentcollection="#arguments#"
						  returnvariable="Local.BRO"/>				

				<cfif Local.BRO.hasError>
						<cfset Variables.ctrl.setError(Local.BRO.msg)>
						<cftransaction action="rollback">
					<cfelse>
						<cfset Variables.ctrl.setMessage("Operacion exitosa")>
						<cfset Variables.ctrl.setQuery(Local.BRO.query)>
				</cfif>

				<cfcatch type="any">
					<cfset Variables.ctrl.setCatch(cfcatch)>
					<cftransaction action="rollback"/>
				</cfcatch>
			</cftry>			
		</cftransaction>

		<cfreturn Variables.ctrl.toStruct()/>
	</cffunction>

	<cffunction name="editar" access="remote" returnformat="JSON">
		<cfargument name="id_empresa" type="string" required="true"/>
		<cfargument name="nb_empresa" 	type="string" required="true"/>
		<cfargument name="de_direccion" type="string" required="true"/>
		<cfargument name="nu_telefono"  type="string" required="true"/>
		<cfargument name="nu_codigoPostal" type="string" required="true"/>

		<cftransaction>
			<cftry>
					
					<cfinvoke component="Curso_angular.componentes.bro.empresas"
							  method="editar"
							  argumentcollection="#Arguments#"
							  returnvariable="Local.BRO"/>

					<cfif Local.BRO.hasError>
							<cfset Variables.ctrl.setError(Local.BRO.msg)>
							<cftransaction action="rollback"/>
						<cfelse>
							<cfset Variables.ctrl.setMessage("Operacion exitosa")>
					</cfif>
				<cfcatch type="any">
					<cfset variables.ctrl.setCatch(cfcatch)>
					<cftransaction action="rollback"/>
				</cfcatch>
			</cftry>
		</cftransaction>
		
		<cfreturn Variables.ctrl.toStruct()>
	</cffunction>

	<cffunction name="eliminar" access="remote" returnformat="JSON">
		<cfargument name="id_empresa" type="string" required="true"/>

		<cftransaction>
			<cftry>
				
				<cfinvoke component="Curso_angular.componentes.BRO.empresas"
				          method="eliminar"
				          argumentcollection="#Arguments#"
				          returnvariable="Local.BRO">

				<cfif Local.BRO.hasError>
					<cfset Variables.ctrl.setError(Local.BRO.msg)>
					<cftransaction action="rollback">
					<cfelse>
						<cfset Variables.ctrl.setMessage("Empresa eliminada correctamente")>
				</cfif>
				<cfcatch type="any">
					<cfset Variables.ctrl.setCatch(cfcatch)>
					<cftransaction action="rollback">
				</cfcatch>
			</cftry>			
		</cftransaction>

		<cfreturn Variables.ctrl.toStruct()/>
		
	</cffunction>
</cfcomponent>