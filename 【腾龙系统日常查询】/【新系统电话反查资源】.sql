
#新系统手机号反查资源
select a.phone,(extend_info::json#>>'{channels, 0}') ::bigint as channel,b.name
from ocean a join channel b 
on (extend_info::json#>>'{channels, 0}') ::bigint=b.id 
where a.phone in 
('13613827828')


#海岸库存资源分渠道分布
select d.name,c.num
from 
(select (extend_info::json#>>'{channels, 0}') ::bigint as channel,count(a.lead_id) as num
from coast a join ocean b
on a.lead_id=b.id
where date(a.arrival_time)>='2017-11-15'
group by channel) as c
join channel d
on c.channel=d.id
order by c.num desc

#手机号码反查新系统渠道
select a.phone,(extend_info::json#>>'{channels, -1}') ::bigint as channel,b.name
from ocean a join channel b 
on (extend_info::json#>>'{channels, -1}') ::bigint=b.id 
where a.phone in 
('18793366205')


电话查订单
select *from course_order
where student_id in 
(select o.id
from ocean o
where phone = )

#

在线订单查询
select *from course_order c right join ocean o on o.id = c.student_id
where o.phone ='13963336106'


tmk转出数
select  count(distinct t.student_id) from tmk_confirm t where t.is_issued = 'true'
                        and date(t.created_time) between '2017-12-01' and '2017-12-31'



已知学生看转手次数，新系统
select t.student_id, count(t.id)-1 from leader_student t 
left join ocean o on o.id = t.student_id
where o.phone in ()    





