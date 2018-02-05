新签or续费新老系统迁移
step1 新系统查询订单与tmk关系
select e.phone,  --电话 准备迁移数据
a.last_name, 
date(o.created_time), --新系统成单时间
o.student_id,   
o.amount/100
from course_order o left join tmk_confirm t on t.student_id = o.student_id
left join account_user a on a.id = t.tmk_id
left join ocean e on e.id = o.student_id 
where date(o.created_time) between '2018-01-01' and '2018-01-07'
   and a.last_name is not null
   and o.status = 'finished'
   and o.amount/100 >1
order by date(o.created_time)

step 2 
老系统查询订单属性,
select u.telephone_num as '电话', s.planner_name as '咨询师',s.lesson_num as '课程数',s.amount/100,
date(from_unixtime(s.update_time)) as '支付时间',
from_unixtime(floor(k.min_coruse/1000)) as'最早正式课时间',
case when k.min_coruse is null then '新签'
     when k.min_coruse is not null and s.update_time<floor(k.min_coruse/1000) then '新签'
     when k.min_coruse is not null and s.update_time>floor(k.min_coruse/1000) then '续费'
end as '状态'
from series_order s left join user_online u on s.student_user_id = u.user_id
left join 
(select t.student_user_id as stu, min(r.start_time) as min_coruse
from tutor_preorder t left join audio_record_info r on r.tutor_record_id = t.tutor_record_id
where  t.status = 'BOOK'
and t.category = 'SERIES'
group by t.student_user_id
) as k
on k.stu = s.student_user_id 
where u.telephone_num in ('13072203908',
'15967126372',
'13630887188',
'18608880820',
'15869803322',
'15044955880',
'13511071852',
'15135626838') #添加新系统跑出的电话数据
and s.status  = 'SUCCESS'

