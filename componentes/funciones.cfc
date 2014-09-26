<cfcomponent>
	
	<cffunction name="queryToJson" access="public" returntype="array">
		<cfargument name="query" type="query" required="true"/>

		<cfset var Local.return=arraynew(1)>
		
		<cfloop query="Arguments.query">
			<cfset var Local.row=structNew()>

			<cfloop list="#arguments.query.columnList#" index="column">
				<cfset Local.row[column]=Arguments.query[column][currentRow]>
			</cfloop>

			<cfset arrayAppend(Local.return,Local.row)>
		</cfloop>

		<cfreturn Local.return />
	</cffunction>
</cfcomponent>