<cfscript>
/**
 * One-time data migration: SQL Server → CockroachDB
 *
 * Lives in public/miscellaneous/ so Wheels framework does not interfere.
 * Both datasources are defined inline — no framework dependency.
 *
 * Usage:  https://wheels.dev/miscellaneous/migrate-data.cfm?key=RELOAD_PASSWORD
 * Delete: Remove this file after migration is complete.
 */

// ── Auth gate ──────────────────────────────────────────────────────────
param name="url.key" default="";
RELOAD_PASSWORD = "w4u6r7daKHAYMDLZXDgUcwn99RReNium";
if (url.key != RELOAD_PASSWORD) {
	writeOutput("Unauthorized. Pass ?key=YOUR_RELOAD_PASSWORD");
	abort;
}

// ── Datasource structs (inline — no Application.cfc needed) ────────────
SOURCE_DS = {
	class: "com.microsoft.sqlserver.jdbc.SQLServerDriver",
	bundleName: "org.lucee.mssql",
	bundleVersion: "12.6.3.jre11",
	connectionString: "jdbc:sqlserver://aura.paiindustries.com:1433;DATABASENAME=cfwheelsdb;encrypt=false;trustServerCertificate=true;SelectMethod=direct",
	username: "SVC_CFWheels_DBRWE",
	password: "encrypted:9fdfc3298d8822ad3c9f2fe1e42961c3854233a5a8b41846b9419428eba6a01bc07d94e7e3ed87a61201918db878e73581899591407177c36e45be03149ba5d8"
};

TARGET_DS = {
	class: "org.postgresql.Driver",
	bundleName: "org.lucee.postgresql",
	bundleVersion: "42.7.4",
	connectionString: "jdbc:postgresql://10.100.10.230:26257/wheels_db?sslmode=disable",
	username: "wheels_user",
	password: "x5N6kR62ArF58zetwMSZ"
};

// ── Configuration ──────────────────────────────────────────────────────
BATCH_SIZE = 200;

// Tables in dependency order (parents before children).
// Comments use a self-referencing FK, so we defer FK checks for that table.
tables = [
	// Phase 1: Lookup tables (no FK dependencies)
	"roles",
	"modules",
	"post_statuses",
	"post_types",
	"features",
	"contributor_roles",
	"settings",
	"cached_releases",
	"categories",
	"email_templates",
	"newsletter_subscribers",

	// Phase 2: Permissions (depends on modules)
	"permissions",
	"role_permissions",

	// Phase 3: Users and auth (depends on roles)
	"users",
	"login_attempts",
	"remember_tokens",
	"password_resets",
	"user_tokens",

	// Phase 4: Blog content (depends on users + lookups)
	"blog_posts",
	"tags",
	"blog_categories",
	"comments",
	"attachments",

	// Phase 5: User activity (depends on users + blog_posts)
	"reading_histories",
	"bookmarks",

	// Phase 6: Other
	"testimonials",
	"contributors",
	"logs"
];

// ── Helper functions ───────────────────────────────────────────────────

function readSource(required string tableName) {
	try {
		return queryExecute(
			"SELECT * FROM [#arguments.tableName#]",
			{},
			{ datasource: SOURCE_DS }
		);
	} catch (any e) {
		return { data: queryNew(""), error: e.message };
	}
}

function targetCount(required string tableName) {
	try {
		var result = queryExecute(
			'SELECT COUNT(*) AS cnt FROM "#arguments.tableName#"',
			{},
			{ datasource: TARGET_DS }
		);
		return result.cnt;
	} catch (any e) {
		return -1;
	}
}

/**
 * Build a parameterized INSERT for a batch of rows.
 */
function buildInsert(required string tableName, required query data, required numeric startRow, required numeric endRow) {
	var columns = listToArray(arguments.data.columnList);
	var quotedCols = [];
	for (var col in columns) {
		arrayAppend(quotedCols, '"#lCase(col)#"');
	}
	var colList = arrayToList(quotedCols, ", ");

	var valueClauses = [];
	var params = {};
	var paramIdx = 0;

	for (var r = arguments.startRow; r <= arguments.endRow; r++) {
		var placeholders = [];
		for (var col in columns) {
			paramIdx++;
			var paramName = "p#paramIdx#";
			var val = arguments.data[col][r];

			if (isNull(val)) {
				params[paramName] = { value: "", null: true };
			} else {
				params[paramName] = { value: val };
			}

			arrayAppend(placeholders, ":#paramName#");
		}
		arrayAppend(valueClauses, "(#arrayToList(placeholders, ', ')#)");
	}

	var sql = 'INSERT INTO "#lCase(arguments.tableName)#" (#colList#) VALUES #arrayToList(valueClauses, ", ")#';
	return { sql: sql, params: params };
}

/**
 * Migrate a single table.
 */
function migrateTable(required string tableName) {
	var result = {
		table: arguments.tableName,
		sourceRows: 0,
		inserted: 0,
		skipped: false,
		error: "",
		duration: 0
	};

	var startTick = getTickCount();

	try {
		// Skip if target already has data (idempotent re-runs)
		var existingCount = targetCount(arguments.tableName);
		if (existingCount == -1) {
			result.error = "Table does not exist in target";
			result.duration = getTickCount() - startTick;
			return result;
		}
		if (existingCount > 0) {
			result.skipped = true;
			result.sourceRows = existingCount;
			result.error = "Target already has #existingCount# rows -- skipping";
			result.duration = getTickCount() - startTick;
			return result;
		}

		// Read all rows from source
		var sourceResult = readSource(arguments.tableName);
		if (isStruct(sourceResult) && structKeyExists(sourceResult, "error")) {
			result.error = "Source read failed: " & sourceResult.error;
			result.duration = getTickCount() - startTick;
			return result;
		}
		var sourceData = isStruct(sourceResult) ? sourceResult.data : sourceResult;
		result.sourceRows = sourceData.recordCount;

		if (sourceData.recordCount == 0) {
			result.duration = getTickCount() - startTick;
			return result;
		}

		// Insert in batches
		var totalRows = sourceData.recordCount;
		var batchStart = 1;

		while (batchStart <= totalRows) {
			var batchEnd = min(batchStart + BATCH_SIZE - 1, totalRows);
			var insert = buildInsert(arguments.tableName, sourceData, batchStart, batchEnd);

			queryExecute(insert.sql, insert.params, { datasource: TARGET_DS });

			result.inserted += (batchEnd - batchStart + 1);
			batchStart = batchEnd + 1;
		}

	} catch (any e) {
		result.error = e.message;
		if (len(e.detail)) result.error &= " | " & e.detail;
	}

	result.duration = getTickCount() - startTick;
	return result;
}

/**
 * After importing data with explicit IDs, bump sequences past the max ID
 * so new inserts don't collide.
 */
function resetSequences() {
	var results = [];
	try {
		var seqs = queryExecute("
			SELECT sequence_name
			FROM information_schema.sequences
			WHERE sequence_schema = 'public'
		", {}, { datasource: TARGET_DS });

		for (var i = 1; i <= seqs.recordCount; i++) {
			var seqName = seqs.sequence_name[i];
			// Convention: tablename_id_seq
			var tableName = reReplace(seqName, "_id_seq$", "");

			try {
				var maxResult = queryExecute(
					'SELECT COALESCE(MAX(id), 0) AS max_id FROM "#tableName#"',
					{},
					{ datasource: TARGET_DS }
				);

				if (maxResult.max_id > 0) {
					queryExecute(
						"SELECT setval('#seqName#', #maxResult.max_id#)",
						{},
						{ datasource: TARGET_DS }
					);
					arrayAppend(results, "  #seqName# -> #maxResult.max_id#");
				}
			} catch (any e) {
				arrayAppend(results, "  WARN #seqName#: #e.message#");
			}
		}
	} catch (any e) {
		arrayAppend(results, "  Failed to query sequences: #e.message#");
	}
	return results;
}

// ── Main ───────────────────────────────────────────────────────────────

setting requestTimeout=600; // 10 minute timeout for large tables

startTime = getTickCount();
totalInserted = 0;
totalErrors = 0;

writeOutput("<h1>wheels.dev Data Migration: SQL Server &rarr; CockroachDB</h1>");
writeOutput("<pre>");

// Test connectivity
writeOutput("Testing SQL Server connection... ");
try {
	queryExecute("SELECT 1 AS ok", {}, { datasource: SOURCE_DS });
	writeOutput("OK#chr(10)#");
} catch (any e) {
	writeOutput("FAILED: #e.message##chr(10)#");
	writeOutput("</pre>");
	abort;
}

writeOutput("Testing CockroachDB connection... ");
try {
	queryExecute("SELECT 1 AS ok", {}, { datasource: TARGET_DS });
	writeOutput("OK#chr(10)#");
} catch (any e) {
	writeOutput("FAILED: #e.message##chr(10)#");
	writeOutput("</pre>");
	abort;
}

writeOutput("#chr(10)#Migrating #arrayLen(tables)# tables...#chr(10)#");
writeOutput(repeatString("-", 60) & chr(10));

for (var tblName in tables) {
	writeOutput("  #tblName# ... ");
	cfflush();

	var r = migrateTable(tblName);

	if (len(r.error) && !r.skipped) {
		writeOutput("ERROR (#r.duration#ms)#chr(10)#");
		writeOutput("    #r.error##chr(10)#");
		totalErrors++;
	} else if (r.skipped) {
		writeOutput("SKIPPED (#r.error#)#chr(10)#");
	} else if (r.sourceRows == 0) {
		writeOutput("empty#chr(10)#");
	} else {
		writeOutput("#r.inserted#/#r.sourceRows# rows (#r.duration#ms)#chr(10)#");
		totalInserted += r.inserted;
	}
}

// Reset sequences
writeOutput("#chr(10)#Resetting sequences...#chr(10)#");
var seqResults = resetSequences();
for (var line in seqResults) {
	writeOutput(line & chr(10));
}

// Summary
var elapsed = numberFormat((getTickCount() - startTime) / 1000, "0.0");
writeOutput("#chr(10)#" & repeatString("=", 60) & chr(10));
writeOutput("Done in #elapsed#s | Rows inserted: #totalInserted# | Errors: #totalErrors##chr(10)#");
writeOutput(repeatString("=", 60) & chr(10));

if (totalErrors == 0) {
	writeOutput("#chr(10)#Migration complete. Next steps:#chr(10)#");
	writeOutput("  1. Verify the app at https://wheels.dev#chr(10)#");
	writeOutput("  2. Apply session TTL on CockroachDB:#chr(10)#");
	writeOutput("     ALTER TABLE cf_session_data SET (gc.ttl = '7200s', gc.ttl_select = 'expires');#chr(10)#");
	writeOutput("  3. DELETE THIS FILE#chr(10)#");
} else {
	writeOutput("#chr(10)#Some tables had errors. Fix and re-run (tables with data are skipped).#chr(10)#");
}

writeOutput("</pre>");
</cfscript>
