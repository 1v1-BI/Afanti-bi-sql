 --参加试听课未成单，学生id+咨询师+试听课创建时间+最后联系时间+目前leads从属关系（true 未结案， false 结案）
select k.student_id, 
k.last_name,
k.time_demo_create as 最近试听课创建时间, --最近的试听课创建时间
k.time_last_call as 最后沟通时间,
m.status != 0  as 是否结案  --true 未结案， false 结案
from 
--试听部分开始
(select p.student_id,a.last_name,p.created_by,
to_char(max(d.created_time),'YYYY-MM-DD-HH24:MI')as time_demo_create, --最后试听课时间
to_char(p.created_time,'YYYY-MM-DD-HH24:MI')as time_last_call
from demo_course d 
left join account_user a on a.id = d.created_by 
left join 
(select c1.student_id, c1.created_time ,c1.created_by, 
extract(epoch from age(c1.created_time,mk.max_time)) as interval --最后沟通时间
from comm_records c1 
join 
(select c2.student_id,
max(c2.created_time) as max_time --最后沟通时间
from comm_records c2 
where c2.creator_role = 'cc'
group by c2.student_id) as mk 
on mk.student_id = c1.student_id
where extract(epoch from age(c1.created_time,mk.max_time)) =0 --为最后一次联系时间
and  c1.creator_role = 'cc') as p
on d.student_id = p.student_id and d.created_by = p.created_by
where d.status = 'finished'
and d.student_id not in (  --非成单用户
  select distinct c.student_id
  from course_order c 
  where c.status = 'finished')
and date(d.created_time) between '2017-12-01' and '2017-12-31' --此处更改时间
group by p.student_id,a.last_name,p.created_by,to_char(p.created_time,'YYYY-MM-DD-HH24:MI')) as k 
--试听课部分结束
right join  
--结案，绑定部分
(select l.student_id,l.user_id,l.role,l.status
from leader_student l 
where l.role = 'cc'
) as m on k.student_id = m.student_id and k.created_by = m.user_id
where k.student_id is not null


xin-12月试听未成单
第一部分试听未成单学生最后试听课创建时间+咨询师信息+学生id
select k.student_id, k.last_name,k.time_demo_create
from 
(select p.student_id,a.last_name,p.created_by,to_char(max(d.created_time),'YYYY-MM-DD-HH24:MI')as time_demo_create,
  to_char(p.created_time,'YYYY-MM-DD-HH24:MI')as time_last_call
from demo_course d left join account_user a on a.id = d.created_by 
left join 
(select c1.student_id, c1.created_time ,c1.created_by, extract(epoch from age(c1.created_time,mk.max_time)) as interval
from comm_records c1 join (select c2.student_id,max(c2.created_time) as max_time from comm_records c2 
where c2.creator_role = 'cc'
group by c2.student_id) as mk on mk.student_id = c1.student_id
 where extract(epoch from age(c1.created_time,mk.max_time)) =0 
and  c1.creator_role = 'cc')   as p on d.student_id = p.student_id and d.created_by = p.created_by
where d.status = 'finished'
and d.student_id not in (
  select distinct c.student_id
  from course_order c 
  where c.status = 'finished')
and date(d.created_time) between '2017-12-01' and '2017-12-31'
group by p.student_id,a.last_name,p.created_by,to_char(p.created_time,'YYYY-MM-DD-HH24:MI')as time_last_call) as k 
right join (
select l.student_id,l.user_id,l.role
from leader_student l 
where l.role = 'cc'
and l.status = 0 
and l.status not in (1)
and l.role 
) as m on k.student_id = m.student_id and k.created_by = m.user_id
where k.student_id is not null


某个学生最后沟通的咨询师拨打该学生的次数和接通数，新系统
select k.student_id,a.last_name,k.created_by,count(c.id),
sum(case when (tianrun_info->>'status')::int =28 then 1 else 0 end) 
from comm_records c left join account_user a on c.created_by = a.id
right join 
(select c1.student_id, c1.created_time ,c1.created_by, extract(epoch from age(c1.created_time,mk.max_time)) as interval
from comm_records c1 join (select c2.student_id,max(c2.created_time) as max_time from comm_records c2 
where c2.creator_role = 'cc'
and c2.student_id in ('5d78XqQBi98',
'5dskcwxN5f7',
'5dtdxQ4ZfG2',
'5fVGhEyhe54',
'5gETaHz2XJy')# 加入学生id
group by c2.student_id) as mk on mk.student_id = c1.student_id
 where extract(epoch from age(c1.created_time,mk.max_time)
  ) =0 
and  c1.creator_role = 'cc')  as k on k.student_id = c.student_id and c.created_by = k.created_by
group by k.student_id,k.created_by,a.last_name

已知学生看转手次数，新系统
select t.student_id, count(t.id)-1 from leader_student
where t.student_id in ()    