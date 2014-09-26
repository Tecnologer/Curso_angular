<cfcomponent>

	<cfset Variables.RBR=structNew()>

	<cffunction name="init" access="public" returntype="any">
		<cfreturn this>
	</cffunction>

	<cffunction name="setError" access="public" returntype="void">
		<cfargument name="error" type="string" required="true">

		<cfset Variables.RBR.isOk=false>
		<cfset Variables.RBR.msg=Arguments.error>
	</cffunction>

	<cffunction name="setMessage" access="public" returntype="void">
		<cfargument name="message" type="string" required="true">

		<cfset Variables.RBR.isOk=true>
		<cfset Variables.RBR.msg=Arguments.message>

	</cffunction>

	<cffunction name="isOk" access="public" returntype="boolean">
		<cfreturn Variables.RBR.isOK>		
	</cffunction>

	<cffunction name="setQuery" access="public" returntype="void">
		<cfargument name="query" type="query" required="true"/>
		<cfset variables.query=arguments.query>
	</cffunction>

	<cffunction name="hasError" access="public" returntype="boolean">
		<cfreturn !Variables.isOk>
	</cffunction>
</cfcomponent>