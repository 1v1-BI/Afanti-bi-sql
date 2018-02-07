
-- 资源区分
select o.id,c.level,c.name
from ocean o
join channel c on (extend_info::json#>>'{channels,-1}')::bigint= c.id
where c.level = 'B'
limit 100



--某个学生被跟进状况
select c.created_by, --咨询师编号
a.username, --咨询师姓名
c.creator_role, --咨询师角色
c.todo_category,  --沟通预期
c.student_id,  
(tianrun_info->>'customer_number')::bigint as num,  --电话
date(c.created_time)  --拨打日期
from comm_records c 
left join account_user a
where date(c.created_time) >= '2017-12-20'
  and a.region not like '%学管师%'
  and (tianrun_info->>'customer_number')::bigint in () --此处填写手机号码


-- 某个学生创建试听课查询 
select d.created_by,   --咨询师ID
a.last_name,   -- 咨询师姓名
d.student_id,   
d.demo_course_task_id,   -- 试听课id
date(d.created_time) as 预计开始时间, 
date(d.updated_time) as 创建时间 , 
d.status   -- 试听课状态
from demo_course d    -- 试听课表
left join ocean o on o.id = d.student_id   -- 保留左表
left join account_user a on a.id = d.created_by
where date(d.updated_time) > '2017-12-20'
and o.phone in ()  -- 输入电话

--订单查询
select c.order_id,          -- 订单编号
c.created_by,               -- 创建咨询师
c.status ,                  -- 订单状态
date(c.create_time),        -- 创建日期
date(c.updated_time),       -- 支付日期
c.amount/100                -- 金额
from course_order c
where c.student_id in (select o.id from ocean o where o.phone in (
))   --填写电话


# 线下库 -咨询师等级+跟进状态
select distinct c.customer_number,               # 电话
t.planner_level,                                 # 咨询师等级
c.client_name,                                   # 咨询师姓名
count(c.outcome_id),                             # 拨打电话数
avg(c.total_duration)                            # 拨打总时长
from crm_call_outcome_record c                   
left join crm_temp_personnel_id t 
on t.planner_name = c.client_name
where c.customer_number in (13757612258,
13575620604,
13693298557,
15330462182,
15010812902)
group by c.customer_number, c.client_name
limit 100

#老系统学生电话反查订单金额，待添加
select s.student_user_id,                        # 学生id         
u.telephone_num,                                 # 电话号码
sum(s.amount/100)                                # 金额
from series_order s left join user_online u
on u.user_id = s.student_user_id
where u.telephone_num in (13575620604)


--海岸库存资源分渠道分布
select d.name,                     -- 资源名称
c.num                              -- 学生id
from 
(select (extend_info->>'{campaigns, -1}') ::bigint as channel,count(a.lead_id) as num
from coast a join ocean b
on a.lead_id=b.id
where date(a.arrival_time)>='2017-11-15'
group by channel) as c
join campaign d
on c.channel=d.id
order by c.num desc
