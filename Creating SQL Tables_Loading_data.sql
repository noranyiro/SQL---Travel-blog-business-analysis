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

--BASH Code to copy data
\COPY dilans_firstreader FROM '/home/ownserver/dilans_first_read_date.csv' DELIMITER ';';
\COPY dilans_rereader FROM '/home/ownserver/dilans_more_reads_date.csv' DELIMITER ';';
\COPY dilans_subs FROM '/home/ownserver/dilans_subs_date.csv' DELIMITER ';';
\COPY dilans_purchase FROM '/home/ownserver/dilans_buy_date.csv' DELIMITER ';';
