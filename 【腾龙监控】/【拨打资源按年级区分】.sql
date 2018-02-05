--公海进入资源按年级划分



select  date(o.created_time), 
sum(case when (o.base_info->>'grade')::varchar = '0' 
	or (o.base_info->>'grade')::varchar = ' ' then 1 else 0 end) as 其他,
sum(case when (o.base_info->>'grade')::varchar = '1' 
	or (o.base_info->>'grade')::varchar = '101' then 1 else 0 end) as 一年级,
sum(case when (o.base_info->>'grade')::varchar = '2' 
	or (o.base_info->>'grade')::varchar = '102' then 1 else 0 end) as 二年级,
sum(case when (o.base_info->>'grade')::varchar = '3' 
	or (o.base_info->>'grade')::varchar = '103' then 1 else 0 end) as 三年级,
sum(case when (o.base_info->>'grade')::varchar = '4' 
	or (o.base_info->>'grade')::varchar = '104' then 1 else 0 end) as 四年级,
sum(case when (o.base_info->>'grade')::varchar = '5' 
	or (o.base_info->>'grade')::varchar = '105' then 1 else 0 end) as 五年级,
sum(case when (o.base_info->>'grade')::varchar = '6' 
	or (o.base_info->>'grade')::varchar = '106' then 1 else 0 end) as 六年级,
sum(case when (o.base_info->>'grade')::varchar = '10' then 1 else 0 end) as 小学,
sum(case when (o.base_info->>'grade')::varchar = '7' then 1 else 0 end) as 初一,
sum(case when (o.base_info->>'grade')::varchar = '8' then 1 else 0 end) as 初二,
sum(case when (o.base_info->>'grade')::varchar = '9' then 1 else 0 end) as 初三,
sum(case when (o.base_info->>'grade')::varchar = '11' then 1 else 0 end) as 高一,
sum(case when (o.base_info->>'grade')::varchar = '12' then 1 else 0 end) as 高二,
sum(case when (o.base_info->>'grade')::varchar = '13' then 1 else 0 end) as 高三
from ocean o 
where date(o.created_time) >='2017-12-01'
group by date(o.created_time)


--
--高年级资源每日被
select k.time_in , m.level, count(distinct c.student_id)
from comm_records c
join  (select distinct o.id,date(o.created_time) as time_in 
from ocean o where (o.base_info->>'grade')::varchar in ('7','8','9','11','12','13')) as k on c.student_id = k.id
left join (select a.id as id , s.level as level from  account_user a join sales_level s on s.user_id = a.id )as m on m.id = c.created_by
where date(k.time_in) >= '2018-01-01'
group by k.time_in , m.level 

--咨询师按等级，拨打年级分布
select u.level,date(c.created_time), count(k.jr_student)as 小学,
 count(m.ser_student)as 初中,
 count(p.high_student)as 高中,
 count(n.others) as 其他
from comm_records c 
left  join (select o.id as jr_student
from ocean o 
where 
(o.base_info->>'grade')::varchar in ('1','2','3','4','5','6','10','101','102','103','104','105','106')) as k on k.jr_student = c.student_id 
left  join (select o1.id as ser_student 
from ocean o1 
where (o1.base_info->>'grade')::varchar in ('7','8','9')) as m on m.ser_student = c.student_id
left  join (select o2.id as high_student 
from ocean o2 where (o2.base_info->>'grade')::varchar in ('11','12','13')) as p on p.high_student = c.student_id
left join (select o3.id as others
from ocean o3 where (o3.base_info->>'grade')::varchar in (' ','0')) as n on n.others = c.student_id
left join (select a.id as id , s.level as level from  account_user a join sales_level s on s.user_id = a.id ) as u 
on u.id = c.created_by
where date(c.created_time)>='2018-01-01'
and u.level is not null
group by u.level , date(c.created_time)
order by date(c.created_time)