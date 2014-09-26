<cfcomponent>

	<cffunction name="nextID" access="public" returntype="Numeric">

		<cfquery name="Local.empresa" datasource="cnx_petroil">
			EXEC upR_empresasNextID
		</cfquery>
		
		<cfreturn Local.empresa.nextID>
	</cffunction>

	<cffunction name="agregar" access="public" returntype="void">
		<cfargument name="id_empresa" type="string" required="true"/>
		<cfargument name="nb_empresa" 	type="string" required="true"/>
		<cfargument name="ar_imagenReporte" type="string" required="false"/>
		<cfargument name="ar_imagenLogo" type="string" required="false"/>
		<cfargument name="nb_razonSocial" type="string" required="false"/>
		<cfargument name="de_direccion" type="string" required="false"/>
		<cfargument name="nu_telefono"  type="string" required="false"/>
		<cfargument name="nu_codigoPostal" type="string" required="false"/>
		
		<cfquery datasource="cnx_petroil">
			EXEC upC_empresas  #Arguments.id_empresa#,
							  '#Arguments.nb_empresa#',
			<cfif isDefined("Arguments.ar_imagenReporte")>'#Arguments.ar_imagenReporte#'<cfelse>NULL</cfif>,
			<cfif isDefined("Arguments.ar_imagenLogo")>'#Arguments.ar_imagenLogo#'<cfelse>NULL</cfif>,
			<cfif isDefined("Arguments.nb_razonSocial")>'#Arguments.nb_razonSocial#'<cfelse>NULL</cfif>,
			<cfif isDefined("Arguments.de_direccion")>'#Arguments.de_direccion#'<cfelse>NULL</cfif>,
			<cfif isDefined("Arguments.nu_telefono")>'#Arguments.nu_telefono#'<cfelse>NULL</cfif>,
			<cfif isDefined("Arguments.nu_codigoPostal")>'#Arguments.nu_codigoPostal#'<cfelse>NULL</cfif>
		</cfquery>
	</cffunction>

	<cffunction name="listar" access="public" returntype="query">

		<cfquery name="Local.rs" datasource="cnx_petroil">
			EXEC upL_Empresas
		</cfquery>

		<cfreturn Local.rs>
	</cffunction>

	<cffunction name="editar" access="public" returntype="void">
		<cfargument name="id_empresa" type="string" required="true"/>
		<cfargument name="nb_empresa" 	type="string" required="true"/>
		<cfargument name="ar_imagenReporte" type="string" required="false"/>
		<cfargument name="ar_imagenLogo" type="string" required="false"/>
		<cfargument name="nb_razonSocial" type="string" required="false"/>
		<cfargument name="de_direccion" type="string" required="false"/>
		<cfargument name="nu_telefono"  type="string" required="false"/>
		<cfargument name="nu_codigoPostal" type="string" required="false"/>

		<cfquery datasource="cnx_petroil">
			EXEC upU_empresas  #Arguments.id_empresa#,
							  '#Arguments.nb_empresa#',
			<cfif isDefined("Arguments.ar_imagenReporte")>'#Arguments.ar_imagenReporte#'<cfelse>NULL</cfif>,
			<cfif isDefined("Arguments.ar_imagenLogo")>'#Arguments.ar_imagenLogo#'<cfelse>NULL</cfif>,
			<cfif isDefined("Arguments.nb_razonSocial")>'#Arguments.nb_razonSocial#'<cfelse>NULL</cfif>,
			<cfif isDefined("Arguments.de_direccion")>'#Arguments.de_direccion#'<cfelse>NULL</cfif>,
			<cfif isDefined("Arguments.nu_telefono")>'#Arguments.nu_telefono#'<cfelse>NULL</cfif>,
			<cfif isDefined("Arguments.nu_codigoPostal")>'#Arguments.nu_codigoPostal#'<cfelse>NULL</cfif>
		</cfquery>

	</cffunction>

	<cffunction name="eliminar" access="public" returntype="void">
		<cfargument name="id_empresa" type="string" required="true"/>

		<cfquery datasource="cnx_petroil">
			EXEC upD_empresas #Arguments.id_empresa#
		</cfquery>		
	</cffunction>
</cfcomponent>