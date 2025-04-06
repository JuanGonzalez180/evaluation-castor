-- Initial data for the positions table

INSERT INTO positions (name)
VALUES 
    ('Scrum Master'),
    ('Developer'),
    ('QA'),
    ('PO')
ON CONFLICT (name) DO NOTHING;