/**************************************************************************
* Filename:   0002_random_rows.sql
* Author:     Arthur Mendez
* Copyright:  (C) 2025 Arthur Mendez III <hello@amendez.dev>
* Licenses:   Apache v2.0 https://www.apache.org/licenses/LICENSE-2.0.txt
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    A trivial way to return random rows in the SELECT statement.
**************************************************************************/

/* Raffle Example where there are two winners */
select top 2 a.subscriberkey, a.emailaddress, a.first_name, a.last_name, a.mobile
from [2025_Winter_Raffle_Contest] as a
order by newid()



/* AB Testing a 50/50 random split. */
/* Initially set the Data Extension AB test field to default into something */
/* similar to: "Control". Then in the query DE action use Update. */
select top 50 percent a.subscriberkey, a.emailaddress, a.first_name, a.mobile
, 'Treatment' as ab_segment
from [sendable_audience] as a
order by newid()



/* Quick 10 random query for Query Studio. */
select top 10 a.subscriberkey, a.emailaddress, a.first_name, a.postal_code
from [senable_audience] as a
where a.postal_code in ('94061', '94062', '94063', '94064', '94065')
order by newid()