/**************************************************************************
* Filename:   0008_dataviews_unsub.sql
* Author:     Arthur Mendez
* Copyright:  (C) 2025 Arthur Mendez III <yo@rthur.dev>
* Licenses:   Apache v2.0 https://www.apache.org/licenses/LICENSE-2.0.txt
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    Unsubscribe logging through data views.
              For your data views reference: https://dataviews.io
**************************************************************************/

/* A standard email unsubscribe count. Note that the sent data view only */
/* archives data for the previous 6 months. My suggestion would be to */
/* create a custom sent log for these records outside of data views. */
/* https://trailhead.salesforce.com/content/learn/modules/marketing-cloud-data-management/collect-data-with-a-send-log */
select j.emailname, count(1) as unsubscribes
from [_sent] as s

inner join [_job] as j
  on j.jobid = s.jobid
  and j.emailname = "2025 Q3 Quarterly Newsletter"

/* Leaving out the list id and batch as the use of isUnique should suffice for a specific send. */
/* The use of list id and batch id will be used later for accuracy on aggregate logging. */
inner join [_unsubscribe] as u
  on u.subscriberkey = s.subscriberkey
  and u.jobid = j.jobid
  and u.isunique = 1

group by j.emailname