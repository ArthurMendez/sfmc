/**************************************************************************
* Filename:   0011_dataviews_aggregate.sql
* Author:     Arthur Mendez
* Copyright:  (C) 2025 Arthur Mendez III <hello@amendez.dev>
* Licenses:   Apache v2.0 https://www.apache.org/licenses/LICENSE-2.0.txt
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    Data view aggregate functions
              For your data views reference: https://dataviews.io
**************************************************************************/

/* Here is the intial pitch of creating a send aggregate query. Ideally this */
/* query should work in SFMC, but by joining several data view tables */
/* the query becomes susceptible to execution timeouts - regardless of */
/* the data view size. EventDate and datediff are being left out */
/*intentionally in the begining SQL for learning purpurposes. */
select j.emailname, j.jobid
, count(s.subscriberkey) as sent
, count(o.subscriberkey) as opens
, count(c.subscriberkey) as clicks
, count(b.subscriberkey) as bounces
, count(u.subscriberkey) as unsubscribes
, count(comp.subscriberkey) as complaints
from [_sent] as s

/* Ideally there would be a selected amount of emails for this many joins. */
inner join [_job] as j
  on j.jobid = s.jobid
  and j.emailname in ('2025 Q1 Quarterly Newsletter', '2025 Q2 Quarterly Newsletter'
    , '2025 Q2 Winback', 'Registration', 'Welcome', 'Abandon Registration')

left join [_open] as o
  on o.subscriberkey = s.subscriberkey
  and o.jobid = s.jobid
  and o.isunique = 1

left join [_click] as c
  on c.subscriberkey = s.subscriberkey
  and c.jobid = s.jobid
  and c.isunique = 1

left join [_bounce] as b
  on b.subscriberkey = s.subscriberkey
  and b.jobid = s.jobid
  and b.isunique = 1

left join [_unsubscribe] as u
  on u.subscriberkey = s.subscriberkey
  and u.jobid = s.jobid
  and u.isunique = 1

left join [_complaint] as comp
  on comp.subscriberkey = s.subscriberkey
  and comp.jobid = s.jobid
  and comp.isunique = 1

group by j.emailname, j.jobid



/* Because of data views timing out in a sporadic manner, the above should */
/* be broken up in several queries inside an automation with an update action */
/* to the target data extension. This example shows the above broken up into */
/* several queries, with email name and job ids as the primary keys in the */
/* target DE. */

/* Query 1: Sent */
select j.emailname, j.jobid
, count(1) as sent
from [_sent] as s

inner join [_job] as j
  on j.jobid = s.jobid
  and j.emailname in ('2025 Q1 Quarterly Newsletter', '2025 Q2 Quarterly Newsletter'
    , '2025 Q2 Winback', 'Registration', 'Welcome', 'Abandon Registration')

group by j.emailname, j.jobid


/* Query 2: Opens */
select j.emailname, j.jobid
, count(1) as opens
from [_open] as o

inner join [_job] as j
  on j.jobid = o.jobid
  and j.emailname in ('2025 Q1 Quarterly Newsletter', '2025 Q2 Quarterly Newsletter'
    , '2025 Q2 Winback', 'Registration', 'Welcome', 'Abandon Registration')

group by j.emailname, j.jobid


/* Query 3: Clicks */
select j.emailname, j.jobid
, count(1) as clicks
from [_click] as c

inner join [_job] as j
  on j.jobid = c.jobid
  and j.emailname in ('2025 Q1 Quarterly Newsletter', '2025 Q2 Quarterly Newsletter'
    , '2025 Q2 Winback', 'Registration', 'Welcome', 'Abandon Registration')

group by j.emailname, j.jobid


/* Query 4: Bounces */
select j.emailname, j.jobid
, count(1) as bounces
from [_bounce] as b

inner join [_job] as j
  on j.jobid = b.jobid
  and j.emailname in ('2025 Q1 Quarterly Newsletter', '2025 Q2 Quarterly Newsletter'
    , '2025 Q2 Winback', 'Registration', 'Welcome', 'Abandon Registration')

group by j.emailname, j.jobid


/* Query 5: Unsubscribes */
select j.emailname, j.jobid
, count(1) as bounces
from [_unsubscribe] as u

inner join [_job] as j
  on j.jobid = u.jobid
  and j.emailname in ('2025 Q1 Quarterly Newsletter', '2025 Q2 Quarterly Newsletter'
    , '2025 Q2 Winback', 'Registration', 'Welcome', 'Abandon Registration')

group by j.emailname, j.jobid



/* Query 6: Complaints - these are not usually necessary*/
select j.emailname, j.jobid
, count(1) as complaints
from [_complaint] as comp

inner join [_job] as j
  on j.jobid = comp.jobid
  and j.emailname in ('2025 Q1 Quarterly Newsletter', '2025 Q2 Quarterly Newsletter'
    , '2025 Q2 Winback', 'Registration', 'Welcome', 'Abandon Registration')

group by j.emailname, j.jobid


/* This example of the aggregate data views utilizes datediff which will */
/* be fequently used in aggregate collection. Ideally you don't want to capture */
/* the entire 6 months but rather query smaller increments date wise to prevent */
/* execution timeouts. For breaking up the query in a range of days or weeks. */
select j.emailname, j.jobid
, count(1) as clicks
from [_click] as c

inner join [_job] as j
  on j.jobid = c.jobid
  and j.emailname in ('2025 Q1 Quarterly Newsletter', '2025 Q2 Quarterly Newsletter'
    , '2025 Q2 Winback', 'Registration', 'Welcome', 'Abandon Registration')

where datediff(wk, c.eventdate, getdate()) = 0 /* In the last week or the last 7 days. */
/* where datediff(dd, c.eventdate, getdate()) < 7 */ /* Same logic, different code. */
group by j.emailname, j.jobid