-- Initial data for the request status table

INSERT INTO request_status (name, description, color)
VALUES 
    ('Pending', 'Request registered but not yet attended', '#FFC107'),
    ('In Progress', 'Request being attended by the team', '#2196F3'),
    ('Completed', 'Request successfully attended', '#4CAF50'),
    ('Cancelled', 'Request cancelled by the requester or the system', '#F44336')
ON CONFLICT (name) DO UPDATE 
SET description = EXCLUDED.description,
    color = EXCLUDED.color;