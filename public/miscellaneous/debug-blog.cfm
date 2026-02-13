<cfscript>
// Quick diagnostic for blog loading issue
TARGET_DS = {
	class: "org.postgresql.Driver",
	bundleName: "org.postgresql.jdbc",
	bundleVersion: "42.7.7",
	connectionString: "jdbc:postgresql://10.100.10.230:26257/wheels_db?sslmode=require",
	username: "wheels_user",
	password: "x5N6kR62ArF58zetwMSZ"
};

writeOutput("<pre>");

// 1. Check if the blog post exists at all
slug = "cleaner-configuration-in-wheels-3-0-less-magic-more-clarity";
writeOutput("=== Looking for blog with slug: #slug# ===" & chr(10) & chr(10));

q = queryExecute("
	SELECT id, slug, status, is_published, is_deleted, deletedat, status_id
	FROM blog_posts
	WHERE slug = :slug
", { slug: slug }, { datasource: TARGET_DS });

writeOutput("Found #q.recordCount# rows" & chr(10));
if (q.recordCount > 0) {
	writeOutput("  id: #q.id#" & chr(10));
	writeOutput("  slug: #q.slug#" & chr(10));
	writeOutput("  status: [#q.status#]" & chr(10));
	writeOutput("  is_published: #q.is_published#" & chr(10));
	writeOutput("  is_deleted: #q.is_deleted#" & chr(10));
	writeOutput("  deletedat: [#isNull(q.deletedat) ? 'NULL' : q.deletedat#]" & chr(10));
	writeOutput("  status_id: #q.status_id#" & chr(10));
}

// 2. Check what the full query with joins would return
writeOutput(chr(10) & "=== Simulating getBlogBySlug query ===" & chr(10));
q2 = queryExecute("
	SELECT bp.id, bp.slug, bp.status, bp.is_published, bp.deletedat as bp_deleted,
	       u.id as user_id, u.first_name,
	       ps.id as ps_id, ps.name as ps_name, ps.deletedat as ps_deleted
	FROM blog_posts bp
	LEFT JOIN users u ON bp.created_by = u.id
	LEFT JOIN post_statuses ps ON bp.status_id = ps.id
	WHERE bp.slug = :slug
", { slug: slug }, { datasource: TARGET_DS });

writeOutput("Found #q2.recordCount# rows" & chr(10));
if (q2.recordCount > 0) {
	writeOutput("  blog id: #q2.id#" & chr(10));
	writeOutput("  status: [#q2.status#]" & chr(10));
	writeOutput("  is_published: #q2.is_published#" & chr(10));
	writeOutput("  bp.deletedat: [#isNull(q2.bp_deleted) ? 'NULL' : q2.bp_deleted#]" & chr(10));
	writeOutput("  user_id: #q2.user_id#, name: #q2.first_name#" & chr(10));
	writeOutput("  user.deletedat: checking..." & chr(10));
	writeOutput("  ps_id: #q2.ps_id#, ps_name: [#q2.ps_name#]" & chr(10));
	writeOutput("  ps.deletedat: [#isNull(q2.ps_deleted) ? 'NULL' : q2.ps_deleted#]" & chr(10));
}

// 3. Test the WHERE conditions separately
writeOutput(chr(10) & "=== Testing WHERE conditions ===" & chr(10));
q3 = queryExecute("
	SELECT bp.id, bp.slug
	FROM blog_posts bp
	LEFT JOIN users u ON bp.created_by = u.id
	LEFT JOIN post_statuses ps ON bp.status_id = ps.id
	WHERE bp.slug = :slug
	  AND bp.status = 'Approved'
	  AND bp.is_published = true
	  AND bp.deletedat IS NULL
	  AND u.deletedat IS NULL
	  AND ps.deletedat IS NULL
", { slug: slug }, { datasource: TARGET_DS });
writeOutput("With all soft-delete + conditions: #q3.recordCount# rows" & chr(10));

// 4. Check users table for the author
writeOutput(chr(10) & "=== Checking user deletedat values ===" & chr(10));
q4 = queryExecute("
	SELECT u.id, u.first_name, u.deletedat
	FROM users u
	JOIN blog_posts bp ON bp.created_by = u.id
	WHERE bp.slug = :slug
", { slug: slug }, { datasource: TARGET_DS });
if (q4.recordCount > 0) {
	writeOutput("  user #q4.id# (#q4.first_name#) deletedat: [#isNull(q4.deletedat) ? 'NULL' : q4.deletedat#]" & chr(10));
}

// 5. Check deletedat NULL vs empty string
writeOutput(chr(10) & "=== deletedat NULL check ===" & chr(10));
q5a = queryExecute("
	SELECT count(*) as cnt FROM blog_posts WHERE deletedat IS NULL
", {}, { datasource: TARGET_DS });
writeOutput("  blog_posts WHERE deletedat IS NULL: #q5a.cnt#" & chr(10));

q5b = queryExecute("
	SELECT count(*) as cnt FROM blog_posts WHERE deletedat IS NOT NULL
", {}, { datasource: TARGET_DS });
writeOutput("  blog_posts WHERE deletedat IS NOT NULL: #q5b.cnt#" & chr(10));

q5c = queryExecute("
	SELECT count(*) as cnt FROM blog_posts
", {}, { datasource: TARGET_DS });
writeOutput("  blog_posts total: #q5c.cnt#" & chr(10));

// Check specific blog
q5d = queryExecute("
	SELECT deletedat IS NULL as is_null, deletedat::text as dat_text
	FROM blog_posts WHERE slug = :slug
", { slug: slug }, { datasource: TARGET_DS });
if (q5d.recordCount > 0) {
	writeOutput("  Target blog deletedat IS NULL: #q5d.is_null#" & chr(10));
	writeOutput("  Target blog deletedat::text: [#q5d.dat_text#]" & chr(10));
}

// Check users too
writeOutput(chr(10) & "=== users deletedat NULL check ===" & chr(10));
q5e = queryExecute("
	SELECT count(*) as cnt FROM users WHERE deletedat IS NULL
", {}, { datasource: TARGET_DS });
writeOutput("  users WHERE deletedat IS NULL: #q5e.cnt#" & chr(10));
q5f = queryExecute("
	SELECT count(*) as cnt FROM users WHERE deletedat IS NOT NULL
", {}, { datasource: TARGET_DS });
writeOutput("  users WHERE deletedat IS NOT NULL: #q5f.cnt#" & chr(10));

// Check post_statuses
writeOutput(chr(10) & "=== post_statuses deletedat NULL check ===" & chr(10));
q5g = queryExecute("
	SELECT count(*) as cnt FROM post_statuses WHERE deletedat IS NULL
", {}, { datasource: TARGET_DS });
writeOutput("  post_statuses WHERE deletedat IS NULL: #q5g.cnt#" & chr(10));
q5h = queryExecute("
	SELECT count(*) as cnt FROM post_statuses WHERE deletedat IS NOT NULL
", {}, { datasource: TARGET_DS });
writeOutput("  post_statuses WHERE deletedat IS NOT NULL: #q5h.cnt#" & chr(10));

writeOutput("</pre>");
</cfscript>
