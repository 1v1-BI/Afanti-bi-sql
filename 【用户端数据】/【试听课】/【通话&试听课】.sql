试听数据
SELECT 
       from_unixtime(p.create_time) AS '试听课创建时间',
       p.student_user_id,
       p.teacher_user_id,
       p.status AS '预约状态',
       t.tutor_status as '上课状态',
       from_unixtime(p.start_time) AS '预约上课时间',
       from_unixtime(floor(a.start_time/1000)) AS '课程录音开始时间',
       if(a.end_time>0,from_unixtime(floor(a.end_time/1000)),'') AS '课程录音结束时间',
       p.tutor_record_id AS '上课辅导记录ID',
       #if(a.end_time>a.start_time,round((a.end_time-a.start_time)/60000,2),0) AS '录音时长',
       #if(
            #(SELECT count(1)
             #FROM series_order s
             #WHERE s.student_user_id=p.student_user_id
               #AND s.teacher_user_id=p.teacher_user_id
               #AND s.status='SUCCESS'
               #AND (s.name NOT LIKE'%测试%'
                    #OR s.note NOT LIKE'%测试%'))>0,1,0) AS '是否成单',
       t.ua AS '设备号',
       CASE
           WHEN t.ua LIKE '%android%'  and t.ua NOT LIKE '%android%pad%' and t.ua NOT LIKE '%android%KYD%' and t.ua NOT LIKE '%android%AGS-L09%'  THEN 'android'
           WHEN t.ua LIKE '%android%pad%' or t.ua LIKE '%android%KYD%' or t.ua LIKE '%android%AGS-L09%'  THEN 'android pad'
           WHEN t.ua LIKE '%iOS%' and t.ua NOT LIKE '%iOS%pad%'  THEN 'iOS'
           WHEN t.ua LIKE '%iOS%pad%' THEN 'ipad'
           ELSE 'PC'
       END AS '设备信息',
       CASE
          WHEN p.grade=1 then '一年级'
          WHEN p.grade=2 then '二年级'
          WHEN p.grade=3 then '三年级'
          WHEN p.grade=4 then '四年级'
          WHEN p.grade=5 then '五年级'
          WHEN p.grade=6 then '六年级'  
          WHEN p.grade=7 then '七年级'
          WHEN p.grade=8 then '八年级'  
          WHEN p.grade=9 then '九年级'
          WHEN p.grade=10 then '小学'  
          WHEN p.grade=11 then '高一'
          WHEN p.grade=12 then '高二'   
          WHEN p.grade=13 then '高三' 
          Else '其他'      
       END as '年级',
       CASE
          WHEN p.subject=1 then '语文'
          WHEN p.subject=2 then '数学'
          WHEN p.subject=3 then '英语'
          WHEN p.subject=4 then '科学'
          WHEN p.subject=5 then '物理'
          WHEN p.subject=6 then '化学'
          WHEN p.subject=7 then '地理'
          WHEN p.subject=8 then '历史'
          WHEN p.subject=9 then '生物'
          WHEN p.subject=10 then '政治'
          WHEN p.subject=11 then '知心导师'
       END as  '学科',

			 p.planner_name as '咨询师姓名',
			 n2.user_name as '老师姓名',
			 n2.telephone_num as '老师手机',
			 n2.province as '老师省份',
			 n2.city as '老师城市',
             #substring(r.role,1,2) as '大区'
FROM tutor_preorder p
#left join crm_personnel r 
#on p.planner_name=r.content
left JOIN tutor_record t ON p.tutor_record_id=t.tutor_record_id
LEFT JOIN audio_record_info a ON p.tutor_record_id=a.tutor_record_id
LEFT JOIN
(
SELECT distinct u2.user_id, u2.user_name, u2.telephone_num, u2.province, u2.city, o.create_time desc
FROM user_online u2 left join series_order s on s.user_id = u2.student_user_id 
left join crm_call_outcome_record o on u.telephone_num = o.customer_number
where s.status not like '%SUCCESS%'

) as n2 ON n2.user_id = p.teacher_user_id
WHERE p.category='DEMO'
  AND p.status ='BOOK'
  AND t.tutor_status>0
  AND p.name NOT LIKE'%测试%'
  and n2.status NOT IN ('%SUCCESS%','%INIT%','%DEPOSIT%')
  #AND from_unixtime(floor(a.start_time/1000)) IS NOT NULL
  #AND if(a.end_time>a.start_time,round((a.end_time-a.start_time)/60000,2),0)>10
  AND date_format(from_unixtime(p.create_time), '%Y-%m-%d') < '2017-12-01' #试听课创建时间
  AND p.student_user_id NOT IN (250595181,157648815,34229717,146817789,66275421,
                                141321906,
                                249450013,
                                250595219,
                                248444058,
                                248259226,
                                251804322,
                                251804626,
                                251804835,
                                251436121,
                                75462035,
                                247444506)
  order by from_unixtime(p.create_time)

#试听课转化率监控源数据

SELECT n1.source as '渠道',
       from_unixtime(p.create_time) AS '试听课创建时间',
       p.student_user_id,
       p.teacher_user_id,
       p.status AS '预约状态',
       t.tutor_status as '上课状态',
       from_unixtime(p.start_time) AS '预约上课时间',
       from_unixtime(floor(a.start_time/1000)) AS '课程录音开始时间',
       if(a.end_time>0,from_unixtime(floor(a.end_time/1000)),'') AS '课程录音结束时间',
       p.tutor_record_id AS '上课辅导记录ID',
       if(a.end_time>a.start_time,round((a.end_time-a.start_time)/60000,2),0) AS '录音时长',
       if(
            (SELECT count(1)
             FROM series_order s
             WHERE s.student_user_id=p.student_user_id
               AND s.teacher_user_id=p.teacher_user_id
               AND s.status='SUCCESS'
               AND (s.name NOT LIKE'%测试%'
                    OR s.note NOT LIKE'%测试%'))>0,1,0) AS '是否成单',
       t.ua AS '设备号',
       CASE
           WHEN t.ua LIKE '%android%' THEN 'android'
           WHEN t.ua LIKE '%iOS%' THEN 'iOS'
           ELSE 'PC'
       END AS '设备信息',
       p.grade as grade,
       p.subject as subject,
			 n1.client_name as '咨询师姓名',
			 n2.user_name as '老师姓名',
			 n2.telephone_num as '老师手机',
			 n2.province as '老师省份',
			 n2.city as '老师城市'
FROM tutor_preorder p
JOIN tutor_record t ON p.tutor_record_id=t.tutor_record_id
LEFT JOIN audio_record_info a ON p.tutor_record_id=a.tutor_record_id
LEFT JOIN
(
SELECT DISTINCT u1.user_id, c.client_name,d.source
FROM user_online u1
JOIN crm_call_outcome_record c ON c.customer_number = u1.telephone_num
LEFT join crm_form_record d on u1.telephone_num=d.telephone_number
WHERE c.status = 28
GROUP BY u1.user_id
HAVING MAX(c.start_time)
) as n1 ON n1.user_id = p.student_user_id
LEFT JOIN
(
SELECT distinct u2.user_id, u2.user_name, u2.telephone_num, u2.province, u2.city
FROM user_online u2
) as n2 ON n2.user_id = p.teacher_user_id
WHERE p.category='DEMO'
  AND p.status ='BOOK'
  AND t.tutor_status>0
  AND p.name NOT LIKE'%测试%'
  AND from_unixtime(floor(a.start_time/1000)) IS NOT NULL
  AND if(a.end_time>a.start_time,round((a.end_time-a.start_time)/60000,2),0)>10
  AND date_format(from_unixtime(p.create_time), '%Y-%m-%d') >= '2017-08-21'
  AND p.student_user_id NOT IN (250595181,
                                141321906,
                                249450013,
                                250595219,
                                248444058,
                                248259226,
                                251804322,
                                251804626,
                                251804835,
                                251436121,
                                75462035,
                                247444506)
  order by from_unixtime(p.create_time)

  ------------

邀约试听取消数list

SELECT n.client_name,
       p.pid,
       n.telephone_num,
       DATE_FORMAT(FROM_UNIXTIME(p.create_time), '%Y-%m-%d') as t1		
FROM tutor_preorder p
LEFT JOIN
(
SELECT distinct u.user_id, c.client_name,u.telephone_num
FROM user_online u
JOIN crm_call_outcome_record c ON u.telephone_num = c.customer_number
) as n
ON p.student_user_id = n.user_id
WHERE from_unixtime(create_time) BETWEEN '2017-07-01' AND '2017-08-15'
	AND p.name not like '题目%'
	AND p.name not like '测试%'
	AND p.content not like '内容%'
	AND p.content not like '测试%'
	AND p.status = 'CANCEL'
	AND p.category <> 'SERIES'
    AND  'NULL'
  AND p.student_user_id NOT IN (250595181,
                                141321906,
                                249450013,
                                250595219,
                                248444058,
                                248259226,
                                251804322,
                                251804626,
                                251804835,
                                251436121,
                                75462035,
                                247444506,
                                247673969)






SELECT sum(if(total_duration<20,1,0)) as'20秒以内',sum(if(total_duration>=20,1,0)) as'超过20秒'
from crm_call_outcome_record
where status in (23)





SELECT user_id,
CASE
          WHEN grade=1 then '一年级'
          WHEN grade=2 then '二年级'
          WHEN grade=3 then '三年级'
          WHEN grade=4 then '四年级'
          WHEN grade=5 then '五年级'
          WHEN grade=6 then '六年级'  
          WHEN grade=7 then '七年级'
          WHEN grade=8 then '八年级'  
          WHEN grade=9 then '九年级'
          WHEN grade=10 then '小学'  
          WHEN grade=11 then '高一'
          WHEN grade=12 then '高二'   
          WHEN grade=13 then '高三' 
          Else '其他'      
       END as '年级'
FROM user_online
WHERE user_id IN 
(123138944, 224367334, 260166773, 123138944, 183061125, 89853642, 200268931, 216983155, 207293459, 262426671, 145400066, 49927954, 174776498, 216983155, 263206849, 194299473, 264385267, 204322961, 264693466, 254958740, 266587842, 267310355, 253835992, 117789589, 268812514, 110157745, 184980771, 266758538, 261669863, 125118041, 232531102, 262038672, 201286799, 85720914, 272328008, 272284422, 255911400, 54671190, 190802561, 265083042, 207155006, 168234627, 192416820, 259678169, 267106181, 265010234, 68552343, 274415671, 136686989, 164660423, 271611936, 180220587, 278907138, 273345705, 270988831, 272807435, 279325442, 271932941, 279884669, 278295243, 266266704, 281028697, 115029649, 56083631, 279889343, 229585456, 188148584, 188148584, 244601593, 271932941, 278315326, 266139974, 282460803, 281763883, 278818408, 197491150, 241837853, 284467431, 282673432, 284284385, 283938205, 281742603, 226115182, 252850861, 218096859, 284218303, 180365082, 285684419, 285560406, 284274676, 131068613, 286964411, 287440570, 286260214, 127349990, 285656204, 286512078, 285804803, 286650778, 127344746, 287920472, 251475622, 282203562, 287479140, 200313809, 152373826, 207155006, 288833650, 287510053)
GROUP BY user_id


























