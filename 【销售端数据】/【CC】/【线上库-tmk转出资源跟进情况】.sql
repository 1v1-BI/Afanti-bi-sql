
TMK转出后cc的跟进情况
with tmk_out as (select t.student_id, t.tmk_id, t.created_time ,t.start_time  
from tmk_confirm t 
where date(t.created_time) >= '2018-01-01' and date(t.created_time) < '2018-01-31') 


select a.username ,m.called_stu  as 拨打学生数,
 m.call_num as 拨打总数, 
 m.call_succ as 接通数,
 k.success_stu as 接通学生数
from 
(select c1.created_by,     
count(distinct c1.student_id) as called_stu,
count(c1.id) as call_num, 
sum(case when (c1.tianrun_info->>'status')::int = 28 then 1 else 0 end)as call_succ
from comm_records c1 join tmk_out t1 on c1.student_id = t1.student_id
where c1.creator_role = 'cc'
and c1.student_id in (select student_id from tmk_out)
and date(c1.created_time) >= '2018-01-01' and date(c1.created_time) <= '2018-01-31'
group by c1.created_by) as m 
left join 
(select c.created_by, 
count(distinct c.student_id) as success_stu
from comm_records c join tmk_out t on t.student_id = c.student_id
where (c.tianrun_info->>'status')::int =28 
and c.creator_role = 'cc'
and date(c.created_time) >='2018-01-01' and date(c.created_time)<='2018-01-31'
group by c.created_by ) as k on m.created_by = k.created_by
left join account_user a on m.created_by = a.id 
group by a.username ,m.called_stu,m.call_num ,m.call_succ ,k.success_stu


