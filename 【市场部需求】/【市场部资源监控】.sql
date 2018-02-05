with source as (select o.id, s.source,o.phone,o.created_time 
	from ocean o 
	join  source_channel_campaign s on s.channel_id = (extend_info::json#>>'{channels, -1}') ::int 
	where s.source like '%娄底%')  --输入监控资源
	and date(o.created_time)>= '2018-01-05'),--限定时间源头
	first_call as (select c.student_id ,min(c.created_time) as first_time_in, c.created_by
	from comm_records c 
	where c.student_id in (select id from source)
	group by c.student_id,c.created_by)


select m.phone as tel, 
m.last_name as 咨询师, 
m.source as 资源, --最后进入的资源
m.资源进入时间, 
m.首次拨打时间, 
m.外呼数, 
m.接通数, 
k.last_name, --再次加入咨询师 可省略
to_char(k.last_demo,'YYYY-MM-DD HH24:MI')as 最后试听课时间,
 k.demo_num as 试听课数量,
k1.last_name as 成单咨询师,
to_char(k1.last_pay,'YYYY-MM-DD HH24:MI') as 最后支付时间,
k1.order_num as 成单数, 
k1.amount_total 总金额,
m.content::json
from
--part1 外呼数据， 用户电话，咨询师，资源，时间，外呼数，接通数
(select s.phone, --方便查询
a.last_name,
s.source,
c.student_id,
c.created_by, --咨询师id
to_char(s.created_time,'YYYY-MM-DD HH24:MI') as 资源进入时间,
to_char(f1.first_time_in,'YYYY-MM-DD HH24:MI') as 首次拨打时间, 
c.content,
count(c.id) as 外呼数,
sum(case when (c.tianrun_info->>'status')::int = 28 then 1 else 0 end)as 接通数
from source s 
left join  comm_records c 
on s.id= c.student_id 
left join first_call f1 
on f1.student_id = c.student_id and f1.created_by = c.created_by
left join account_user a on a.id = c.created_by
where f1.first_time_in >= s.created_time --首次拨打应当大于资源进入时间
and c.created_time >= f1.first_time_in --拨打时间大于等于首次拨打时间
group by s.phone , a.last_name, s.source,to_char(s.created_time,'YYYY-MM-DD HH24:MI'),c.student_id,c.created_by,
to_char(f1.first_time_in,'YYYY-MM-DD HH24:MI'),c.content) as m 
left join 
--试听课时间一般在拨打时间戳之后
--part 2 试听课数据， 
(select d.student_id, 
a1.last_name ,
d.created_by ,
max(d.created_time)as last_demo, --最近试听课时间
count(d.id) as demo_num 
from demo_course d 
left join account_user a1 
on a1.id = d.created_by
where d.status = 'finished'
and d.student_id in (select id from source)
group by d.student_id, d.created_by,a1.last_name ) 
as k 
on k.student_id = m.student_id and k.created_by = m.created_by
left join 
--成单数据
(select o.student_id, 
a2.last_name,
o.created_by, 
count(o.order_id) as order_num, --订单数
max(o.created_time) as last_pay, --最近支付时间
sum(o.amount/100) as amount_total --总金额
from course_order o 
left join first_call f 
on f.student_id = o.student_id and f.created_by = o.created_by
left join account_user a2 on a2.id =o.created_by
where o.status = 'finished'
and o.created_time >= f.first_time_in
group by o.student_id, a2.last_name,o.created_by
) as k1 
on k1.student_id = m.student_id and k1.created_by = m.created_by
order by m.资源进入时间