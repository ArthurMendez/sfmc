/**************************************************************************
* Filename:   0008_dataviews_unsub.sql
* Author:     Arthur Mendez
* Copyright:  (C) 2025 Arthur Mendez III <yo@rthur.dev>
* Licenses:   Apache v2.0 https://www.apache.org/licenses/LICENSE-2.0.txt
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    Unsubscribe logging through data views.
              For your data views reference: https://dataviews.io
**************************************************************************/

/* A standard email unsubscribe count. */
/* Leaving out the list id and batch as the use of isUnique should suffice for a specific send. */
/* The use of list id and batch id will be used later for accuracy on aggregate logging. */
select j.emailname, count(1) as unsubscribes
from [_unsubscribe] as u

inner join [_job] as j
  on j.jobid = u.jobid
  and j.emailname = "2025 Q3 Quarterly Newsletter"

where u.isunique = 1
group by j.emailname