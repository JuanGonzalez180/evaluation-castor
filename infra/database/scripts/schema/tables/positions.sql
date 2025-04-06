-- Table of positions
-- This script creates the "positions" table, which stores information about job positions in the company.

CREATE TABLE IF NOT EXISTS positions (
    position_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE positions IS 'Catalog of available job positions in the company';
COMMENT ON COLUMN positions.position_id IS 'Unique identifier of the position';
COMMENT ON COLUMN positions.name IS 'Name of the position';
COMMENT ON COLUMN positions.created_at IS 'Date the record was created';