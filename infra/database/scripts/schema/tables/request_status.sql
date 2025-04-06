-- Request Status Table

CREATE TABLE IF NOT EXISTS request_status (
    status_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    color VARCHAR(7),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE request_status IS 'Catalog of possible statuses for service requests';
COMMENT ON COLUMN request_status.status_id IS 'Unique identifier for the status';
COMMENT ON COLUMN request_status.name IS 'Name of the status';
COMMENT ON COLUMN request_status.description IS 'Detailed description of the status';
COMMENT ON COLUMN request_status.color IS 'Hexadecimal color code for UI visualization';
COMMENT ON COLUMN request_status.created_at IS 'Date when the record was created';