#线下库-试听课测试

select distinct t.pid, t.student_user_id,t.tutor_apply_id, t.name, t.content, 
t.teacher_user_id,t.parents_name,t.category,
CASE
          WHEN t.grade=1 then '一年级'
          WHEN t.grade=2 then '二年级'
          WHEN t.grade=3 then '三年级'
          WHEN t.grade=4 then '四年级'
          WHEN t.grade=5 then '五年级'
          WHEN t.grade=6 then '六年级'  
          WHEN t.grade=7 then '七年级'
          WHEN t.grade=8 then '八年级'  
          WHEN t.grade=9 then '九年级'
          WHEN t.grade=10 then '小学'  
          WHEN t.grade=11 then '高一'
          WHEN t.grade=12 then '高二'   
          WHEN t.grade=13 then '高三' 
          when t.grade = 101 then '一年级'
          when t.grade =102 then '二年级'
          when t.grade =103 then '三年级'
          when t.grade =104 then '四年级'
          when t.grade = 105 then '五年级'
          when t.grade = 106 then '六年级'
          Else '其他'      
      END as '年级',
 CASE
          WHEN t.subject=1 then '语文'
          WHEN t.subject=2 then '数学'
          WHEN t.subject=3 then '英语'
          WHEN t.subject=4 then '科学'
          WHEN t.subject=5 then '物理'
          WHEN t.subject=6 then '化学'
          WHEN t.subject=7 then '地理'
          WHEN t.subject=8 then '历史'
          WHEN t.subject=9 then '生物'
          WHEN t.subject=10 then '政治'
          WHEN t.subject=11 then '知心导师'
       END as  '学科',
       from_unixtime(t.create_time) as '创建时间',from_unixtime(t.start_time) as '预计开始时间',t.op_user_id

from tutor_preorder t  
where t.teacher_user_id in  (select u.user_id from user_online u where 
u.telephone_num in (10000000077, 10000000078,    
10000000079,10000000080, 10000000081,
10000000082,10000000083,10000000084,    
10000000085,10000000086,10000000087,10000000088,10000000089))
or t.name like '%测试%'
or t.content like '%测试%'
or t.parents_name like '%测试%'
