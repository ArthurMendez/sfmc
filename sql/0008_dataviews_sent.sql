/**************************************************************************
* Filename:   0008_dataviews_sent.sql
* Author:     Arthur Mendez
* Copyright:  (C) 2025 Arthur Mendez III <hello@amendez.dev>
* Licenses:   Apache v2.0 https://www.apache.org/licenses/LICENSE-2.0.txt
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    This is some into code on data viewss with relation to 
              emails sent.
              For your data views reference: https://dataviews.io
**************************************************************************/

/* Note that the sent data view only archives data for the previous */
/* 6 months. My suggestion would be to create a custom sent log for */
/* these records outside of data views. */
/* https://trailhead.salesforce.com/content/learn/modules/marketing-cloud-data-management/collect-data-with-a-send-log */

/* A standard subscriber count for anyone receiving an email in the previous */
/* six months. Just a note that some data views such as _Sent only go back 6mo. */
select j.emailname, j.createddate, count(1) as totals
from [_sent] as s

inner join [_job] as j
  on j.jobid = s.jobid
  and j.emailname like "2025 Q%" /* If there were 2025 Q1 or 2025 Q2 sends */

group by j.emailname, j.createddate



/* Query those that were sent in the last 12 days. */
select j.emailname, count(1) as totals
from [_sent] as s

inner join [_job] as j
  on j.jobid = s.jobid
  and j.emailname = "2025 Q3 Quarterly Newsletter"

where datediff(dd, s.eventdate, getdate()) < 12

group by j.emailname