component extends="wheels.migrator.Migration" hint="create_newsletter_subscribers_table" {
    function up() {
        transaction {
            try {
                t = createTable(name = "newsletter_subscribers", force=false, id=true, primaryKey='id');
                t.string(columnNames="email", limit=255, null=false);
                t.string(columnNames="status", limit=20, default="pending");
                t.string(columnNames="verification_token", limit=255);
                t.timestamps();
                t.create();

                addIndex(table="newsletter_subscribers", columnNames="email", unique=true);
                addIndex(table="newsletter_subscribers", columnNames="verification_token");
            } catch (any e) {
                local.exception = e;
            }

            if (StructKeyExists(local, "exception")) {
                transaction action="rollback";
                Throw(errorCode = "1", detail = local.exception.detail, message = local.exception.message, type = "any");
            } else {
                transaction action="commit";
            }
        }
    }

    function down() {
        transaction {
            try {
                dropTable("newsletter_subscribers");
            } catch (any e) {
                local.exception = e;
            }

            if (StructKeyExists(local, "exception")) {
                transaction action="rollback";
                Throw(errorCode = "1", detail = local.exception.detail, message = local.exception.message, type = "any");
            } else {
                transaction action="commit";
            }
        }
    }
} 