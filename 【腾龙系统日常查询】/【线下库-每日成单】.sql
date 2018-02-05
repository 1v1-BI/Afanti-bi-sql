--学生属性明细
select distinct o.phone,
to_char(to_timestamp((d.info->>'start_time')::bigint),'YYYY-MM-DD HH24:MI')  as demo_course_start_time,
(d.info->>'apply_tutor_id')::varchar as apply_tutor_id,
(d.info->>'province')::varchar as province,
(d.info->>'city')::varchar as city,
(d.info->>'grade')::int as grade,
(d.info->>'teacher_age')::varchar as teacher_age,
(d.info->>'school_level')::varchar as school_level,
(d.info->>'teacher_requirement')::varchar as teacher_requirement,
(d.info->>'device')::varchar as device,
(d.info->>'teacher_level')::varchar as teacher_level,
(d.info->>'eidition')::varchar as eidition,
(d.info->>'study_level')::varchar as study_level,
(d.info->>'tutor_subject')::varchar as tutor_subject,
(d.info->>'demo_course_content')::varchar as content
from demo_course d join ocean o on o.id = d.student_id
where d.status = 'finished'
and o.phone::bigint  not in (10000000077, 10000000078,    
10000000079,10000000080, 10000000081,
10000000082,10000000083,10000000084,    
10000000085,10000000086,10000000087,10000000088,10000000089)




# 每日成单
select tel_num, 
source, 
from_unixtime(create_time) as source_time, 
from_unixtime(order_time) as order_time, 
planner_name, 
money, 
original_money, 
lesson_num, 
student_subject, 
student_grade, 
note, 
max(result_table.create_time) 
from 
(
select *
from 
(select u.`telephone_num` as tel_num, 
	u.province as student_province,
	u.city as student_city,
	s.planner_name, 
	s.amount/100 as money, 
	case when s.grade =1 then '一年级'
	     when s.grade =2 then '二年级'
	     when s.grade =3 then '三年级'
	     when s.grade =4 then '四年级'
	     when s.grade =5 then '五年级'
	     when s.grade =6 then '六年级'
	     when s.grade =7 then '初一'
	     when s.grade =8 then '初二'
	     when s.grade =9 then '初三'
	     when s.grade =10 then '小学'
	     when s.grade =11 then '高一'
	     when s.grade =12 then '高二'
	     when s.grade =13 then '高三'
	     when s.grade =101 then '一年级'
	     when s.grade =102 then '二年级'
	     when s.grade =103 then '三年级'
	     when s.grade =104 then '四年级'
	     when s.grade =105 then '五年级'
	     when s.grade =106 then  '六年级'
	     else '其他'
	     end as student_grade,
		c.subject,
	s.original_amount/100 as original_money, 
	s.lesson_num, s.`update_time` as order_time, 
	s.note
from series_order s 
left join  user_online u
on u.`user_id` = s.`student_user_id` 
where s.status ='SUCCESS' 
and  s.amount/100>100  
and from_unixtime(s.update_time)  >= '2018-01-09'
and from_unixtime(s.update_time)  < '2018-02-28'
) 
order_table
left join crm_form_record c
on order_table.tel_num = c.`telephone_number` 
and order_table.order_time > c.create_time
# where crm_form_record.`telephone_number` != 'NULL'
# group by crm_form_record.source, crm_form_record.create_time
order by c.create_time desc  # 使用desc是最后一个渠道，不适用desc是第一个渠道
# order by order_table.order_time desc
) 
as result_table
group by result_table.tel_num, result_table.order_time
order by result_table.order_time desc





select tel_num, source, from_unixtime(create_time) as source_time, 
from_unixtime(order_time) as order_time, 
planner_name, money, original_money, 
lesson_num, subject, grade, note, 
max(result_table.create_time) 
from 
(
select *
from 
(select user_online.`telephone_num` as tel_num, 
	series_order.planner_name, 
	series_order.amount/100 as money, 
	series_order.original_amount/100 as original_money, 
	series_order.lesson_num, series_order.`update_time` as order_time, 
	series_order.note

from  user_online 
left join series_order 
on user_online.`user_id` = series_order.`student_user_id` where series_order.status ='SUCCESS' and  series_order.amount/100>100  and from_unixtime(series_order.update_time)  >= '2017-12-09'
and 
 from_unixtime(series_order.update_time)  < '2017-12-28') order_table
left join
crm_form_record 
on order_table.tel_num = crm_form_record.`telephone_number` and order_table.order_time > crm_form_record.create_time
# where crm_form_record.`telephone_number` != 'NULL'
# group by crm_form_record.source, crm_form_record.create_time
order by crm_form_record.create_time desc  # 使用desc是最后一个渠道，不适用desc是第一个渠道
# order by order_table.order_time desc
) 
as result_table
group by result_table.tel_num, result_table.order_time
order by result_table.order_time desc