component extends="app.Models.Model" {
    function config() {
        table("cached_releases");

        property(
            name="id",
            column="id",
            dataType="integer",
            automaticValidations=false
        );

        property(
            name="data",
            column="data",
            dataType="text",
            label="Cached Data",
            defaultValue=""
        );

        property(
            name="lastUpdated",
            column="last_updated",
            dataType="datetime",
            label="Last Updated"
        );
    }
}