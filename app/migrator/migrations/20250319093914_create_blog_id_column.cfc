/*
  |------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
	| Parameter     | Required | Type    | Default | Description                                                                                                                                           |
  |------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
	| table         | Yes      | string  |         | existing table name                                                                                                                                   |
	| columnType    | Yes      | string  |         | type of column to add                                                                                                                                 |
	| columnName    | No       | string  |         | name for new column, required if columnType is not 'reference'                                                                                        |
	| referenceName | No       | string  |         | name for new reference column, see documentation for references function, required if columnType is 'reference'                                       |
	| default       | No       | string  |         | default value for column                                                                                                                              |
	| null          | No       | boolean |         | whether nulls are allowed                                                                                                                             |
	| limit         | No       | number  |         | character or integer size limit for column                                                                                                            |
	| precision     | No       | number  |         | precision value for decimal columns, i.e. number of digits the column can hold                                                                        |
	| scale         | No       | number  |         | scale value for decimal columns, i.e. number of digits that can be placed to the right of the decimal point (must be less than or equal to precision) |
  |------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

    EXAMPLE:
			addColumn(table='members', columnType='string', columnName='status', limit=50);
*/
component extends="wheels.migrator.Migration" hint="create_blog_id_column_in_blog_categories" {

	function up() {
		transaction {
			try {
				addColumn(table = 'blog_categories', columnType = 'integer', columnName = 'blog_id', default = '', null = true);

				// add foreign key constraint
                addForeignKey(
                    table='blog_categories',
                    column='blog_id',
                    referenceTable='blog_posts',
                    referenceColumn='id'
                );
				
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
				// drop foreign key constraints using raw SQL
                execute(sql="ALTER TABLE blog_categories DROP CONSTRAINT IF EXISTS fk_categories_blog_id");

				removeColumn(table = 'blog_categories', columnName = 'blog_id');
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
