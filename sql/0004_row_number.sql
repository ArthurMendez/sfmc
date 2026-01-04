/**************************************************************************
* Filename:   0003_row_number.sql
* Author:     Arthur Mendez
* Copyright:  (C) 2025 Arthur Mendez III <hello@amendez.dev>
* Licenses:   Apache v2.0 https://www.apache.org/licenses/LICENSE-2.0.txt
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    How and when to use row numbers in the SELECT to remove
              duplicates or single duplicate rows in data extension.
**************************************************************************/

/* The standard ROW_NUMBER() use case, which can be implemented to filter out */
/* rows where there are duplicate subscribers in a data extenion. A subselect */
/* is safe to use in the form without impacting performance. */
select a.subscriberkey, a.emailaddress, a.mobile, a.entry_timestamp
from (
  select subscriberkey, emailaddress, mobile, entry_timestamp
  /* Below the starting number 1 would be the most recent date by using DESC */
  , row_number() over(partition by subscriberkey order by entry_timestamp desc) as rownum
  from [2025 holiday campaigns log]
) as a
where a.rownum = 1



/* A use case where a telemarketing segmentation list is built out, but with */
/* the requirement of only including people with fewer than three calls in */
/* a given year. */
select a.subscriberkey, a.emailaddress, a.mobile
, a.first_name, a.last_name
from [2025 holiday outreach phone campaign] as a

left join (
  select mobile
  , row_number() over(partition by mobile order by entry_timestamp desc) as rownum
  from [marketing_call_logs]
  where datediff(year, entry_timestamp, getdate()) = 0 /* Only entries in the last year */
) as call_log
  on call_log.mobile = a.mobile
  and call_log.rownum = 3

where call_log.mobile is null