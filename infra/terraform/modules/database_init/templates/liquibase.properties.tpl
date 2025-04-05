# Generated Liquibase properties for ${environment} environment

# Driver JDBC for PostgreSQL
driver=org.postgresql.Driver

# Connection configuration
url=jdbc:postgresql://${db_host}:${db_port}/${db_name}
username=${db_username}
password=${db_password}

# Liquibase configuration
changeLogFile=changelog/master.yaml
liquibaseSchemaName=public
defaultSchemaName=public
logLevel=INFO

# Set user for changelog comments
liquibase.user=liquibase_${environment}

# Search path
searchPath=.

# Enable SQL filtering
enableSqlFilter=true

# Output file encoding
outputFileEncoding=UTF-8