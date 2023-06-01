--Time series all segments: firstreader, rereader, subscribers, buyers, Ebook buyers, Video buyers

SELECT date, COUNT(*) AS numb_of_users
FROM dilans_firstreader
GROUP BY date
ORDER BY date ASC;

SELECT date, COUNT(*) AS numb_of_users
FROM dilans_rereader
GROUP BY date
ORDER BY date ASC;

SELECT date, COUNT(*) AS numb_of_users
FROM dilans_subs
GROUP BY date
ORDER BY date ASC;

SELECT date, COUNT(*) AS numb_of_users
FROM dilans_purchase
GROUP BY date
ORDER BY date ASC;

--Time series E-book buyers
SELECT date, COUNT(*) AS numb_of_users
FROM dilans_purchase
WHERE amount = 8
GROUP BY date
ORDER BY date ASC;

--Time series Video buyers
SELECT date, COUNT(*) AS numb_of_users
FROM dilans_purchase
WHERE amount = 80
GROUP BY date
ORDER BY date ASC;


--Segments of first readers
-- First readers' distribution per Advertising channel
SELECT source, COUNT(*) AS numb_of_users
FROM dilans_firstreader
GROUP BY source
ORDER BY numb_of_users DESC;

-- First readers' distribution per Country
SELECT country, COUNT(*) AS numb_of_users
FROM dilans_firstreader
GROUP BY country
ORDER BY country;

-- First readers' distribution per Content topic (region)
SELECT region, COUNT(*) AS numb_of_users
FROM dilans_firstreader
GROUP BY region
ORDER BY numb_of_users DESC;

--Overview of purchases and buyers analysis
-- number of total purchases (E-book, Video total)
SELECT COUNT(*) numb_buys
FROM dilans_purchase;

-- number of buyers (user_id) 
SELECT COUNT(DISTINCT(user_id)) numb_buying_users
FROM dilans_purchase;

-- Number of purchases, buyers, amount spent per Product type (8 = Ebook, 80 = Video) --> both products' buyers are calculated twice!
SELECT amount, 
       COUNT(*) AS numb_of_buys, 
       COUNT(DISTINCT(user_id)) AS numb_of_users, 
       SUM (amount) AS income
FROM dilans_purchase
GROUP BY amount;

-- Number of purchases, buyers, amount spent per Product type (8 = Ebook, 80 = Video, 88 = Both)
SELECT amount, 
       COUNT(DISTINCT user_id) AS numb_users, 
       SUM(amount) as income
FROM (
  SELECT user_id, SUM(amount) AS amount
  FROM dilans_purchase
  WHERE amount IN (8, 80)
  GROUP BY user_id
) total_spend
GROUP BY amount;

--Buying users income per month --> calculating the buyers who bought both products within one month

--JANUARY
SELECT amount, 
       COUNT(DISTINCT user_id) AS num_users, 
       SUM(amount) as income
FROM (
  SELECT user_id, SUM(amount) AS amount
  FROM dilans_purchase
  WHERE amount IN (8, 80) AND date <'2018-02-01'
  GROUP BY user_id) total_spend
GROUP BY amount
;

--FEBRUARY
SELECT amount, 
       COUNT(DISTINCT user_id) AS num_users, 
       SUM(amount) as income
FROM (
  SELECT user_id, SUM(amount) AS amount
  FROM dilans_purchase
  WHERE amount IN (8, 80) AND date >'2018-01-31' AND date <'2018-03-01'
  GROUP BY user_id) total_spend
GROUP BY amount
;

--MARCH
SELECT amount, 
       COUNT(DISTINCT user_id) AS num_users, 
       SUM(amount) as income
FROM (
  SELECT user_id, SUM(amount) AS amount
  FROM dilans_purchase
  WHERE amount IN (8, 80) AND date >'2018-02-28'
  GROUP BY user_id) total_spend
GROUP BY amount
;

-- Income groups' analysis per product group (Ebook, Video or Both)

-- Income groups per Advertising channel
SELECT total_spend.amount, 
       dilans_firstreader.source, 
       COUNT(DISTINCT total_spend.user_id) AS num_users, 
       SUM(amount) AS income
FROM (
  SELECT user_id, SUM(amount) AS amount
  FROM dilans_purchase
  WHERE amount IN (8, 80)
  GROUP BY user_id
) total_spend
JOIN dilans_firstreader
ON dilans_firstreader.user_id = total_spend.user_id
GROUP BY total_spend.amount, dilans_firstreader.source;

-- Income groups per country
SELECT total_spend.amount, 
       dilans_firstreader.country, 
       COUNT(DISTINCT total_spend.user_id) AS num_users, 
       SUM(amount) AS income
FROM (
  SELECT user_id, SUM(amount) AS amount
  FROM dilans_purchase
  WHERE amount IN (8, 80)
  GROUP BY user_id
) total_spend
JOIN dilans_firstreader
ON dilans_firstreader.user_id = total_spend.user_id
GROUP BY total_spend.amount, dilans_firstreader.country;

--Income gropus per Content Topic
SELECT total_spend.amount, 
       dilans_firstreader.region, 
       COUNT(DISTINCT total_spend.user_id) AS num_users, 
       SUM(amount) AS income
FROM (
  SELECT user_id, SUM(amount) AS amount
  FROM dilans_purchase
  WHERE amount IN (8, 80)
  GROUP BY user_id
) total_spend
JOIN dilans_firstreader
ON dilans_firstreader.user_id = total_spend.user_id
GROUP BY total_spend.amount, dilans_firstreader.region;

-- Microsegmentation of income groups (country, Advertising channel)
SELECT total_spend.amount, 
       dilans_firstreader.country, dilans_firstreader.source, 
       COUNT(DISTINCT total_spend.user_id) AS num_users, 
       SUM(amount) AS income
FROM (
  SELECT user_id, SUM(amount) AS amount
  FROM dilans_purchase
  WHERE amount IN (8, 80)
  GROUP BY user_id
) total_spend
JOIN dilans_firstreader
ON dilans_firstreader.user_id = total_spend.user_id
GROUP BY total_spend.amount, dilans_firstreader.country, dilans_firstreader.source;


--Funnel analysis of blog readers (4 Steps: reader, re reader, subscriber, buyer)
SELECT dilans_firstreader.date, dilans_firstreader.source, dilans_firstreader.country,
      COUNT(DISTINCT(dilans_firstreader.user_id)) AS first_reader, 
      COUNT(DISTINCT(dilans_rereader.user_id)) AS returning_reader, 
      COUNT(DISTINCT(dilans_subs.user_id)) AS subscriber, 
      COUNT(DISTINCT(dilans_purchase.user_id)) AS buyer
FROM dilans_firstreader
LEFT JOIN dilans_rereader
ON dilans_firstreader.user_id = dilans_rereader.user_id
LEFT JOIN dilans_subs
ON dilans_firstreader.user_id = dilans_subs.user_id
LEFT JOIN dilans_purchase
ON dilans_firstreader.user_id = dilans_purchase.user_id
GROUP BY dilans_firstreader.date, dilans_firstreader.source, dilans_firstreader.country
ORDER BY dilans_firstreader.date, dilans_firstreader.source, dilans_firstreader.country;


--ROI per source in 3 months
--ADWORDS
SELECT subquery.source, (income - 1500)/1500::float AS ROI
FROM
    (SELECT dilans_firstreader.source, 
            SUM (amount) AS income, 
            COUNT(DISTINCT(dilans_purchase.user_id)) AS numb_buyers
    FROM dilans_purchase
    LEFT JOIN dilans_firstreader
    ON dilans_firstreader.user_id = dilans_purchase.user_id
    GROUP BY dilans_firstreader.source) AS subquery
WHERE subquery.source = 'AdWords';

--ROI per source in 3 months
--REDDIT, SEO
SELECT subquery.source, (income - 750)/750 ::float AS ROI
FROM
    (SELECT dilans_firstreader.source,
             SUM (amount) AS income, 
             COUNT(DISTINCT(dilans_purchase.user_id)) AS numb_buyers
    FROM dilans_purchase
    LEFT JOIN dilans_firstreader
    ON dilans_firstreader.user_id = dilans_purchase.user_id
    GROUP BY dilans_firstreader.source) AS subquery
WHERE subquery.source IN ('Reddit', 'SEO');

--Netnet income per buyer per source
--Adwords
SELECT subquery.source, (income - 1500)/numb_buyers :: float AS NN_income_per_user
FROM
    (SELECT dilans_firstreader.source, 
            SUM (amount) AS income, 
            COUNT(DISTINCT(dilans_purchase.user_id)) AS numb_buyers
    FROM dilans_purchase
    LEFT JOIN dilans_firstreader
    ON dilans_firstreader.user_id = dilans_purchase.user_id
    GROUP BY dilans_firstreader.source) AS subquery
WHERE subquery.source IN ('AdWords');

--Netnet income per buyer per source
--Adwords
SELECT subquery.source, (income - 750)/numb_buyers :: float AS NN_income_per_user
FROM
    (SELECT dilans_firstreader.source, 
            SUM (amount) AS income, 
            COUNT(DISTINCT(dilans_purchase.user_id)) AS numb_buyers
    FROM dilans_purchase
    LEFT JOIN dilans_firstreader
    ON dilans_firstreader.user_id = dilans_purchase.user_id
    GROUP BY dilans_firstreader.source) AS subquery
WHERE subquery.source IN ('Reddit', 'SEO');

-- Daily active users - subscribers+buyers as Uniqe Users per day
SELECT dilans_subs.date,COUNT(*) AS DAU, 
      COUNT(DISTINCT (dilans_subs.user_id)) AS subs, 
      COUNT(DISTINCT(dilans_purchase.user_id)) AS buyers 
 FROM dilans_subs
 FULL JOIN dilans_purchase
 ON dilans_subs.user_id = dilans_purchase.user_id
 GROUP BY dilans_subs.date
 ORDER BY dilans_subs.date ASC;
 
--Daily revenue
SELECT date, SUM(amount) AS Daily_revenue
FROM dilans_purchase
GROUP BY date
ORDER BY date ASC;
