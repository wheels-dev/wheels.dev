/**
 * Error Service
 *
 * Handles error capture and integration with Sentry error tracking.
 * Provides methods to capture exceptions with context and send to Sentry.
 *
 * Environment Variables:
 * - SENTRY_DSN: Sentry DSN for error submission
 * - SENTRY_ENVIRONMENT: Environment name (development/staging/production)
 */
component {

    /**
     * Get the Sentry DSN from environment variables
     */
    private string function getSentryDsn() {
        if (structKeyExists(server, "system") && structKeyExists(server.system, "environment")) {
            if (structKeyExists(server.system.environment, "SENTRY_DSN")) {
                return server.system.environment.SENTRY_DSN;
            }
        }
        // Try application-level env vars
        if (structKeyExists(application, "env") && structKeyExists(application.env, "SENTRY_DSN")) {
            return application.env.SENTRY_DSN;
        }
        return "";
    }

    /**
     * Get the Sentry environment from environment variables
     */
    private string function getSentryEnvironment() {
        if (structKeyExists(server, "system") && structKeyExists(server.system, "environment")) {
            if (structKeyExists(server.system.environment, "SENTRY_ENVIRONMENT")) {
                return server.system.environment.SENTRY_ENVIRONMENT;
            }
        }
        // Try application-level env vars
        if (structKeyExists(application, "env") && structKeyExists(application.env, "SENTRY_ENVIRONMENT")) {
            return application.env.SENTRY_ENVIRONMENT;
        }
        // Default to Wheels environment
        if (structKeyExists(application, "wheels") && structKeyExists(application.wheels, "environment")) {
            return application.wheels.environment;
        }
        return "development";
    }

    /**
     * Capture an exception and send to Sentry
     *
     * @exception The exception/error struct to capture (requires message at minimum)
     * @context Struct containing user, request, and environment context
     * @return string Sentry event ID if sent successfully, empty string otherwise
     */
    public string function captureException(required any exception, struct context = {}) {
        var sentryEventId = "";

        // Extract exception details
        var errorMessage = "";
        var errorType = "exception";
        var stackTrace = "";

        if (isStruct(arguments.exception)) {
            errorMessage = structKeyExists(arguments.exception, "message") ? arguments.exception.message : "";
            if (structKeyExists(arguments.exception, "detail") && len(arguments.exception.detail)) {
                errorMessage = errorMessage & " - " & arguments.exception.detail;
            }
            if (structKeyExists(arguments.exception, "type") && len(arguments.exception.type)) {
                errorType = arguments.exception.type;
            }
            if (structKeyExists(arguments.exception, "tagContext") && isArray(arguments.exception.tagContext)) {
                stackTrace = formatStackTrace(arguments.exception.tagContext);
            }
        } else if (isSimpleValue(arguments.exception)) {
            errorMessage = arguments.exception;
        }

        // Extract context with safe defaults
        var userId = "";
        var userEmail = "";
        var userRole = "";
        var requestUrl = "";
        var httpMethod = "";
        var requestController = "";
        var requestAction = "";
        var appEnvironment = getSentryEnvironment();

        // User context
        if (structKeyExists(arguments.context, "user")) {
            if (structKeyExists(arguments.context.user, "id")) {
                userId = arguments.context.user.id;
            }
            if (structKeyExists(arguments.context.user, "email")) {
                userEmail = arguments.context.user.email;
            }
            if (structKeyExists(arguments.context.user, "role")) {
                userRole = arguments.context.user.role;
            }
        }

        // Request context
        if (structKeyExists(arguments.context, "request")) {
            if (structKeyExists(arguments.context.request, "url")) {
                requestUrl = arguments.context.request.url;
            }
            if (structKeyExists(arguments.context.request, "httpMethod")) {
                httpMethod = arguments.context.request.httpMethod;
            }
            if (structKeyExists(arguments.context.request, "controller")) {
                requestController = arguments.context.request.controller;
            }
            if (structKeyExists(arguments.context.request, "action")) {
                requestAction = arguments.context.request.action;
            }
        }

        // Environment context
        if (structKeyExists(arguments.context, "environment")) {
            appEnvironment = arguments.context.environment;
        }

        // Send to Sentry (non-blocking, catch all errors)
        var sentryDsn = getSentryDsn();
        if (len(sentryDsn)) {
            try {
                sentryEventId = sendToSentry(
                    dsn = sentryDsn,
                    errorMessage = errorMessage,
                    errorType = errorType,
                    stackTrace = stackTrace,
                    context = {
                        user = {
                            id = userId,
                            email = userEmail,
                            role = userRole
                        },
                        request = {
                            url = requestUrl,
                            httpMethod = httpMethod,
                            controller = requestController,
                            action = requestAction
                        },
                        environment = appEnvironment
                    }
                );
            } catch (any sentryError) {
                // Sentry errors should never block application execution
                writeLog(file="application", text="Sentry submission failed: #sentryError.message#", type="error");
            }
        }

        return sentryEventId;
    }

    /**
     * Format stack trace from tag context array
     *
     * @tagContext Array of tag context structs from exception
     * @return string Formatted stack trace
     */
    private string function formatStackTrace(required array tagContext) {
        var lines = [];
        for (var frame in arguments.tagContext) {
            var line = "";
            if (structKeyExists(frame, "template")) {
                line = frame.template;
            }
            if (structKeyExists(frame, "line")) {
                line = line & ":" & frame.line;
            }
            if (len(line)) {
                arrayAppend(lines, line);
            }
        }
        return arrayToList(lines, chr(10));
    }

    /**
     * Send error to Sentry via HTTP API
     *
     * @dsn Sentry DSN string
     * @errorMessage The error message
     * @errorType The error type/category
     * @stackTrace Formatted stack trace
     * @context Context struct with user, request, environment
     * @return string Sentry event ID if successful, empty string otherwise
     */
    private string function sendToSentry(
        required string dsn,
        required string errorMessage,
        required string errorType,
        string stackTrace = "",
        struct context = {}
    ) {
        var eventId = "";

        // Parse DSN to get project ID and API key
        var dsnParts = parseSentryDsn(arguments.dsn);
        if (structIsEmpty(dsnParts)) {
            return "";
        }

        // Generate event ID (32 char hex string)
        eventId = lCase(replace(createUUID(), "-", "", "all"));

        // Build Sentry event payload
        var payload = {
            "event_id" = eventId,
            "timestamp" = dateTimeFormat(now(), "yyyy-MM-dd'T'HH:nn:ss'Z'"),
            "platform" = "coldfusion",
            "level" = "error",
            "logger" = "cfml",
            "message" = {
                "formatted" = arguments.errorMessage
            },
            "exception" = {
                "values" = [
                    {
                        "type" = arguments.errorType,
                        "value" = arguments.errorMessage,
                        "stacktrace" = {
                            "frames" = parseStackTraceToFrames(arguments.stackTrace)
                        }
                    }
                ]
            },
            "environment" = structKeyExists(arguments.context, "environment") ? arguments.context.environment : "development",
            "server_name" = cgi.SERVER_NAME
        };

        // Add user context
        if (structKeyExists(arguments.context, "user") && isStruct(arguments.context.user)) {
            payload["user"] = {};
            if (structKeyExists(arguments.context.user, "id") && len(arguments.context.user.id)) {
                payload.user["id"] = arguments.context.user.id;
            }
            if (structKeyExists(arguments.context.user, "email") && len(arguments.context.user.email)) {
                payload.user["email"] = arguments.context.user.email;
            }
            if (structKeyExists(arguments.context.user, "role") && len(arguments.context.user.role)) {
                payload.user["role"] = arguments.context.user.role;
            }
        }

        // Add tags for request context
        payload["tags"] = {};
        if (structKeyExists(arguments.context, "request") && isStruct(arguments.context.request)) {
            if (structKeyExists(arguments.context.request, "controller") && len(arguments.context.request.controller)) {
                payload.tags["controller"] = arguments.context.request.controller;
            }
            if (structKeyExists(arguments.context.request, "action") && len(arguments.context.request.action)) {
                payload.tags["action"] = arguments.context.request.action;
            }
        }

        // Add request context
        if (structKeyExists(arguments.context, "request") && isStruct(arguments.context.request)) {
            payload["request"] = {};
            if (structKeyExists(arguments.context.request, "url") && len(arguments.context.request.url)) {
                payload.request["url"] = arguments.context.request.url;
            }
            if (structKeyExists(arguments.context.request, "httpMethod") && len(arguments.context.request.httpMethod)) {
                payload.request["method"] = arguments.context.request.httpMethod;
            }
        }

        // Add extra context
        payload["extra"] = {
            "_wheels_environment" = structKeyExists(application, "wheels") && structKeyExists(application.wheels, "environment") ? application.wheels.environment : "unknown",
            "_http_x_forwarded_for" = cgi.http_X_Forwarded_For
        };

        // Make HTTP POST to Sentry
        var storeUrl = dsnParts.protocol & "://" & dsnParts.host & "/api/" & dsnParts.projectId & "/store/";

        try {
            cfhttp(
                method = "POST",
                url = storeUrl,
                timeout = 5,
                result = "httpResult"
            ) {
                cfhttpparam(type = "header", name = "Content-Type", value = "application/json");
                cfhttpparam(type = "header", name = "X-Sentry-Auth", value = "Sentry sentry_version=7, sentry_client=cfml-client/1.0, sentry_key=#dsnParts.publicKey#");
                cfhttpparam(type = "body", value = serializeJSON(payload));
            }

            // Check for success (200 or 202)
            var statusCode = listFirst(httpResult.statusCode, " ");
            if (listFindNoCase("200,202", statusCode)) {
                return eventId;
            }
        } catch (any httpError) {
            // HTTP errors should not propagate
        }

        return "";
    }

    /**
     * Parse Sentry DSN string into components
     *
     * @dsn Sentry DSN string (format: https://<key>@<host>/<project>)
     * @return struct with protocol, publicKey, host, projectId or empty struct on failure
     */
    private struct function parseSentryDsn(required string dsn) {
        var result = {};

        if (!len(arguments.dsn)) {
            return result;
        }

        try {
            // Parse DSN: https://key@host/project
            var withoutProtocol = listRest(arguments.dsn, "://");
            var protocol = listFirst(arguments.dsn, "://");

            // Get public key (before @)
            var publicKey = listFirst(withoutProtocol, "@");

            // Get rest after @
            var afterKey = listRest(withoutProtocol, "@");

            // Split host and project ID
            var host = "";
            var projectId = "";

            // Find last slash to separate host from project ID
            var lastSlashPos = findLast("/", afterKey);
            if (lastSlashPos > 0) {
                host = left(afterKey, lastSlashPos - 1);
                projectId = mid(afterKey, lastSlashPos + 1, len(afterKey));
            }

            if (len(protocol) && len(publicKey) && len(host) && len(projectId)) {
                result = {
                    protocol = protocol,
                    publicKey = publicKey,
                    host = host,
                    projectId = projectId
                };
            }
        } catch (any parseError) {
            // Return empty struct on parse failure
        }

        return result;
    }

    /**
     * Parse stack trace string into Sentry-compatible frames array
     *
     * @stackTrace Newline-separated stack trace string
     * @return array of frame structs for Sentry payload
     */
    private array function parseStackTraceToFrames(required string stackTrace) {
        var frames = [];

        if (!len(arguments.stackTrace)) {
            return frames;
        }

        var lines = listToArray(arguments.stackTrace, chr(10));
        for (var line in lines) {
            var frame = {
                "filename" = line,
                "function" = "unknown"
            };

            // Try to extract line number if present (format: path:line)
            if (find(":", line)) {
                var parts = listToArray(line, ":");
                if (arrayLen(parts) >= 2) {
                    frame.filename = parts[1];
                    if (isNumeric(parts[arrayLen(parts)])) {
                        frame["lineno"] = val(parts[arrayLen(parts)]);
                    }
                }
            }

            arrayAppend(frames, frame);
        }

        return frames;
    }

    /**
     * Find last occurrence of a substring in a string
     *
     * @needle The substring to find
     * @haystack The string to search in
     * @return numeric Position of last occurrence, 0 if not found
     */
    private numeric function findLast(required string needle, required string haystack) {
        var pos = 0;
        var currentPos = find(arguments.needle, arguments.haystack);

        while (currentPos > 0) {
            pos = currentPos;
            currentPos = find(arguments.needle, arguments.haystack, currentPos + 1);
        }

        return pos;
    }

    /**
     * Sanitize a scope struct for safe inclusion in error reports
     *
     * Removes sensitive keys and handles non-serializable values.
     *
     * @scopeData The struct to sanitize
     * @maxDepth Maximum nesting depth to include (default 2)
     * @currentDepth Current recursion depth (internal use)
     * @return struct Sanitized copy of the scope data
     */
    public struct function sanitizeScopeData(required any scopeData, numeric maxDepth = 2, numeric currentDepth = 0) {
        var result = {};
        var sensitivePatterns = "password,secret,token,key,dsn,credential,auth,private,apikey,api_key";

        if (arguments.currentDepth >= arguments.maxDepth || !isStruct(arguments.scopeData)) {
            return result;
        }

        for (var keyName in arguments.scopeData) {
            try {
                var isSensitive = false;
                for (var pattern in listToArray(sensitivePatterns)) {
                    if (findNoCase(pattern, keyName)) {
                        isSensitive = true;
                        break;
                    }
                }

                if (isSensitive) {
                    result[keyName] = "[REDACTED]";
                    continue;
                }

                var value = arguments.scopeData[keyName];

                if (isNull(value)) {
                    result[keyName] = "[NULL]";
                } else if (isSimpleValue(value)) {
                    if (isSimpleValue(value) && len(value) > 500) {
                        result[keyName] = left(value, 500) & "... [truncated]";
                    } else {
                        result[keyName] = value;
                    }
                } else if (isStruct(value)) {
                    result[keyName] = sanitizeScopeData(value, arguments.maxDepth, arguments.currentDepth + 1);
                } else if (isArray(value)) {
                    result[keyName] = "[Array with " & arrayLen(value) & " elements]";
                } else if (isQuery(value)) {
                    result[keyName] = "[Query with " & value.recordCount & " rows]";
                } else if (isObject(value)) {
                    result[keyName] = "[Object: " & getMetadata(value).name & "]";
                } else {
                    result[keyName] = "[Complex Value]";
                }
            } catch (any e) {
                result[keyName] = "[Unreadable]";
            }
        }

        return result;
    }

}
