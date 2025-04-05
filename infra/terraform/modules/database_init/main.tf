# Local resource to capture DB schema from scripts
resource "local_file" "liquibase_properties" {
    content = templatefile("${path.module}/templates/liquibase.properties.tpl", {
        db_host     = var.db_host
        db_port     = var.db_port
        db_name     = var.db_name
        db_username = var.db_username
        db_password = var.db_password
        environment = var.environment
    })
    filename = "${path.module}/liquibase-${var.environment}.properties"
}

# Null resource to execute Liquibase migrations using Docker
resource "null_resource" "liquibase_update" {
    # This will trigger re-run if any of these inputs change
    triggers = {
        db_host     = var.db_host
        db_name     = var.db_name
        environment = var.environment
        # Add hash of all changelog files to detect changes
        changelog_hash = join(",", [
            for file in fileset("${path.module}/../../../database/changelog", "*.yaml") :
            filesha256("${path.module}/../../../database/changelog/${file}")
        ])
    }

    # This ensures the DB is available before running migrations
    depends_on = [local_file.liquibase_properties]

    # Execute Liquibase using Docker
    provisioner "local-exec" {
        command = <<-EOT
        docker run --rm \
            -v ${path.module}/../../../database:/liquibase/changelog \
            -v ${path.module}/liquibase-${var.environment}.properties:/liquibase/changelog/liquibase.properties \
            ${var.liquibase_container_image} \
            --defaultsFile=/liquibase/changelog/liquibase.properties \
            update
        EOT
    }
}
