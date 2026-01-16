/**************************************************************************
* Filename:   0013_window_functions.sql
* Author:     Arthur Mendez
* Copyright:  (C) 2026 Arthur Mendez III <hello@amendez.dev>
* Licenses:   Apache v2.0 https://www.apache.org/licenses/LICENSE-2.0.txt
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    Further explanation of Window Functions, their uses, and
              differentiating between the others. Consider this sql
              as part two of 0004_row_numbers.sql.
**************************************************************************/


/* To breifly explain window functions in sql - think of them as groups per */
/* select row. Initially in 0004_row_numbers.sql the row_number() window */
/* function was explained, and for the most part as a developer in sfmc - you */
/* will be using that function 99% of the time. This sql will go over two others. */



/* RANK(): Assigns a rank to select rows and will output identical ranks with same */
/* partiion by values. Rank() will simultaneously increment all group rank values for */
/* rows not sharing the same rank. To clear the confusion, example data is provided. */
select a.subscriberkey, a.score
, rank() over(partition by a.subscriberkey, a.score order by a.score desc) as rank
from [triggered_send_log] as a

/* Results ****************************************************************
-------------------------------------+------------+------------
 SubscriberKey:                      | Score:     | Rank:
-------------------------------------+------------+------------
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 100        | 1
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 95         | 2
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 80         | 3
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 80         | 3
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 80         | 3
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 64         | 6
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 32         | 7
**************************************************************************/



/* DENSE_RANK(): This function does not take into respect the same partition by */
/* group incremental values. If the same partition by group has a rank of 5, then */
/* the non-same value rank will be the current partition by same rank + 1. */
/* To clear the confusion, example data is provided. */
select a.subscriberkey, a.score
, dense_rank() over(partition by a.subscriberkey, a.score order by a.score desc) as rank
from [triggered_send_log] as a

/* Results ****************************************************************
-------------------------------------+------------+------------
 SubscriberKey:                      | Score:     | Rank:
-------------------------------------+------------+------------
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 100        | 1
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 95         | 2
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 80         | 3
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 80         | 3
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 80         | 3
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 64         | 4
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 32         | 5
**************************************************************************/


/* Below is a comparison of the output data above with row_number(), */
/* rank(), and dense_rank(). */
/* Comparison ****************************************************************
-------------------------------------+------------+-----------------+------------+-----------------
 SubscriberKey:                      | Score:     | ROW_NUMBER():   | RANK():    | DENSE_RANK():   
-------------------------------------+------------+-----------------+------------+-----------------
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 100        | 1               | 1          | 1
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 95         | 2               | 2          | 2
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 80         | 3               | 3          | 3
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 80         | 4               | 3          | 3
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 80         | 5               | 3          | 3
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 64         | 6               | 6          | 4
6C59EA70-B5A9-4BA9-971F-443FE5BF2366 | 32         | 7               | 7          | 5
*****************************************************************************/