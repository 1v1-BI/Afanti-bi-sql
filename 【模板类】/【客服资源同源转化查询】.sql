with tmk_move as (
      select distinct t.student_id, o.phone,s.source,o.created_time as ocean_time,t.created_time 
      from comm_records t left join ocean o on o.id = t.student_id
      left join source_channel_campaign s on (o.extend_info::json#>>'{channels,-1}')::int = s.channel_id 
      where s.source like '%娄底%'
      )

select m.student_id,m.phone,m.source,m.last_name,m.creator_role,
to_char(m.最近拨打时间, 'YYYY-MM-DD HH24:MI'),
m.总跟进次数,
m.接通数,
m.未接通数,
m.无效数,
m.坐席未接通数,
t2.student_id,
t2.last_name,
to_char(t2.最近试听课时间,'YYYY-MM-DD HH24:MI'),
t2.试听课总数,
t2.试听课完成数,
t2.试听排课失败,
t2.未出席数,
t2.试听课取消数,
t2.试听准备,
t2.待出席,
o.student_id,
o.last_name,
to_char(o.最近支付时间, 'YYYY-MM-DD HH24:MI'),
o.完成订单,
o.未完成订单数,
o.失败订单数,
o.总金额
from 
(select distinct a.student_id,t.phone,t.source, a.created_by,u.last_name,a.creator_role,
       count(a.id) AS 总跟进次数,
       max(a.created_time) as 最近拨打时间,
       sum(case when (a.tianrun_info::json->>'status'):: bigint =21 then 1 else 0 end ) as 未接通数,
       sum(case when (a.tianrun_info::json->>'status'):: bigint =22 then 1 else 0 end ) as 无效数,
       sum(case when (a.tianrun_info::json->>'status'):: bigint =24 then 1 else 0 end ) as 坐席未接通数,
       sum(case when (a.tianrun_info::json->>'status'):: bigint =28 then 1 else 0 end ) as 接通数
from  comm_records a join tmk_move t on t.student_id = a.student_id
join account_user u on a.created_by = u.id 
where a.student_id in (select student_id from tmk_move)
   
group by a.student_id,a.created_by,u.last_name,a.creator_role,t.source,t.phone) as m
left join 
(select  distinct d.student_id,a2.last_name,d.created_by,
  max(case when d.status = 'finished' then d.created_time else null end) as 最近试听课时间, 
  count(d.id) as 试听课总数,
  sum(case when d.status='finished' then 1 else 0 end ) as 试听课完成数,
  sum(case when d.status='pre_err' then 1 else 0 end ) as 试听排课失败,
  sum(case when d.status='not_go' then 1 else 0 end ) as 未出席数,
  sum(case when d.status='canceled' then 1 else 0 end ) as 试听课取消数,
  sum(case when d.status= 'preparin' then 1 else 0 end) as 试听准备,
  sum(case when d.status= 'prepared' then 1 else 0 end) as 待出席
from demo_course d left join account_user a2 on a2.id = d.created_by 
group by d.student_id,a2.last_name,d.created_by) as t2 on t2.student_id = m.student_id and m.created_by =t2.created_by
left join 
(select distinct c.student_id, a.last_name,c.created_by,
  max(case when c.status = 'finished' then c.created_time else null end) as 最近支付时间,
  sum(case when c.status ='finished' then 1 else 0 end) as 完成订单,
  sum(case when c.status = 'unfinished' then 1 else 0 end ) as 未完成订单数,
  sum(case when c.status = 'failed' then 1 else 0 end) as 失败订单数,
  sum(case when c.status = 'finished' then c.amount/100 else 0 end )as 总金额

from course_order c left join account_user a on a.id = c.created_by
group by c.student_id,c.created_by,a.last_name) as o
on m.student_id = o.student_id and o.created_by = m.created_by
where m.last_name not like ''
order by m.student_id,to_char(m.最近拨打时间, 'YYYY-MM-DD HH24:MI')





