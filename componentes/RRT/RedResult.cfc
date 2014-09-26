<cfcomponent>
	<cfset Variables.ctrl=structNew()>

	<cffunction name="init" access="public" returntype="any">
		<cfreturn this>
	</cffunction>

	<cffunction name="setError" access="public" returntype="void">
		<cfargument name="error" type="string" required="true"/>
		<cfset Variables.ctrl.MSG=Arguments.error>
		<cfset Variables.ctrl.ISOK=false>		
	</cffunction>

	<cffunction name="setCatch" access="public" returntype="void">
		<cfargument name="cfcatch" type="any" required="true"/>

		<cfset Variables.ctrl.ISCATCH=true>
		<cfset Variables.ctrl.ISOK=false>
		<cfset Variables.ctrl.MSG=Arguments.cfcatch.Message>
		<cfset Variables.ctrl.DETAIL=Arguments.cfcatch.Detail>
		<cfset Variables.ctrl.ARCHIVO=Arguments.cfcatch.TagContext[1].template>
		<cfset Variables.ctrl.LINE=Arguments.cfcatch.TagContext[1].Line>
		<cfset Variables.ctrl.SQL=''>
		<cfif structKeyExists(Arguments.cfcatch,'SQL')>
			<cfset Variables.ctrl.SQL=Arguments.cfcatch.sql>
		</cfif>
		
	</cffunction>

	<cffunction name="setMessage" access="public" returntype="void">
		<cfargument name="message" type="string" required="true"/>

		<cfset Variables.ctrl.ISOK=true>
		<cfset Variables.ctrl.MSG=message>		
	</cffunction>

	<cffunction name="setQuery" access="public" returntype="void">
		<cfargument name="query" type="query" required="true"/>
		
		<cfinvoke component="Curso_angular.componentes.funciones"
				  method="queryToJson"
				  query="#Arguments.query#"
				  returnvariable="Local.json">

		<cfset Variables.ctrl.QUERY=Local.json>
	</cffunction>

	<cffunction name="toStruct" access="public" returntype="Struct">		
		<cfreturn Variables.ctrl>
	</cffunction>
</cfcomponent>