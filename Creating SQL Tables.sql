CREATE TABLE dilans_firstreader (
    date DATE,
    time TIME,
    event_type TEXT,
    country TEXT,
    user_id BIGINT,
    source TEXT,
    region TEXT
);

CREATE TABLE dilans_rereader (
    date DATE,
    time TIME,
    event_type TEXT,
    country TEXT,
    user_id BIGINT,
    region TEXT
);

CREATE TABLE dilans_subs (
    date DATE,
    time TIME,
    event_type TEXT,
    user_id BIGINT
);

CREATE TABLE dilans_purchase (
    date DATE,
    time TIME,
    event_type TEXT,
    user_id BIGINT,
    amount INTEGER
);

