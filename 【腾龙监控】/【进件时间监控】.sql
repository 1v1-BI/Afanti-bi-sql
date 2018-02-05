--cc进件时效 逻辑：成单时间到application的created_time
--进件时间是否超过12小时
select k.username,  
    k.region, 
    count(distinct k.order_id) as 成单数,
    count(distinct k.student_id)as 成单学生,
    count(k.ti_id) as 转出尝试, 
    count(distinct k.out_st) as 转出学生,
    sum(case when round(extract(epoch from (k.time_out-k.time_in))/43200) >12 then 1 else 0 end ) as 超过12小时,
    sum(case when round(extract(epoch from (k.time_out-k.time_in))/43200) <=12 then 1 else 0 end ) as 未超过含12小时
from 
(select u.username,
  u.region,
  c.order_id,
  c.student_id,
  a.id as ti_id, 
  a.student_id as out_st, 
  c.updated_time as time_in ,
  a.created_time as time_out,
  c.amount/100 as amount,
  c.created_by
from course_order c left join applications a on c.student_id = a.student_id 
left join account_user u on c.created_by = u.id 
where c.status = 'finished'
and date(c.updated_time) between '2017-12-01' and '2017-12-31'
and a.is_assigned = 'true'
and date(a.created_time) between '2017-12-01' and '2017-12-31'
and u.region not like '学管师'
and u.username not like 'john@lejent.com') as k
group by k.username,k.region
order by k.region

