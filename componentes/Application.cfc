<cfcomponent displayname="Application" output="true">
	<!---Configura la aplicación, estas variables no estarán disponibles en el scope application, a excepción de Name --->
	<cfset THIS.Name= "redrabbit.gva.dictamenes">
	<cfset THIS.ClientManagement= True>
	<cfset THIS.SessionManagement= True>
	<cfset THIS.SetClientCookies= True>
	<cfset THIS.ScriptProtect= "all">
	<cfset THIS.SessionTimeout= CreateTimeSpan( 0, 8, 0, 0 )>
	<cfset THIS.ApplicationTimeout= CreateTimeSpan( 1, 0, 0, 0 )>
	
	<!--- Se definen las configuraciones de request --->
	<cfsetting requesttimeout="30" showdebugoutput="false" enablecfoutputonly="false"/>
	
	<!---ApplicationStart --->
	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false" hint="Es lanzado cuando la aplicación es creada por primera vez">
	 	
		<!---Se inician algunas variables extras de aplicación--->
		<cflock scope="application" type="exclusive" timeout="5">
			<!---Se inician algunas variables de codigo duro de aplicacion --->
			<cfset Application.Initialized = TRUE >
			<cfset Application.LimSupInt = "2147483647"/>
			<cfset Application.LimInfInt = "-2147483648"/>
			<cfset Application.LimSupMon = "922337203685477.5807"/>
			<cfset Application.LimInfMon = "-922337203685477.5808"/>
			<cfset Application.LimSupDec = "9999999999.9999"/>
			<cfset Application.LimInfDec = "-9999999999.9999"/>
			
			<!---Se cargan las variables de inicializacion del ambiente --->
			<!---<cfset LOCAL.webIniPath = expandPath("config/web.ini.cfm")>
			<cfset LOCAL.environmentsPath = expandPath("config/ambientes.ini.cfm")>
			<cfset LOCAL.environmentIdentifier= createObject("component","environmentIdentifier").init(LOCAL.webIniPath)>
			<cfset LOCAL.environment= CreateObject("component","environment").init(LOCAL.environmentsPath)>
			<cfset LOCAL.environment.loadEnvironment(LOCAL.environmentIdentifier.getEnvironmentName())>
			<cfset Application.RENV= LOCAL.environment> --->
			
			<!---Se crea la redfactory --->
			<!--- <cfset Application.RF= CreateObject("component","#Application.RENV.getProperty('site-webPath')#.componentes.rrt.RedFactory").init("")>	 --->
			
		</cflock>
		<cfreturn true/>
	</cffunction>
	
	<!---SessionStart --->
	<cffunction name="OnSessionStart" access="public" returntype="void" output="false" hint="Es lanzado cuando la sesión es creada por primera vez">
		<cflock scope="session" type="exclusive" timeout="5">
			<cfparam name="Session.LoggedIn"    default="FALSE" />
		</cflock>
		<cfreturn />
	</cffunction>
	
	<!---RequestStart ---->
	<cffunction name="OnRequestStart" access="public" returntype="boolean" output="false" hint="Es lanzado en la primer parte del procesamiento de una pagina">
		<cfargument name="TargetPage" type="string" required="true"/>
		
		<!--- Si el usuario no se ha "loggeado" o no está en la pagina del login, se manda a la pagina de login. --->
		<!--- <cfif Session.LoggedIn NEQ "TRUE">
			<cfif
				(CGI.SCRIPT_NAME IS NOT "/#Application.RENV.getProperty('site-webPath')#/login.cfm")
				AND (CGI.SCRIPT_NAME IS NOT "/#Application.RENV.getProperty('site-webPath')#/validar.cfm")
				AND (CGI.SCRIPT_NAME IS NOT "/#Application.RENV.getProperty('site-webPath')#/salir.cfm")  >
				<cflocation url="salir.cfm">
			</cfif> 
		</cfif> --->

		<cfreturn True/>
	</cffunction>
	
	<!---RequestEnd --->
	<cffunction name="OnRequestEnd" access="public" returntype="void" output="true" hint="Es lanzado cuando el procesamiento de la pagina se completa">
	
		<!--- Resetea los cookies de CFID y CFToken para expirar la session y                 
					las variables del cliente despues de que el usuario cierra el navegador     --->
		<cfif IsDefined("Cookie.CFID") AND IsDefined("Cookie.CFToken")>
			<cfcookie name="CFID" value="#Cookie.CFID#"/>
			<cfcookie name="CFToken" value="#Cookie.CFToken#" />
		</cfif>
		<cfreturn />
	</cffunction>
	
	<!---SessionEnd --->
	<cffunction name="OnSessionEnd" access="public" returntype="void" output="false" hint="Es lanzado cuando la sesión es terminada">
		<cfargument name="SessionScope" type="struct" required="true"/>
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#"/>
	 
		<cfreturn />
	</cffunction>
	
	<!---ApplicationEnd --->
	<cffunction name="OnApplicationEnd" access="public" returntype="void" output="false" hint="Es lanzado cuando la aplicación es terminada">
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#"/>
	
		<cfreturn />
	</cffunction>
</cfcomponent> 