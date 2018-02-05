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

资源维度-城市
select result.city, result.all_student,result.call_student,result.demo_student,result.pay_student,
(result.pay_student::numeric/result.all_student::numeric)
from (
(select (o.base_info->>'city')::varchar as city,count(distinct o.id) as all_student
from ocean o 
group by (o.base_info->>'city')::varchar ) as k 
left join 
(select (o1.base_info->>'city')::varchar as city_call, count(distinct c.student_id) as call_student
from comm_records c left join ocean o1 on o1.id = c.student_id
group by (o1.base_info->>'city')::varchar
) as k1 on  k.city = k1.city_call
left join 
(select (o2.base_info->>'city')::varchar as city_demo, count(distinct d.student_id) as demo_student
from demo_course d left join ocean o2 on o2.id = d.student_id
where d.status = 'finished'
group by (o2.base_info->>'city')::varchar
) as k2 on k.city = k2.city_demo
left join 
(select (o3.base_info->>'city')::varchar as city_pay, count(distinct s.student_id) as pay_student
from course_order s left join ocean o3 on o3.id = s.student_id
where s.status = 'finished' 
group by (o3.base_info->>'city')::varchar
) as k3 on k.city = k3.city_pay
)as result 
order by  (result.pay_student::numeric/result.all_student::numeric) desc