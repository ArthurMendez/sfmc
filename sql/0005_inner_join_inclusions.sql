/**************************************************************************
* Filename:   0004_inner_joins.sql
* Author:     Arthur Mendez
* Copyright:  (C) 2025 Arthur Mendez III <hello@amendez.dev>
* Licenses:   Apache v2.0 https://www.apache.org/licenses/LICENSE-2.0.txt
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    Some uses cases for inner joins.
**************************************************************************/

/* Standard use of an inner join. In this piece of code there will be the short */
/* hand use of inner join, just so you know that it's ok to use short hand. */
/* Moving forward with all queries - the long hand version will be in use for readablility. */
select a.subscriberkey, a.emailaddress, a.first_name
, org.name as [Org Name]
from [member_data] as a

join [member_org] as org
  on org.name = a.org_name


/* Additional filters in the inner join. Notice the dates being processed last. */
select a.subscriberkey, a.emailaddress, a.first_name
, a.org_name
from [member_data] as a

inner join [member_org] as org
  on org.name = a.org_name
  and org.state = 'california'
  and datediff(year, org.created_ts, getdate()) = 0

where a.emailaddress is not null
and datediff(year, a.dob, getdate()) >= 18



/* Sub-Select use case with some data views excluding anyone that does not have an active */
/* subscriber status. */
select a.subscriberkey, a.emailaddress, a.first_name
, a.org_name
from [member_data] as a

inner join [member_org] as org
  on org.name = a.org_name
  and org.active = 1 /* T-SQL can take either 1 / 0 or True / False for boolean fields in data extensions. */

/* The target audience can be strict by including the _subscribers data view for count */
/* accuracy. Some individuals like the numbers being reported for QA / UAT to be as accurate as */
/* possible. Also no need to worry if this isn't included and those subscribers make their way into the segmentation */
/* as nothing will be sent out of marketing cloud with an unsubscribed or held status. */
inner join [_subscribers] as s 
  on s.subscriberkey = a.subscriberkey
  and s.status = 'active'

/* Here a sub-select is being used as an inner join to get distinct subscriber keys that have campaign */
/* names starting with promotions. */
inner join (
  select disinct subscriberkey
  from [send logs]
  where campaign like 'promotions%'
) as log
  on log.subscriberkey = a.subscriberkey