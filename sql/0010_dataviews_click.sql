/**************************************************************************
* Filename:   0008_dataviews_click.sql
* Author:     Arthur Mendez
* Copyright:  (C) 2025 Arthur Mendez III <hello@amendez.dev>
* Licenses:   Apache v2.0 https://www.apache.org/licenses/LICENSE-2.0.txt
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    Click tracking through data views.
              For your data views reference: https://dataviews.io
**************************************************************************/

/* A standard email click count. */
select j.emailname, count(1) as unique_clicks
from [_click] as c

inner join [_job] as j
  on j.jobid = c.jobid
  and j.emailname = "2025 Q3 Quarterly Newsletter"

/* Leaving out the list id and batch id as the use of isUnique should suffice for a specific send. */
/* The use of list id and batch id will be used later for accuracy on aggregate logging. */
where c.isunique = 1
group by j.emailname



/* A standard email click count with consideration of non-unsubscribe clicks. */
select j.emailname, count(1) as unique_clicks
from [_click] as c

inner join [_job] as j
  on j.jobid = c.jobid
  and j.emailname = "2025 Q3 Quarterly Newsletter"

left join [_unsubscribe] as u
  on u.jobid = c.jobid
  and u.isunique = 1

where c.isunique = 1
and u.jobid is null
group by j.emailname



/* Scenario: Segment out an audience for a follow up email to the 2025 Q3 Quarterly Newsletter */
/* of those subscribers that did not click a link inside the email. */
select a.subscriberkey, a.emailaddress
from [2025 Q3 Quarterly Newsletter] as a

left join (
  select c.subscriberkey
  from [_click] as c

  inner join [_job] as j
    on j.jobid = c.jobid
    and j.emailname = "2025 Q3 Quarterly Newsletter"

  where c.isunique = 1
) as log
  on log.subscriberkey = a.subscriberkey
  
where log.subscriberkey is null