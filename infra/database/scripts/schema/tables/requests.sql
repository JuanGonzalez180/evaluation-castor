-- Requests Table

CREATE TABLE IF NOT EXISTS requests (
    request_id SERIAL PRIMARY KEY,
    request_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    requester_id INT NOT NULL,
    status_id INT NOT NULL,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_request_requester FOREIGN KEY (requester_id) REFERENCES requesters(requester_id),
    CONSTRAINT fk_request_status FOREIGN KEY (status_id) REFERENCES request_status(status_id)
);

-- Indexes for frequent searches
CREATE INDEX IF NOT EXISTS idx_requests_date ON requests(request_date);
CREATE INDEX IF NOT EXISTS idx_requests_status ON requests(status_id);
CREATE INDEX IF NOT EXISTS idx_requests_requester ON requests(requester_id);

-- Comments
COMMENT ON TABLE requests IS 'Service requests made by requesters';
COMMENT ON COLUMN requests.request_id IS 'Unique identifier of the request';
COMMENT ON COLUMN requests.request_date IS 'Date and time when the request was made';
COMMENT ON COLUMN requests.requester_id IS 'Identifier of the requester who made the request';
COMMENT ON COLUMN requests.status_id IS 'Current status of the request';
COMMENT ON COLUMN requests.creation_date IS 'Date and time when the record was created';