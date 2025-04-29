component extends="app.Models.Model" {
    function config() {
        table("logs");

        // ID Property
        property(
            name="id", 
            column="id", 
            dataType="integer", 
            automaticValidations=false
        );

        // Category Property
        property(
            name="category", 
            column="category", 
            dataType="string", 
            label="Category", 
            defaultValue=""
        );

        // Level Property
        property(
            name="level", 
            column="level", 
            dataType="string", 
            label="Level", 
            defaultValue="INFO"
        );

        // Message Property
        property(
            name="message", 
            column="message", 
            dataType="string", 
            label="Message", 
            defaultValue=""
        );

        // Details Property (JSON)
        property(
            name="details", 
            column="details", 
            dataType="string", 
            label="Details", 
            defaultValue="{}"
        );

        // IP Address Property
        property(
            name="ipAddress", 
            column="ip_address", 
            dataType="string", 
            label="IP Address", 
            defaultValue=""
        );

        // User ID Property
        property(
            name="userId", 
            column="user_id", 
            dataType="integer", 
            label="User ID", 
            defaultValue=0
        );

        // Timestamps
        property(
            name="createdAt", 
            column="createdat", 
            dataType="timestamp", 
            label="Created On"
        );

        property(
            name="updatedAt", 
            column="updated_at", 
            dataType="timestamp", 
            label="Last Updated"
        );

        // Relationships
        // belongsTo(name="User", foreignKey="userId");
    }

    // Log a message
    public function log(
        required string category,
        required string level,
        required string message,
        struct details = {},
        numeric userId = 0
    ) {
        var newLog = new();
        newLog.category = arguments.category;
        newLog.level = arguments.level;
        newLog.message = arguments.message;
        newLog.details = serializeJSON(arguments.details);
        newLog.ipAddress = cgi.REMOTE_ADDR;
        
        // Only set user_id if the user exists
        if (arguments.userId > 0) {
            var user = model("User").findByKey(arguments.userId);
            if (!isNull(user)) {
                newLog.userId = arguments.userId;
            }
        }
        
        newLog.save();
        return newLog;
    }

    // Get logs with filters
    public function getLogs(
        string category = "",
        string level = "",
        date startDate = "",
        date endDate = "",
        numeric userId = 0,
        numeric page = 1,
        numeric perPage = 50
    ) {
        var whereClause = [];
        var params = {};

        if (len(arguments.category)) {
            arrayAppend(whereClause, "category = :category");
            params.category = arguments.category;
        }

        if (len(arguments.level)) {
            arrayAppend(whereClause, "level = :level");
            params.level = arguments.level;
        }

        if (isDate(arguments.startDate)) {
            arrayAppend(whereClause, "createdat >= :startDate");
            params.startDate = arguments.startDate;
        }

        if (isDate(arguments.endDate)) {
            arrayAppend(whereClause, "createdat <= :endDate");
            params.endDate = arguments.endDate;
        }

        if (arguments.userId > 0) {
            arrayAppend(whereClause, "user_id = :userId");
            params.userId = arguments.userId;
        }

        var where = arrayLen(whereClause) ? arrayToList(whereClause, " AND ") : "";

        return findAll(
            where = where,
            params = params,
            order = "createdat DESC",
            page = arguments.page,
            perPage = arguments.perPage
        );
    }

    // Clear old logs
    public function clearOldLogs(numeric days = 90) {
        var cutoffDate = dateAdd("d", -arguments.days, now());
        deleteAll(where = "createdat < :cutoffDate", params = {cutoffDate = cutoffDate});
    }
} 