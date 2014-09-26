<cfcomponent>
    <cffunction name="Proxy" access="remote" returnformat="JSON">
        
        <cfif toString(getHTTPRequestData().content) NEQ "">
            <cfset requestBody = toString( getHttpRequestData().content )>
            <cfset structAppend( ARGUMENTS, deserializeJson( requestBody ) )>
        </cfif>

        <!--- <cfdump var="#ARGUMENTS#"> --->

        <cfset Local.proxy=structNew()>
        <cfif NOT isDefined("arguments")>
                <cfset Local.proxy.ISOK=false>
                <cfset Local.proxy.MSG="Los argumentos 'component' y 'execMethod' son requeridos y no fueron enviados.">
                <cfreturn Local.proxy>
            <cfelseif NOT structKeyExists(Arguments,'component')>
                <cfset Local.proxy.ISOK=false>
                <cfset Local.proxy.MSG="El argumento 'component' es requerido y no fue enviado.">
                <cfreturn Local.proxy>
            <cfelseif NOT structKeyExists(Arguments, "execMethod") >
                <cfset Local.proxy.ISOK=false>
                <cfset Local.proxy.MSG="El argumento 'execMethod' es requerido y no fue enviado.">
                <cfreturn Local.proxy>
        </cfif>
        <!--- Aqui ya se tiene algo en el scope arguments. --->
     

        <cfset componente=createObject("component","Curso_angular.componentes.#Arguments.component#")>

        <cfif structKeyExists(Arguments,'argumentcollection')>
                <cfinvoke component="#componente#"
                          method="#Arguments.execMethod#"
                          argumentcollection="#arguments.argumentcollection#"
                          returnvariable="Local.proxy">
            <cfelse>
                <cfinvoke component="#componente#"
                          method="#Arguments.execMethod#"
                          argumentcollection="#Arguments#"
                          returnvariable="Local.proxy">
        </cfif>

        <cfreturn Local.proxy />
    </cffunction>
</cfcomponent>