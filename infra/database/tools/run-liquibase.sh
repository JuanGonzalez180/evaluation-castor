#!/bin/bash
# Script to run Liquibase commands directly without Terraform

# Set default values
ACTION=${1:-"update"}
ENV=${2:-"dev"}
PROPS_FILE="config/liquibase-${ENV}.properties"

# Check if command is valid
VALID_COMMANDS=("update" "rollback" "tag" "status" "validate" "clearCheckSums" "dropAll")
if [[ ! " ${VALID_COMMANDS[*]} " =~ " ${ACTION} " ]]; then
    echo "Error: Invalid command '$ACTION'"
    echo "Valid commands: ${VALID_COMMANDS[*]}"
    exit 1
fi

# Base directory of the script
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$BASE_DIR" || { echo "Error: Base directory not found"; exit 1; }

# Check if the properties file exists
if [ ! -f "$PROPS_FILE" ]; then
    echo "Error: Properties file '$PROPS_FILE' not found"
    echo "Available property files:"
    ls -1 config/liquibase-*.properties 2>/dev/null || echo "  No property files found"
    exit 1
fi

# Handle rollback specially
if [ "$ACTION" == "rollback" ]; then
    if [ -z "$3" ]; then
        echo "Error: For rollback, you need to specify a tag or count"
        echo "Usage: $0 rollback $ENV <tag|count>"
        exit 1
    fi
    ROLLBACK_TO=$3
    echo "Running Liquibase rollback to $ROLLBACK_TO in $ENV environment..."
    
    # Check if rollback_to is numeric (count) or a tag
    if [[ "$ROLLBACK_TO" =~ ^[0-9]+$ ]]; then
        docker run --rm \
            -v "$(pwd)":/liquibase/changelog \
            liquibase/liquibase:4.23-alpine \
            --defaultsFile=/liquibase/changelog/$PROPS_FILE \
            rollbackCount "$ROLLBACK_TO"
    else
        docker run --rm \
            -v "$(pwd)":/liquibase/changelog \
            liquibase/liquibase:4.23-alpine \
            --defaultsFile=/liquibase/changelog/$PROPS_FILE \
            rollback "$ROLLBACK_TO"
    fi
# Handle tag command
elif [ "$ACTION" == "tag" ]; then
    if [ -z "$3" ]; then
        echo "Error: For tag, you need to specify a tag name"
        echo "Usage: $0 tag $ENV <tag_name>"
        exit 1
    fi
    TAG_NAME=$3
    echo "Tagging the database as '$TAG_NAME' in $ENV environment..."
    docker run --rm \
        -v "$(pwd)":/liquibase/changelog \
        liquibase/liquibase:4.23-alpine \
        --defaultsFile=/liquibase/changelog/$PROPS_FILE \
        tag "$TAG_NAME"
# Handle all other commands
else
    echo "Running Liquibase $ACTION in $ENV environment..."
    docker run --rm \
        -v "$(pwd)":/liquibase/changelog \
        liquibase/liquibase:4.23-alpine \
        --defaultsFile=/liquibase/changelog/$PROPS_FILE \
        "$ACTION"
fi

# Check result
if [ $? -eq 0 ]; then
    echo "Liquibase $ACTION completed successfully"
else
    echo "Error: Liquibase $ACTION failed"
    exit 1
fi