--首次拨打接通率
with first_call as (select distinct c.student_id , min(c.created_time) as first_time_in  --唯一时间戳
from comm_records c 
where date(c.created_time) between '2018-01-22' and '2018-01-30'  --多加入限定，comm_records 表很大
group by c.student_id)

select date(c.created_time),                                            -- 拨打日期
count(c.id) as 外呼数,                                        
count(distinct c.student_id) as 拨打学生数, 
sum(case when (c.tianrun_info->>'status')::int = 28 then 1 else 0 end) as 接通数
from  comm_records c 
join first_call f 
on f.student_id = c.student_id
where extract(epoch from (c.created_time - f.first_time_in))= 0          -- 选定为首次
and date(c.created_time) >= '2018-01-22'
group by date(c.created_time)                                             -- 按天group by


--分等级咨询师跟进海岸资源状况

select s.level as 咨询师等级,
date(e.created_time), 
count(distinct e.student_id) as 学生ID, 
count(e.id) as 拨打总数,
sum(case when (e.tianrun_info->>'status')::int=28 then 1 else 0 end ) as 接通数,
sum(case when e.todo_category ='FLW' then 1 else 0 end ) as 待跟进,
sum(case when e.todo_category ='CLS' then 1 else 0 end ) as 结案
from comm_records e 
left join sales_level s 
on e.created_by = s.user_id
where e.student_id in 
--子查询开始，学生资源来自海岸
(select o.id 
from river r 
left join ocean o on o.phone = r.phone
where  (r.lead_info->>'grade')::bigint not in (101,102,103,104)   --非低年级
or (r.lead_info->>'city')::varchar like'%北京%'
or (r.lead_info->>'city')::varchar like'%台州%'
or (r.lead_info->>'city')::varchar like'%温州%'
or (r.lead_info->>'city')::varchar like'%佛山%'
or (r.lead_info->>'city')::varchar like'%太原%'
or (r.lead_info->>'city')::varchar like'%上海%'
or (r.lead_info->>'city')::varchar like'%广州%'
or (r.lead_info->>'city')::varchar like'%深圳%'
or (r.lead_info->>'city')::varchar like '%成都%'
or (r.lead_info->>'city')::varchar like'%杭州%'
or (r.lead_info->>'city')::varchar like'%武汉%'
or (r.lead_info->>'city')::varchar like'%重庆%'
or (r.lead_info->>'city')::varchar like'%南京%'
or (r.lead_info->>'city')::varchar like'%天津%'
or (r.lead_info->>'city')::varchar like'%苏州%'
or (r.lead_info->>'city')::varchar like'%西安%'
or (r.lead_info->>'city')::varchar like'%长沙%'
or (r.lead_info->>'city')::varchar like'%沈阳%'
or (r.lead_info->>'city')::varchar like'%青岛%'
or (r.lead_info->>'city')::varchar like'%郑州%'
or (r.lead_info->>'city')::varchar like'%大连%'
or (r.lead_info->>'city')::varchar like'%东莞%'
or (r.lead_info->>'city')::varchar like'%宁波%') --资源来自以上城市
 )--子查询结束
and s.level is not null
and s.level not like 'E'
and date(e.created_time) >='2017-12-01'
group by s.level,date(e.created_time)
order by date(e.created_time)


--咨询师分等级首次拨打海岸资源状况 4秒
explain analyse with 
time_range as (select ('2018-01-01')::date as time_lower_range, ('2018-01-30')::date as time_upper_range), --设置时间范围
coast_resource as (select r.phone  --海岸资源属性
from river r 
where date(r.arrival_at) between (select time_lower_range from time_range) and (select time_upper_range from time_range)
and 
  ((r.lead_info->>'grade')::bigint not in (101,102,103,104)
or (r.lead_info->>'city')::varchar like'%北京%'
or (r.lead_info->>'city')::varchar like'%台州%'
or (r.lead_info->>'city')::varchar like'%温州%'
or (r.lead_info->>'city')::varchar like'%佛山%'
or (r.lead_info->>'city')::varchar like'%太原%'
or (r.lead_info->>'city')::varchar like'%上海%'
or (r.lead_info->>'city')::varchar like'%广州%'
or (r.lead_info->>'city')::varchar like'%深圳%'
or (r.lead_info->>'city')::varchar like '%成都%'
or (r.lead_info->>'city')::varchar like'%杭州%'
or (r.lead_info->>'city')::varchar like'%武汉%'
or (r.lead_info->>'city')::varchar like'%重庆%'
or (r.lead_info->>'city')::varchar like'%南京%'
or (r.lead_info->>'city')::varchar like'%天津%'
or (r.lead_info->>'city')::varchar like'%苏州%'
or (r.lead_info->>'city')::varchar like'%西安%'
or (r.lead_info->>'city')::varchar like'%长沙%'
or (r.lead_info->>'city')::varchar like'%沈阳%'
or (r.lead_info->>'city')::varchar like'%青岛%'
or (r.lead_info->>'city')::varchar like'%郑州%'
or (r.lead_info->>'city')::varchar like'%大连%'
or (r.lead_info->>'city')::varchar like'%东莞%'
or (r.lead_info->>'city')::varchar like'%宁波%'))
)
--主体
select s.level as 咨询师等级,
date(e.created_time),
count(distinct e.student_id) as 学生ID, 
count(e.id) as 拨打总数,
sum(case when (e.tianrun_info->>'status')::int=28 then 1 else 0 end ) as 接通数,
sum(case when e.todo_category ='FLW' then 1 else 0 end ) as 待跟进,
sum(case when e.todo_category ='CLS' then 1 else 0 end ) as 结案
from comm_records e join 
(select distinct c.student_id, min(c.created_time) as first_time_in 
from comm_records c 
where (c.tianrun_info->>'customer_number')::varchar in (select phone from coast_resource)
group by c.student_id 
 ) as k on k .student_id = e.student_id 
left join sales_level s on s.user_id = e.created_by
where k.first_time_in = e.created_time
and date(e.created_time)between (select time_lower_range from time_range) and (select time_upper_range from time_range)
and s.level is not null 
and s.level not like 'E'
group by s.level , date(e.created_time)
order by date(e.created_time)




--咨询师分等级首次拨打海岸资源状况 4秒
with 
time_range as (select ('2018-01-01')::date as time_lower_range, ('2018-01-30')::date as time_upper_range), --设置时间范围
coast_resource as (select r.phone  --海岸资源属性
from river r 
where date(r.arrival_at) between (select time_lower_range from time_range) and (select time_upper_range from time_range)  
and 
  ((r.lead_info->>'grade')::bigint not in (101,102,103,104)
or (r.lead_info->>'city')::varchar like'%北京%'
or (r.lead_info->>'city')::varchar like'%台州%'
or (r.lead_info->>'city')::varchar like'%温州%'
or (r.lead_info->>'city')::varchar like'%佛山%'
or (r.lead_info->>'city')::varchar like'%太原%'
or (r.lead_info->>'city')::varchar like'%上海%'
or (r.lead_info->>'city')::varchar like'%广州%'
or (r.lead_info->>'city')::varchar like'%深圳%'
or (r.lead_info->>'city')::varchar like '%成都%'
or (r.lead_info->>'city')::varchar like'%杭州%'
or (r.lead_info->>'city')::varchar like'%武汉%'
or (r.lead_info->>'city')::varchar like'%重庆%'
or (r.lead_info->>'city')::varchar like'%南京%'
or (r.lead_info->>'city')::varchar like'%天津%'
or (r.lead_info->>'city')::varchar like'%苏州%'
or (r.lead_info->>'city')::varchar like'%西安%'
or (r.lead_info->>'city')::varchar like'%长沙%'
or (r.lead_info->>'city')::varchar like'%沈阳%'
or (r.lead_info->>'city')::varchar like'%青岛%'
or (r.lead_info->>'city')::varchar like'%郑州%'
or (r.lead_info->>'city')::varchar like'%大连%'
or (r.lead_info->>'city')::varchar like'%东莞%'
or (r.lead_info->>'city')::varchar like'%宁波%') --限定日期内的特定资源
),
--首次拨打，大表请多加限定
first_call as (select distinct c.student_id, min(c.created_time) as first_time_in 
from comm_records c 
where (c.tianrun_info->>'customer_number')::varchar in (select phone from coast_resource)
--限定范围内，
group by c.student_id
having min(c.created_time) between (select time_lower_range from time_range) and (select time_upper_range from time_range) ) --引用时间范围

--主体
select s.level as 咨询师等级,date(e.created_time), count(distinct e.student_id) as 学生ID, count(e.id) as 拨打总数,
      sum(case when (e.tianrun_info->>'status')::int=28 then 1 else 0 end ) as 接通数,
      sum(case when e.todo_category ='FLW' then 1 else 0 end ) as 待跟进,
      sum(case when e.todo_category ='CLS' then 1 else 0 end ) as 结案
from comm_records e join first_call f on f.student_id = e.student_id
left join sales_level s on e.created_by = s.user_id
where e.created_time = f.first_time_in
and s.level is not null 
and s.level not like 'E'
group by s.level, date(e.created_time)
order by date(e.created_time)

