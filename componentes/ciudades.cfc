<cfcomponent>
	
	<cffunction name="agregar" access="remote" returnformat="JSON">
		<cfargument name="nb_estado" type="string" required="true"/>
		<cfargument name="nb_ciudad" type="string" required="true"/>
		
		<cfset var Local=structNew()/>

		<cfset Local.result=structNew()/>
		
		<cftransaction>
			<cftry>
					<cfset Local.params=arrayNew(1)>
					<cfset arrayAppend(Local.params,"'#Arguments.nb_ciudad#'")>
					<cfset arrayAppend(Local.params,"'#Arguments.nb_estado#'")>
					<cfset  Local.params=arrayToList(Local.params)>
					
					<cfinvoke method="ejecutarQuery"
							  stored_procedure="up_Ciudades_Agregar"
							  params="#Local.params#"
							  returnvariable="Local.rs">

					<cfset Local.result.ISOK=true>
					<cfset Local.result.MSG="Operacion exitosa">


				<cfcatch type="any">
					<cftransaction action="rollback">
					<cfset Local.result.ISOK=false>
					<cfset Local.result.MSG=cfcatch.Message>
					<cfset Local.result.CFCATCH=cfcatch>
				</cfcatch>
			</cftry>
		</cftransaction>

		<cfreturn Local.result/>
	</cffunction>

	<cffunction name="buscar" access="remote" returnformat="JSON">
		
		<cftry>	
				<cfinvoke method="ejecutarQuery"
						  stored_procedure="up_Ciudades_Listar"
						  params=""
						  returnvariable="Local.rs">

				<cfset Local.result.ISOK=true>
				<cfset Local.result.MSG="Operacion exitosa">
				<cfset Local.result.QUERY=Local.rs>

				<cfcatch type="any">
					<cftransaction action="rollback">
					<cfset Local.result.ISOK=false>
					<cfset Local.result.MSG=cfcatch.Message>
					<cfset Local.result.CFCATCH=cfcatch>
				</cfcatch>
			</cftry>

			<cfreturn Local.result />	
	</cffunction>

	<cffunction name="editar" access="remote" returnformat="JSON">
		<cfargument name="id_ciudad" type="string" required="true"/>
		<cfargument name="nb_estado" type="string" required="true"/>
		<cfargument name="nb_ciudad" type="string" required="true"/>
		
		<cfset Local.result=structNew()>
		
		<cftransaction >
			<cftry>
					<cfset Local.params=arrayNew(1)>
					<cfset arrayAppend(Local.params,Arguments.id_ciudad)>
					<cfset arrayAppend(Local.params,"'#Arguments.nb_ciudad#'")>
					<cfset arrayAppend(Local.params,"'#Arguments.nb_estado#'")>
					<cfset  Local.params=arrayToList(Local.params)>
					
					<cfinvoke method="ejecutarQuery"
							  stored_procedure="up_Ciudades_Actualizar"
							  params="#Local.params#"
							  returnvariable="Local.rs">

					<cfset Local.result.ISOK=true>
					<cfset Local.result.MSG="Operacion exitosa">


				<cfcatch type="any">
					<cftransaction action="rollback">
					<cfset Local.result.ISOK=false>
					<cfset Local.result.MSG=cfcatch.Message>
					<cfset Local.result.CFCATCH=cfcatch>
				</cfcatch>
			</cftry>
		</cftransaction>

		<cfreturn Local.result/>
	</cffunction>

	<cffunction name="eliminar" access="remote" returnformat="JSON">
		<cfargument name="id_ciudad" type="string" required="true"/>
		
		<cfset Local.result=structNew()>
		
		<cftransaction >
			<cftry>
					<cfset Local.params=arrayNew(1)>
					<cfset arrayAppend(Local.params,Arguments.id_ciudad)>
					<cfset  Local.params=arrayToList(Local.params)>
					
					<cfinvoke method="ejecutarQuery"
							  stored_procedure="up_Ciudades_Eliminar"
							  params="#Local.params#"
							  returnvariable="Local.rs">

					<cfset Local.result.ISOK=true>
					<cfset Local.result.MSG="Operacion exitosa">


				<cfcatch type="any">
					<cftransaction action="rollback">
					<cfset Local.result.ISOK=false>
					<cfset Local.result.MSG=cfcatch.Message>
					<cfset Local.result.CFCATCH=cfcatch>
				</cfcatch>
			</cftry>
		</cftransaction>

		<cfreturn Local.result/>
	</cffunction>

	<cffunction name="ejecutarQuery" access="public" returntype="any">
		<cfargument name="params" type="string" required="true"/>
		<cfargument name="stored_procedure" type="string" required="true"/>

		<cfquery name="Local.rs" datasource="cnx_angular">
			EXEC #Arguments.stored_procedure# #preserveSingleQuotes(Arguments.params)#
		</cfquery>		

		<cfif NOT isDefined("Local.rs")>
			<cfset Local.rs=''>
		</cfif>

		<cfreturn Local.rs />
	</cffunction>
</cfcomponent>