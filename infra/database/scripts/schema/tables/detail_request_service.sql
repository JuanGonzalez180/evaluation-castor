-- Table for service request details
CREATE TABLE IF NOT EXISTS service_request_detail (
    detail_id SERIAL PRIMARY KEY,
    request_id INT NOT NULL,
    service_id INT NOT NULL,
    observations TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_request_detail FOREIGN KEY (request_id) REFERENCES requests(request_id) ON DELETE CASCADE,
    CONSTRAINT fk_service_detail FOREIGN KEY (service_id) REFERENCES services(service_id),
    CONSTRAINT uk_request_service_detail UNIQUE (request_id, service_id)
);

-- Comments
COMMENT ON TABLE service_request_detail IS 'Details of services included in each request';
COMMENT ON COLUMN service_request_detail.detail_id IS 'Unique identifier for the detail';
COMMENT ON COLUMN service_request_detail.request_id IS 'Reference to the main request';
COMMENT ON COLUMN service_request_detail.service_id IS 'Reference to the requested service';
COMMENT ON COLUMN service_request_detail.observations IS 'Specific observations for this service';
COMMENT ON COLUMN service_request_detail.created_at IS 'Date and time of record creation';