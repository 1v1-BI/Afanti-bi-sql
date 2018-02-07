--cc-level 线上库
--BI数据/CC-LEVEL/CC-LEVEL
select date(e.created_time),
	   e.created_by, 
	   a.last_name,
	   a.region,
	   s.level as 咨询师等级,
       sum(case when c.level = 'A' then 1 else 0 end) as A级资源,
       sum(case when c.level = 'B' then 1 else 0 end) as B级资源,
       sum(case when c.level = 'C' then 1 else 0 end) as C级资源,
       sum(case when c.level = 'D' then 1 else 0 end) as D级资源,
       sum(case when c.level = 'E' then 1 else 0 end) as E级资源,
       sum(case when (e.tianrun_info->>'status')::int =28 then 1 else 0 end) as 接通数,
       sum(case when (e.tianrun_info->>'status')::int =21 then 1 else 0 end) as 未接通,
       sum(case when (e.tianrun_info->>'status')::int = 22 then 1 else 0 end) as 无效数,
       sum(case when (e.tianrun_info->>'status')::int= 24 then 1 else 0 end) as 坐席未接通数,
       sum(case when e.todo_category = 'FLW' then 1 else 0 end) as 待跟进,
       sum(case when e.todo_category = 'ORD' then 1 else 0 end) as 欲成单,
       sum(case when e.todo_category = 'DEM' then 1 else 0 end) as 欲试听,
       sum(case when e.todo_category = 'TCF' then 1 else 0 end) as 转出,
       sum(case when e.todo_category = 'CLS' then 1 else 0 end) as 结案,
       sum(case when e.todo_category = 'NTH' then 1 else 0 end) as 未填写
FROM ocean o join channel c on (extend_info::json#>>'{channels,-1}')::bigint = c.id
right join 
comm_records e on o.id =  e.student_id
join account_user a on e.created_by = a.id
left join sales_level s on s.user_id = a.id
where date(e.created_time) >= '2017-12-28'
   and date(e.created_time) < '2017-12-30'
   and a.region not like '%学管师%'
   and a.region not like '%排课中心%'
   and a.region not like '%设备%'
   and a.region not like  '%离职%'
   and a.region not like '%TMK%'
group by date(e.created_time),e.created_by,a.last_name,a.region,s.level
order by date(e.created_time)


