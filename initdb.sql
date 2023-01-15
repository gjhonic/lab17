CREATE TABLE IF NOT EXISTS todos
(
    Id SERIAL PRIMARY KEY,
    message VARCHAR(255),
    description VARCHAR(255)
);

INSERT INTO todos (Id, message, description) VALUES 
    (1, 'wake up', 'you need wake up man'),
    (2, 'to eat', 'You have to eat so as not to die'),
    (3, 'go to bed', 'to wake up you have to fall asleep');