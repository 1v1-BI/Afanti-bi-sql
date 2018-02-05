--特定组调研
--新人 接通学生数
select date(c.created_time),a.last_name,count(c.id) as 外呼数, count(distinct c.student_id) as 外呼用户数,
sum(case when (c.tianrun_info->>'status')::int=28 then 1 else 0 end)as 接通数
from comm_records c left join account_user a on c.created_by = a.id
where date(c.created_time) >= '2017-12-01'
  and a.last_name in ('王树') --此处添加咨询师姓名
group by date(c.created_time),a.last_name
order by date(c.created_time)

--新人资源分布   具体到渠道
select a.last_name, date(c.created_time),s.name, count(distinct c.student_id)
from comm_records c left join ocean o on o.id = c.student_id 
left join account_user a on c.created_by = a.id
left join channel s on (extend_info::json#>>'{channels, -1}') ::bigint = s.id 
where date(c.created_time) >= '2017-12-01'
and a.last_name in ('王树') --此处添加咨询师姓名
group by a.last_name, date(c.created_time),s.name
order by date(c.created_time)


--新人资源分布  渠道分等级


--新人资源是否tmk转出
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
where u.last_name in ('王树') --此处添加咨询师姓名
    and c.student_id in 
                  (select t.student_id from tmk_confirm t
                          where t.is_issued = 'true'
                            and date(t.created_time)>= '2017-12-01')
group by u.last_name)
as m
join (select u2.last_name, count(c1.id) as not_tmk, count(distinct c1.student_id) as not_tmk_leads
from comm_records c1 join account_user u2 on c1.created_by = u2.id
where u2.last_name in ('王树') --此处添加咨询师姓名
    and c1.student_id not in 
                      (select t1.student_id from tmk_confirm t1
                          where t1.is_issued = 'true'
                            and date(t1.created_time)>= '2017-12-01')
     group by u2.last_name) as k
on m.last_name = k.last_name