<cfcomponent extends="wheels.migrator.Migration" hint="creates category table">
    <cffunction name="up">
        <cftransaction>
            <cfscript>
                try {
                    // create categories table
                    t = createTable(name='categories', force=false, id=true, primaryKey='id');
                    t.string(columnNames='name', nullable=false, default='', limit=255);
                    t.integer(columnNames='parent_id', nullable=true);
                    t.string(columnNames='description', nullable=true, default='', limit=500);
                    t.timestamps();
                    t.create();

                } catch (any e) {
                    local.exception = e;
                }
            </cfscript>
            <cfif StructKeyExists(local, "exception")>
                <cftransaction action="rollback" />
                <cfthrow 
                    detail = "#local.exception.detail#"
                    errorCode = "1"
                    message = "#local.exception.message#"
                    type = "Any">
            <cfelse>
                <cftransaction action="commit" />
            </cfif>
        </cftransaction>
    </cffunction>

    <cffunction name="down">
        <cftransaction>
            <cfscript>
                try {
                    // drop categories table
                    dropTable(name='categories');
                } catch (any e) {
                    local.exception = e;
                }
            </cfscript>
            <cfif StructKeyExists(local, "exception")>
                <cftransaction action="rollback" />
                <cfthrow 
                    detail = "#local.exception.detail#"
                    errorCode = "1"
                    message = "#local.exception.message#"
                    type = "Any">
            <cfelse>
                <cftransaction action="commit" />
            </cfif>
        </cftransaction>
    </cffunction>
</cfcomponent>
