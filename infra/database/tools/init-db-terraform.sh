#!/bin/bash
# Script to initialize the database through Terraform

# Set default values
ENV=${1:-dev}
TERRAFORM_DIR="../terraform"
OUTPUT_FILE="terraform_output.json"

# Change to terraform directory
cd "$TERRAFORM_DIR" || { echo "Error: Terraform directory not found"; exit 1; }

# Get database connection information from Terraform outputs
echo "Extracting database connection information from Terraform outputs..."
terraform output -json > "$OUTPUT_FILE"

if [ ! -s "$OUTPUT_FILE" ]; then
    echo "Error: Failed to get Terraform outputs"
    exit 1
fi

# Extract database connection details
DB_HOST=$(jq -r '.database_endpoint.value | split(":")[0]' "$OUTPUT_FILE")
DB_PORT=$(jq -r '.database_endpoint.value | split(":")[1]' "$OUTPUT_FILE")
DB_NAME=$(jq -r '.db_name.value' "$OUTPUT_FILE")
DB_USERNAME=$(jq -r '.db_username.value' "$OUTPUT_FILE")

# Ask for database password (don't store in script for security)
echo -n "Enter database password: "
read -s DB_PASSWORD
echo ""

if [ -z "$DB_PASSWORD" ]; then
    echo "Error: Password cannot be empty"
    exit 1
fi

# Generate temporary Liquibase properties file
PROPS_FILE=$(mktemp)
cat > "$PROPS_FILE" << EOF
# Generated Liquibase properties for $ENV environment

# Driver JDBC for PostgreSQL
driver=org.postgresql.Driver

# Connection configuration
url=jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME
username=$DB_USERNAME
password=$DB_PASSWORD

# Liquibase configuration
changeLogFile=changelog/master.yaml
liquibaseSchemaName=public
defaultSchemaName=public
logLevel=INFO

# Set user for changelog comments
liquibase.user=liquibase_$ENV

# Search path
searchPath=.

# Enable SQL filtering
enableSqlFilter=true

# Output file encoding
outputFileEncoding=UTF-8
EOF

# Change to database directory
cd "../../database" || { echo "Error: Database directory not found"; exit 1; }

# Run Liquibase update
echo "Running Liquibase update..."
docker run --rm \
  -v "$(pwd)":/liquibase/changelog \
  -v "$PROPS_FILE":/liquibase/changelog/liquibase.properties \
  liquibase/liquibase:4.23-alpine \
  --defaultsFile=/liquibase/changelog/liquibase.properties \
  update

RESULT=$?

# Clean up
rm "$PROPS_FILE"
rm "$TERRAFORM_DIR/$OUTPUT_FILE"

if [ $RESULT -eq 0 ]; then
    echo "Database initialization completed successfully"
else
    echo "Error: Database initialization failed"
    exit 1
fi