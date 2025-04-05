-- Employees table

CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    identification_number BIGINT NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    photo_url VARCHAR(1000),
    hire_date DATE NOT NULL,
    position_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_employee_position FOREIGN KEY (position_id) REFERENCES positions(position_id)
);

-- Comments
COMMENT ON TABLE employees IS 'Information about the company employees';
COMMENT ON COLUMN employees.id IS 'Unique identifier for the employee';
COMMENT ON COLUMN employees.identification_number IS 'Employee identification number';
COMMENT ON COLUMN employees.name IS 'Full name of the employee';
COMMENT ON COLUMN employees.photo_url IS 'URL of the employee photo in S3';
COMMENT ON COLUMN employees.hire_date IS 'Date the employee joined the company';
COMMENT ON COLUMN employees.position_id IS 'Identifier of the employee position';
COMMENT ON COLUMN employees.created_at IS 'Date the record was created';