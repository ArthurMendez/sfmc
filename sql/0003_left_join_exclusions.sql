/**************************************************************************
* Filename:   0003_left_join_exclusions.sql
* Author:     Arthur Mendez
* Copyright:  (C) 2025 Arthur Mendez III <hello@amendez.dev>
* Licenses:   Apache v2.0 https://www.apache.org/licenses/LICENSE-2.0.txt
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    
**************************************************************************/

/* The standard left join exclusionary check */
select a.subscriberkey, a.emailaddress, a.first_name, a.last_name, a.mobile
from [senable_audience] as a

left join [exclusionary data] as b
  on b.emailaddress = a.emailaddress

where b.emailaddress is null



/* Multiple exclusionary checks */
select a.subscriberkey, a.emailaddress, a.first_name, a.last_name, a.mobile
from [senable_audience] as a

left join [exclusionary data] as b
  on b.emailaddress = a.emailaddress

left join (
  select distinct emailaddress
  from [send log]
  where campaign_name = 'Q3 2025 Seasonal Campaign'
) as log_a
  on log_a.emailaddress = a.emailaddress

left join (
  select emailaddress
  from [2025_Q1_Newsletter]
) as log_b
  on log_b.emailaddress = a.emailaddress

where b.emailaddress is null
and log_a.emailaddress is null
and log_b.emailaddress is null
/* Additionally a COALESCE() can be used to gather theese null checks in one line. */
/* Note that COALESCE() returns the first non-null value. */
/* and coalesce(b.emailaddress, log_a.emailaddress, log_b.emailaddress) is null */



/* Data Views exclusions */
select a.subscriberkey, a.emailaddress, a.first_name, a.last_name, a.mobile
from [senable_audience] as a

/* This will exclude any subscribers that have a status of Held or Unsubscribed, while taking in net new */
left join [_subscribers] as s
  on s.subscriberkey = a.subscriberkey
  and s.status in ('held', 'unsubscribed')

where s.subscriberkey is null