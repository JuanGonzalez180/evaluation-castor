-- Requesters Table
CREATE TABLE IF NOT EXISTS requesters (
    requester_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    address TEXT,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for frequent searches
CREATE INDEX IF NOT EXISTS idx_requesters_name ON requesters(name);
CREATE INDEX IF NOT EXISTS idx_requesters_email ON requesters(email);

-- Comments
COMMENT ON TABLE requesters IS 'Individuals or entities that make service requests';
COMMENT ON COLUMN requesters.requester_id IS 'Unique identifier of the requester';
COMMENT ON COLUMN requesters.name IS 'Full name of the requester';
COMMENT ON COLUMN requesters.email IS 'Contact email address';
COMMENT ON COLUMN requesters.phone IS 'Contact phone number';
COMMENT ON COLUMN requesters.address IS 'Physical address of the requester';
COMMENT ON COLUMN requesters.creation_date IS 'Date and time the record was created';