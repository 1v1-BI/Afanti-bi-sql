--测试组是否tmk资源分布

select m.last_name as 咨询师 ,
       m.tmk_num as tmk转出拨打数, 
       k.not_tmk as 非tmk转出拨打数,
       m.tmk_leads as tmk学生,
       k.not_tmk_leads as 非tmk资源,
       round(m.tmk_num::numeric/m.tmk_leads::numeric,2) as tmk_avg, 
       round(k.not_tmk::numeric/k.not_tmk_leads::numeric,2) as not_tmk_avg 
from 
(select u.last_name , count(c.id) as tmk_num, count(distinct c.student_id) as tmk_leads
from comm_records c join account_user u on c.created_by = u.id 
where c.created_by in (164,165,188,159,158)
    and c.student_id in 
                  (select t.student_id from tmk_confirm t
                          where t.is_issued = 'true'
                            and date(t.created_time)>= '2017-12-01')
group by u.last_name)
as m
join (select u2.last_name, count(c1.id) as not_tmk, count(distinct c1.student_id) as not_tmk_leads
from comm_records c1 join account_user u2 on c1.created_by = u2.id
where c1.created_by in (164,165,188,159,158) --此处更改测试组int
    and c1.student_id not in 
                      (select t1.student_id from tmk_confirm t1
                          where t1.is_issued = 'true'
                            and date(t1.created_time)>= '2017-12-01')
     group by u2.last_name) as k
on m.last_name = k.last_name