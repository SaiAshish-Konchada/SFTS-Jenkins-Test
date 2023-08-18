-- Create the 'users' table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    totp_secret TEXT NOT NULL
);

-- Create the 'login_attempts' table
CREATE TABLE login_attempts (
    ip_address inet PRIMARY KEY,
    attempts integer,
    blocked_until timestamp without time zone
);
