-- Services table

CREATE TABLE IF NOT EXISTS services (
    service_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for searches by name
CREATE INDEX IF NOT EXISTS idx_services_name ON services(name);

-- Comments
COMMENT ON TABLE services IS 'Catalog of available services';
COMMENT ON COLUMN services.service_id IS 'Unique identifier of the service';
COMMENT ON COLUMN services.name IS 'Name of the service';
COMMENT ON COLUMN services.description IS 'Detailed description of the service';
COMMENT ON COLUMN services.creation_date IS 'Date and time of record creation';