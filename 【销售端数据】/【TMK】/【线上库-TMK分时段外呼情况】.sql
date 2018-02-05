
tmk 1月接通率字段 日期 时段 呼出总数 接通总数 平均通话时长 胡呼出用户数 参与咨询师 接通率
select date(c.created_time),
extract(hour from c.created_time) as 时段,
count(c.id) as 外呼数,
sum(case when (tianrun_info->>'status')::int = 28 then 1 else 0 end ) as 接通数,
avg(case when (tianrun_info->>'status')::int =28 
then ((tianrun_info->>'end_time')::bigint -(tianrun_info->>'start_time')::bigint)
else null end) as 通话时长,
count(distinct c.student_id)as 呼出用户数, count(distinct c.created_by) as 参与咨询师
from comm_records c left join account_user a on c.created_by = a.id 
where a.region = 'TMK'
and extract(hour from c.created_time)::int >= 9 and extract(hour from c.created_time)::int < 23
and date(c.created_time) >= '2018-01-01'
group by date(c.created_time),extract(hour from c.created_time)
order by date(c.created_time)
