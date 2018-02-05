

--特定cc手中的leads是否是tmk转出，以及该leads的状态，实时反映咨询师手中资源状态
-- CRM pgsql
-- leader-student中，特定的学生与特定的咨询师一般只存在一条记录
-- 
select distinct l.student_id, 
       o.phone as tel, 
       a.last_name,
       a.region,
       l.user_id,
       date(l.created_time),
       case 
       when l.status = 0 then '结案'
       when l.status = 1 then '绑定'
       else '解绑'
       end as leads,
       case when l.student_id in (select distinct student_id from tmk_confirm where  is_issued = 'true') then 'TMK转出'
       else 'NOT_TMK'
       end as TMK
from leader_student l
left join ocean o on o.id =l.student_id
join account_user a on a.id = l.user_id
where l.user_id in (166,207,212,189,213)
and date(l.created_time) between '2018-01-28' and '2018-01-30'


