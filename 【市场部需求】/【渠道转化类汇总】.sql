渠道判定（成单前最近的渠道名称判为归属渠道）

select tel_num, source, from_unixtime(create_time) as source_time, from_unixtime(order_time) as order_time, planner_name, money, original_money, lesson_num, subject, grade, note, max(result_table.create_time) 
from 
(
select *
from 
(select user_online.`telephone_num` as tel_num, series_order.planner_name, series_order.amount/100 as money, series_order.original_amount/100 as original_money, series_order.lesson_num, series_order.`update_time` as order_time, series_order.note

from  user_online 
left join series_order 
on user_online.`user_id` = series_order.`student_user_id` 
where series_order.status ='SUCCESS' 
and  series_order.amount/100>100  
and (series_order.note NOT LIKE '%zyb%')
and (series_order.name NOT LIKE '%测试%')
and (series_order.name NOT LIKE '%test%')
and series_order.status ='SUCCESS'
and series_order.amount/100>100
and series_order.student_user_id NOT IN (148811250,43744461,250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,88452392,122839998,247444506)
and from_unixtime(series_order.update_time)  >= '2017-10-01'
and from_unixtime(series_order.update_time)  < '2017-11-28') order_table
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




整体渠道转化率
select
count(k.telephone_number) as '用户数',count(k.user_id) as 'ID用户数',
sum(k.tels) as '拨打电话数',sum(if(tels>0,1,0))as '拨打用户数',sum(k.tel) as '接通电话数',sum(if(tel>0,1,0))as '接通用户数',
sum(k.st) as '完成试听数',sum(if(k.st>0,1,0)) as '试听用户数',sum(k.cd)as'成单数',sum(if(k.cd>0,1,0))as '成单用户数',sum(k.fee)as'成单金额',
sum(k.tels)/sum(if(tels>0,1,0)) as '平均拨打次数 3',
sum(k.tel)/sum(k.tels) as '拨打接通率 30%',
sum(if(tel>0,1,0))/sum(if(tels>0,1,0)) as'用户接通率 50%',
sum(k.st)/sum(if(tel>0,1,0)) as'接通用户-试听率 2%',
sum(k.cd)/sum(k.st) as'试听-成单率 10%',
sum(k.cd)/sum(if(tels>0,1,0)) as'拨打用户-成单率 0.05%',
sum(k.fee)/sum(if(tels>0,1,0)) as'ROI'
from 
(
select x.telephone_number,x.user_id,x.source,x.tels,x.tel,y.st,z.cd,z.fee
from 
(select a.telephone_number,min(from_unixtime(b.start_time)) as fdt,c.user_id ,a.source,count(b.customer_number) as tels,sum(if(b.status=28,1,0)) as tel
from crm_form_record a left join crm_call_outcome_record b 
on a.telephone_number = b.customer_number
left join user_online c 
on a.telephone_number=c.telephone_num
where from_unixtime(a.create_time)>='2017-09-01'#在这里可以更改线索创建或者首次呼出时间#
group by a.telephone_number
having fdt>='2017-09-01' and fdt<'2017-10-01'#在这里可以输入线索首次呼出的时间 
) as x
left join
(select d.student_user_id,count(d.pid) as st
from tutor_preorder d left join audio_record_info e
on d.tutor_record_id = e.tutor_record_id
where d.status NOT LIKE 'CANCEL'
	AND d.category <> 'SERIES'
	AND d.name not like '题目%'
	AND d.content not like '内容%'
	AND d.name NOT LIKE '测试%'
	AND d.content NOT LIKE '测试%'
	AND d.tutor_record_id = e.tutor_record_id
	AND from_unixtime(floor(e.start_time/1000)) IS NOT NULL
	AND round((e.end_time-e.start_time)/60000) > 15
	AND d.student_user_id NOT IN (250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,247444506)
	group by d.student_user_id) as y
on x.user_id=y.student_user_id
left join
(SELECT f.student_user_id,count(f.pid) as cd,sum(f.amount/100) as fee
FROM series_order f
WHERE (f.note NOT LIKE '%zyb%')
  AND (f.name NOT LIKE '%测试%')
  AND (f.name NOT LIKE '%test%')
  and f.status ='SUCCESS'
  AND f.amount/100>100
  AND f.student_user_id NOT IN (148811250,141321906,141321906,43744461,250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,88452392,122839998,247444506,247673969)
 group by f.student_user_id) as z 
on x.user_id=z.student_user_id ) as k



同源渠道转化率
select k.source as '渠道',count(k.telephone_number) as '用户数',count(k.user_id) as 'ID用户数',
sum(k.tels) as '拨打电话数',sum(if(tels>0,1,0))as '拨打用户数',sum(k.tel) as '接通电话数',sum(if(tel>0,1,0))as '接通用户数',
sum(k.st) as '完成试听数',sum(if(k.st>0,1,0)) as '试听用户数',sum(k.cd)as'成单数',sum(if(k.cd>0,1,0))as '成单用户数',sum(k.fee)as'成单金额',
sum(k.tels)/sum(if(tels>0,1,0)) as '平均拨打次数 3',
sum(k.tel)/sum(k.tels) as '拨打接通率 30%',
sum(if(tel>0,1,0))/sum(if(tels>0,1,0)) as'用户接通率 50%',
sum(k.st)/sum(if(tel>0,1,0)) as'接通用户-试听率 2%',
sum(k.cd)/sum(k.st) as'试听-成单率 10%',
sum(k.cd)/sum(if(tels>0,1,0)) as'拨打用户-成单率 0.05%',
sum(k.fee)/sum(if(tels>0,1,0)) as'ROI'
from 
(
select x.telephone_number,x.user_id,x.source,x.tels,x.tel,y.st,z.cd,z.fee
from 
(select a.telephone_number,min(from_unixtime(b.start_time)) as fdt,c.user_id ,a.source,count(b.customer_number) as tels,sum(if(b.status=28,1,0)) as tel
from crm_form_record a left join crm_call_outcome_record b 
on a.telephone_number = b.customer_number
left join user_online c 
on a.telephone_number=c.telephone_num
where from_unixtime(a.create_time)>='2017-10-01'#在这里可以更改线索创建或者首次呼出时间#
group by a.telephone_number
# having fdt>='2017-10-01' AND fdt<'2017-11-01'#在这里可以输入线索首次呼出的时间 
) as x
left join
(select d.student_user_id,count(d.pid) as st
from tutor_preorder d left join audio_record_info e
on d.tutor_record_id = e.tutor_record_id
where d.status NOT LIKE 'CANCEL'
	AND d.category <> 'SERIES'
	AND d.name not like '题目%'
	AND d.content not like '内容%'
	AND d.name NOT LIKE '测试%'
	AND d.content NOT LIKE '测试%'
	AND d.tutor_record_id = e.tutor_record_id
	AND from_unixtime(floor(e.start_time/1000)) IS NOT NULL
	AND round((e.end_time-e.start_time)/60000) > 15
	AND d.student_user_id NOT IN (250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,247444506)
	group by d.student_user_id) as y
on x.user_id=y.student_user_id
left join
(SELECT f.student_user_id,count(f.pid) as cd,sum(f.amount/100) as fee
FROM series_order f
WHERE (f.note NOT LIKE '%zyb%')
  AND from_unixtime(update_time)>='2017-10-01' #订单支付区间
  AND (f.name NOT LIKE '%测试%')
  AND (f.name NOT LIKE '%test%')
  and f.status ='SUCCESS'
  AND f.amount/100>100
  AND f.student_user_id NOT IN (148811250,141321906,141321906,43744461,250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,88452392,122839998,247444506,247673969)
 group by f.student_user_id) as z 
on x.user_id=z.student_user_id ) as k
group by k.source
order by '渠道'

某特定渠道转化率
select k.source as '渠道',count(k.telephone_number) as '用户数',count(k.user_id) as 'ID用户数',
sum(k.tels) as '拨打电话数',sum(if(tels>0,1,0))as '拨打用户数',sum(k.tel) as '接通电话数',sum(if(tel>0,1,0))as '接通用户数',
sum(k.st) as '完成试听数',sum(if(k.st>0,1,0)) as '试听用户数',sum(k.cd)as'成单数',sum(if(k.cd>0,1,0))as '成单用户数',sum(k.fee)as'成单金额',
sum(k.tels)/sum(if(tels>0,1,0)) as '平均拨打次数 3',
sum(k.tel)/sum(k.tels) as '拨打接通率 30%',
sum(if(tel>0,1,0))/sum(if(tels>0,1,0)) as'用户接通率 50%',
sum(k.st)/sum(if(tel>0,1,0)) as'接通用户-试听率 2%',
sum(k.cd)/sum(k.st) as'试听-成单率 10%',
sum(k.cd)/sum(if(tels>0,1,0)) as'拨打用户-成单率 0.05%', k.cd
sum(k.fee)/sum(if(tels>0,1,0)) as'ROI'
from 
(
select x.telephone_number,x.user_id,x.source,x.tels,x.tel,y.st,z.cd,z.fee
from 
(select a.telephone_number,c.user_id ,a.source,count(b.customer_number) as tels,sum(if(b.status=28,1,0)) as tel
from crm_form_record a left join crm_call_outcome_record b 
on a.telephone_number = b.customer_number
left join user_online c 
on a.telephone_number=c.telephone_num
where from_unixtime(a.create_time)>='2017-10-01'#在这里可以更改线索创建或者首次呼出时间#
and a.source like '%app-zhibo-A%' #在这里可以更改或补充想要看的线索#
group by a.telephone_number) as x
left join
(select d.student_user_id,count(d.pid) as st
from tutor_preorder d left join audio_record_info e
on d.tutor_record_id = e.tutor_record_id
where d.status NOT LIKE 'CANCEL'
	AND d.category <> 'SERIES'
	AND d.name not like '题目%'
	AND d.content not like '内容%'
	AND d.name NOT LIKE '测试%'
	AND d.content NOT LIKE '测试%'
	AND d.tutor_record_id = e.tutor_record_id
	AND from_unixtime(floor(e.start_time/1000)) IS NOT NULL
	AND round((e.end_time-e.start_time)/60000) > 15
	AND d.student_user_id NOT IN (250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,247444506)
	group by d.student_user_id) as y
on x.user_id=y.student_user_id
left join
(SELECT f.student_user_id,count(f.pid) as cd,sum(f.amount/100) as fee
FROM series_order f
WHERE (f.note NOT LIKE '%zyb%')
  AND (f.name NOT LIKE '%测试%')
  AND (f.name NOT LIKE '%test%')
  and f.status ='SUCCESS'
  AND f.amount/100>100
  AND f.student_user_id NOT IN (148811250,141321906,141321906,43744461,250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,88452392,122839998,247444506,247673969)
 group by f.student_user_id) as z 
on x.user_id=z.student_user_id ) as k
group by k.source
order by '渠道'

--------------------
人员转化率#和人员相关的同源数据 目前准确率不高
select k.client_name as '咨询师',count(k.telephone_number) as '用户数',count(k.user_id) as 'ID用户数',
sum(k.tels) as '拨打电话数',sum(if(tels>0,1,0))as '拨打用户数',sum(k.tel) as '接通电话数',sum(if(tel>0,1,0))as '接通用户数',
sum(k.st) as '完成试听数',sum(if(k.st>0,1,0)) as '试听用户数',sum(k.cd)as'成单数',sum(if(k.cd>0,1,0))as '成单用户数',sum(k.fee)as'成单金额',
sum(k.tels)/sum(if(tels>0,1,0)) as '平均拨打次数',
sum(k.tel)/sum(k.tels) as '拨打接通率',
sum(if(tel>0,1,0))/sum(if(tels>0,1,0)) as'用户接通率',
sum(k.st)/sum(if(tel>0,1,0)) as'接通用户-试听率',
sum(k.cd)/sum(k.st) as'试听-成单率',
sum(k.cd)/sum(if(tels>0,1,0)) as'拨打用户-成单率',
sum(k.fee)/sum(if(tels>0,1,0)) as'ROI'
from 
(
select x.telephone_number,x.user_id,x.client_name,x.tels,x.tel,y.st,z.cd,z.fee
from 
(select a.telephone_number,c.user_id ,b.client_name,count(b.customer_number) as tels,sum(if(b.status=28,1,0)) as tel
from crm_form_record a left join crm_call_outcome_record b 
on a.telephone_number = b.customer_number
left join user_online c 
on a.telephone_number=c.telephone_num
where from_unixtime(b.start_time)>='2017-08-01'#在这里可以更改线索创建或者首次呼出时间,拨打时间b.start_time,a.create_time#
group by a.telephone_number) as x
left join
(select d.student_user_id,count(d.pid) as st
from tutor_preorder d left join audio_record_info e
on d.tutor_record_id = e.tutor_record_id
where d.status NOT LIKE 'CANCEL'
	AND d.category <> 'SERIES'
	AND d.name not like '题目%'
	AND d.content not like '内容%'
	AND d.name NOT LIKE '测试%'
	AND d.content NOT LIKE '测试%'
	AND d.tutor_record_id = e.tutor_record_id
	AND from_unixtime(floor(e.start_time/1000)) IS NOT NULL
	AND round((e.end_time-e.start_time)/60000) > 15
	AND d.student_user_id NOT IN (250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,247444506)
	group by d.student_user_id) as y
on x.user_id=y.student_user_id
left join
(SELECT f.student_user_id,count(f.pid) as cd,sum(f.amount/100) as fee
FROM series_order f
WHERE (f.note NOT LIKE '%zyb%')
  AND (f.name NOT LIKE '%测试%')
  AND (f.name NOT LIKE '%test%')
  and f.status ='SUCCESS'
  AND f.amount/100>100
  AND f.student_user_id NOT IN (148811250,141321906,141321906,43744461,250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,88452392,122839998,247444506,247673969)
 group by f.student_user_id) as z 
on x.user_id=z.student_user_id ) as k
group by k.client_name
order by '拨打用户-成单率'

--------
某些电话号码各环节转化
select k.source as '渠道',count(k.telephone_number) as '用户数',count(k.user_id) as 'ID用户数',
sum(k.tels) as '拨打电话数',sum(if(tels>0,1,0))as '拨打用户数',sum(k.tel) as '接通电话数',sum(if(tel>0,1,0))as '接通用户数',
sum(k.st) as '完成试听数',sum(if(k.st>0,1,0)) as '试听用户数',sum(k.cd)as'成单数',sum(if(k.cd>0,1,0))as '成单用户数',sum(k.fee)as'成单金额',
sum(k.tels)/sum(if(tels>0,1,0)) as '平均拨打次数 3',
sum(k.tel)/sum(k.tels) as '拨打接通率 30%',
sum(if(tel>0,1,0))/sum(if(tels>0,1,0)) as'用户接通率 50%',
sum(k.st)/sum(if(tel>0,1,0)) as'接通用户-试听率 2%',
sum(k.cd)/sum(k.st) as'试听-成单率 10%',
sum(k.cd)/sum(if(tels>0,1,0)) as'拨打用户-成单率 0.05%',
sum(k.fee)/sum(if(tels>0,1,0)) as'ROI'
from 
(
select x.telephone_number,x.user_id,x.source,x.tels,x.tel,y.st,z.cd,z.fee
from 
(select a.telephone_number,c.user_id ,a.source,count(b.customer_number) as tels,sum(if(b.status=28,1,0)) as tel
from  crm_call_outcome_record b left join crm_form_record a 
on a.telephone_number = b.customer_number
left join user_online c 
on a.telephone_number=c.telephone_num
where from_unixtime(a.create_time)>='2017-04-01'#在这里可以更改线索创建或者首次呼出时间#
and a.telephone_number in (13403260170, 13513224631, 13630854479, 13633229506, 13730205608, 13730222626, 13730226655, 13931223146, 13730470187, 13733370097, 15103120866, 13633121666, 13803276028, 15103121216, 13832221358, 13731682096, 15533120371, 13832292078, 13832299753, 15176291367, 13833213607, 13513326272, 13903320662, 15081200056, 13932258495, 13933232581, 15903120944, 15028239380, 13733220248, 15103128702, 15103322104, 13400390961, 15284221845, 15512278228, 15832276179, 13784965566, 15903127580, 15930238880, 15932129622, 18830209836, 13785233258, 13001875428, 15103122888, 13582226988, 13903128583, 13784435666, 13903128765, 13613321464, 15990643211, 13082360081, 13102965189, 13833200066, 13933231868, 13103129254, 13722208486, 15231265517, 13131233239, 13513223809, 13171678908, 13931282619, 13230632086, 13484281028, 13313125885, 15231294233, 13613126333, 13932250992, 13603128281, 13315292899, 13323244357, 13331215656, 13785281133, 15632282635, 13603125799, 13703129112, 15032235677, 15903124444, 13780327067, 15231274931, 13582053753, 13803273578, 13403263333, 13463206519, 13463284432, 13463688686, 13463691349, 13933288700, 13472214992, 15033255029, 13473210396, 13463829229, 13473425476, 13483211169, 13931287189, 13931384833, 18833265534, 13483458748, 13930221456, 13931699957, 13503127858, 13503223007, 13930203173, 15831298598, 13503364658, 15103123567, 15830899198, 13931217359, 13513123617, 13933247022, 13803122608, 13930826265, 13930859603, 13513226865, 15930859603, 13513322033, 13931202895, 13513432459, 15531205218, 15831531560, 15931895038, 15132223222, 13582057693, 18732222222, 13582210024, 13831205588, 15931899999, 15832207216, 13582229498, 15832218528, 13582231126, 13582234128, 13582255256, 13582255568, 13582257955, 13930292860, 18233312003, 13831243919, 13582272598, 13582276555, 13832256516, 13582394722, 13582398222, 13633220777, 15832238081, 13903127248, 15930293201, 13603328585, 18331140538, 13643126173, 13930262950, 13603240311, 13603247499, 13603249268, 13603288886, 13784966958, 13930804039, 15103120288, 13733388088, 13784966947, 13613224634, 15033232344, 13613324958, 13613326096, 13613329157, 13613395008, 13833006669, 13833099686, 15720109799, 13633125572, 15188666388, 13633221112, 15832239658, 15031965035, 15188655821, 13931231772, 13933216130, 13784978666, 13633388788, 15720026678, 13643393494, 15081238855, 13513228883, 13722225618, 13653229772, 13653228812, 13663125310, 18132565888, 13472270998, 15350627995, 13663243363, 13663302888, 13833089300, 13663314446, 13663319961, 13930238659, 15128298800, 13012077999, 13673280186, 13930866088, 13722223218, 13700329794, 13333126209, 13833018181, 15033753888, 13703120635, 15930280119, 13703120336, 13703127027, 13703122229, 13703128899, 13513129276, 15830256993, 13833001691, 13703223697, 13833002100, 15713320088, 13703329867, 15031238888, 13722201687, 13722207978, 15713329988, 13730204581, 13833030171, 13582057676, 13932276615, 13903325968, 13930899278, 13722232320, 13722236817, 15930257099, 18632235505, 15103123831, 15932233133, 13722285892, 13731236213, 13722425988, 15931788064, 15176306575, 15903120287, 13315280000, 13331232000, 13730151299, 13730155511, 18833218688, 13930248594, 13730182031, 18231263380, 13730209018, 13730209093, 13400261799, 13473240101, 13730228890, 13730251978, 13832255332, 13930886518, 13730151222, 13831268877, 13932260798, 13730293008, 15103120268, 13730299828, 13730449677, 13731050117, 15130285716, 13731228255, 13780420788, 13731239306, 13731250902, 13731253158, 13731258505, 13930878999, 13731287680, 13582261040, 15033761705, 13730274116, 15933785288, 13932253882, 13932287768, 13733228187, 13903126428, 13932295587, 13903223399, 13733395086, 13903326969, 13013255455, 13780248887, 13730273104, 13722285757, 15903125302, 13784283338, 13933202123, 18631225568, 13784957037, 15128990778, 15188985188, 13722231077, 13930205931, 15033258228, 15033286966, 13785210814, 13785211976, 13931251946, 13785233010, 15231231880, 13703128162, 13785257356, 13785257885, 13730290131, 13731470070, 15933773565, 13785284566, 13673129675, 13803128899, 13803272311, 13693369839, 13483290579, 13803288017, 13582087880, 13785225341, 13831208339, 13831218812, 15128493007, 13582399969, 15103129182, 13831227979, 13831228485, 13831228678, 13582213722, 15603125666, 13931695365, 13785266757, 13811733019, 15128279998, 13831280066, 15830958880, 13603129925, 13833029527, 13832210265, 13633221361, 15831515521, 13739706503, 13832219685, 13903129310, 13832241252, 13521567092, 17732205176, 13832252728, 13633228088, 15531278879, 13832256886, 15232943319, 13832261790, 13832262555, 13832276815, 13832280299, 15830297670, 13831293028, 13832299185, 13833003368, 15027885760, 13373320973, 13903124813, 13833003021, 13933277672, 13833006159, 13833012432, 13833006861, 18732270111, 13483449990, 13833012808, 13833013298, 13833013809, 13833013823, 13833015090, 13833276764, 13603288919, 13603326611, 15803120663, 15830881528, 13933270722, 18632232926, 13582269861, 13931369800, 13832291178, 13833069993, 15933550026, 13103126518, 15933909592, 13722295165, 13832210428, 13833222656, 13833226419, 13833243344, 15603230056, 13833291999, 13833299338, 13903120912, 13903121073, 13903121270, 18131279017, 13831219552, 13931364799, 15033773377, 13903126293, 15930732777, 15003120111, 18832202003, 13930856870, 15033206452, 13903129337, 13663307668, 13903220066, 13931364535, 13932296918, 17717127007, 13722430230, 13733395259, 13903329016, 15175211508, 15932120592, 13582625535, 13930202051, 13722263631, 13903320119, 13930206090, 13931698811, 13400339899, 13930806611, 13903327987, 13930242275, 13930248155, 13930200971, 13930254312, 13784273230, 13930236361, 13930272992, 13784368338, 13930282900, 15103321155, 13930288887, 13833009918, 13930297599, 13930800986, 13931255591, 13930805111, 13833058515, 13930808295, 13633385888, 13032012567, 13831254101, 13785233666, 13930819558, 13831222818, 13292930688, 13930828717, 13930835571, 13582230688, 13703320219, 13831256626, 13931217691, 13931396922, 15931786866, 13930861308, 13671071944, 13930866459, 13930866998, 13503120170, 13930870725, 13693336812, 13933256536, 13582994443, 13930881460, 15033807755, 13930898079, 13630857341, 13833043345, 13931206893, 13931206967, 13733325818, 13931211556, 13930816809, 18631268763, 13931227777, 15127278658, 18131257921, 13733222092, 13931241998, 13931248221, 13930269983, 18330278575, 13582266938, 13613121911, 13230207218, 13333023810, 13931268816, 13931270899, 13931281638, 13070594567, 13931286608, 13722277753, 13931288025, 13931290069, 13582998889, 13933263699, 13931298811, 13931359133, 13832250163, 15033788918, 13931366616, 15103128779, 13931378799, 13931382680, 15933779995, 13651203915, 13931386720, 13730291548, 13931691403, 18003329386, 15933768222, 18031271234, 13931699638, 15128221232, 13932221122, 13932223831, 13932225116, 13932226864, 13932229299, 18632239162, 13833068081, 13933216822, 15531280000, 15931873000, 13932268285, 18131218507, 13932285133, 18131218537, 13503387225, 15132268080, 13703120119, 15512267630, 13933212229, 13930856966, 13730225666, 15833335333, 13933225739, 18330290059, 13503226918, 13722970866, 13503328046, 13933242332, 13722244385, 13731203969, 13933256888, 13933260510, 13933262496, 18931236388, 13663222056, 13933273666, 13933294608, 13833265168, 13730263666, 13933290101, 13653225566, 13833015555, 13333222330, 13933898568, 13933975258, 13933978006, 13930808738, 13996279351, 13603123298, 15003322336, 15022692660, 15028219474, 15028281972, 15030209993, 18833219998, 15031237146, 13831252066, 13703120170, 15031644018, 13722220110, 15031978331, 15032210806, 13731281193, 15032483440, 13832200381, 15033228690, 13513222509, 15033240075, 13513223313, 13931234567, 18803128858, 15033728669, 15033744075, 13503382215, 13930880185, 13832283812, 15033773554, 13932259075, 13930279808, 15075286692, 13933297060, 15832279999, 15081286066, 15132277626, 15100233555, 18233318898, 15103120289, 15132277636, 15103120896, 15103120908, 13784280328, 15103121237, 13930828386, 15103122600, 15103122706, 13784958559, 13785260842, 13111653586, 15103128703, 15932022433, 13315255508, 13831296669, 13730227738, 18132394009, 13633320311, 13931253683, 13633328333, 15128975868, 15128976599, 13933222910, 13933276553, 15131228936, 15131293880, 13703120985, 13933896565, 13082310360, 13111652935, 13730175725, 15133209686, 15133216881, 15133219090, 15133260068, 13933979550, 15175268588, 13931385772, 15176236866, 15130429789, 18831257886, 13703129873, 13903220062, 13930808730, 15188680634, 15188797918, 13930808804, 15194779088, 13013258507, 13582050062, 15200090725, 15200091878, 15227043477, 15227068888, 15230207733, 15230436277, 15231221068, 13703129905, 15231244777, 13703288810, 15231271917, 15103121797, 15713021777, 15231981666, 15232260779, 15232901505, 15232927923, 13930283101, 15232980090, 15233122333, 15233704120, 18831200121, 15284220585, 13931696611, 18348933653, 15530210586, 15031296633, 13931290129, 15200055333, 13803129202, 15533275510, 13930876261, 13933235370, 15603261116, 15603261117, 15631239969, 13832291234, 13730167891, 15703121797, 15712576555, 15831471518, 15713026081, 15097405952, 15132268969, 15713323376, 15933125050, 15933125059, 15720088598, 13331268111, 15720088838, 13731670889, 13931230353, 15832278005, 15803223728, 15930261195, 15830837089, 15830291583, 17736262815, 15830798276, 13832238686, 18833219696, 13930224488, 15830919082, 15830955366, 15833855888, 15831245498, 13930229071, 15831286187, 18131218759, 13315225511, 13784975979, 13363125700, 13633228068, 15831575886, 15832206896, 15832207069, 13663120060, 15713126799, 13032058999, 13930855255, 15832254441, 13833088881, 13933225917, 15833332328, 13833088882, 13722224331, 15833862956, 15803328800, 15903120335, 13483233158, 15903125071, 15903125095, 15903125283, 13930869382, 15903125488, 15903128271, 15930042383, 13582291035, 15030291333, 13722961162, 15803125668, 13831226173, 15930046962, 13833066885, 13833066889, 15931292530, 15931769001, 15931789298, 13663328150, 13730295528, 15931827585, 15931838583, 15931861242, 15233707783, 13832221207, 13833020905, 13832216401, 13930840905, 15932230577, 13903121359, 15932289698, 13903121395, 13833000838, 15933125991, 15933127373, 15933452562, 13833000868, 15933730882, 13663128218, 15933773003, 13663129318, 13633228808, 15933784991, 13730282828, 15194976666, 15933928326, 15831255888, 13503380358, 13731656789, 13102999666, 13832213220, 13931262566, 18031289956, 15803120096, 13831263711, 13903368808, 13931257076, 13931261971, 13722431777, 18803125719, 13733387337, 18233257516, 15930761222, 13930860656, 18233329886, 13933209960, 18330279267, 18330286100, 13703366328, 18330290819, 13722216088, 18331263298, 15175399317, 18531221022, 18630299949, 13903123018, 13131288878, 13315226099, 13933231387, 15188601640, 18633636771, 18730209584, 18730223487, 18731209906, 18731293180, 18731295632, 13903363366, 18732231885, 15831515881, 18733267198, 18803121102, 18803122299, 13832282336, 13832247539, 18803129808, 18830204265, 13833016866, 18831266566, 13931298568, 18832221699, 15633272698, 13582219606, 13932233505, 13803280192, 18833267799, 18833280105, 18903127038, 18903361662, 18903366869, 18931217216, 13832260755)#在这里可以输入测试的各种号码
AND b.client_name not in 
                      (SELECT content
                        from crm_personnel
                        where profile LIKE "%内部TMK%")
group by a.telephone_number) as x
left join
(select d.student_user_id,count(d.pid) as st
from tutor_preorder d left join audio_record_info e
on d.tutor_record_id = e.tutor_record_id
where d.status NOT LIKE 'CANCEL'
	AND d.category <> 'SERIES'
	AND d.name not like '题目%'
	AND d.content not like '内容%'
	AND d.name NOT LIKE '测试%'
	AND d.content NOT LIKE '测试%'
	AND d.tutor_record_id = e.tutor_record_id
	AND from_unixtime(floor(e.start_time/1000)) IS NOT NULL
	AND round((e.end_time-e.start_time)/60000) > 15
	AND d.student_user_id NOT IN (250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,247444506)
	group by d.student_user_id) as y
on x.user_id=y.student_user_id
left join
(SELECT f.student_user_id,count(f.pid) as cd,sum(f.amount/100) as fee
FROM series_order f
WHERE (f.note NOT LIKE '%zyb%')
  AND (f.name NOT LIKE '%测试%')
  AND (f.name NOT LIKE '%test%')
  and f.status ='SUCCESS'
  AND f.amount/100>100
  AND f.student_user_id NOT IN (148811250,141321906,141321906,43744461,250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,88452392,122839998,247444506,247673969)
 group by f.student_user_id) as z 
on x.user_id=z.student_user_id ) as k
group by k.source
order by '拨打用户-成单率'






某渠道成单数

baidu 2232

select count(distinct d.student_user_id),count(distinct d.pid),sum(d.amount)/100
from 
(select b.user_id as id 
from crm_form_record a join user_online b 
on a.telephone_number=b.telephone_num
where a.source like "%今日头条%") as c 
join series_order d
on c.id=d.student_user_id
where d.update_time BETWEEN unix_timestamp('2017-05-01') AND unix_timestamp('2017-08-26')-1
  AND (d.note NOT LIKE '%zyb%')
  AND (d.name NOT LIKE '%测试%')
  AND (d.name NOT LIKE '%test%')
  and d.status ='SUCCESS'
  AND d.amount/100>100
  AND d.student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
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
                              88452392,
                              122839998,
                              247444506)


所有渠道成单

select c.qudao,count(distinct d.student_user_id),count(distinct d.pid),sum(d.amount)/100
from 
(select a.source as qudao ,b.user_id as id 
from crm_form_record a join user_online b 
on a.telephone_number=b.telephone_num) as c 
join series_order d
on c.id=d.student_user_id
where d.update_time BETWEEN unix_timestamp('2017-05-01') AND unix_timestamp('2017-08-26')-1
  AND (d.note NOT LIKE '%zyb%')
  AND (d.name NOT LIKE '%测试%')
  AND (d.name NOT LIKE '%test%')
  and d.status ='SUCCESS'
  AND d.amount/100>100
  AND d.student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
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
                              88452392,
                              122839998,
                              247444506)
  group by c.qudao


渠道用户接通率
#某渠道接通率
select count(a.telephone_number) as '用户数',sum(if(b.status = 28, 1, 0)) as '接通数',count(b.customer_number) as '呼出数',sum(if(b.status = 28, 1, 0))/count(b.customer_number) as '接通率'
from crm_form_record a left join crm_call_outcome_record b 
on a.telephone_number=b.customer_number
where a.source like '%神龙币%'

#渠道接通率对比
select a.source,count(distinct a.telephone_number) as '用户数',sum(if(b.status = 28, 1, 0)) as '接通数',count(b.customer_number) as '呼出数',
from crm_form_record a left join crm_call_outcome_record b 
on a.telephone_number=b.customer_number
where from_unixtime(b.start_time)>='2017-08-01'
group by a.source
order by '接通率'





#渠道各环节转化率
select a.source,count(a.telephone_number) as '用户数',count(b.customer_number) as '呼出数',sum(if(b.status = 28, 1, 0)) as '接通数','完成试听数','成单数',
sum(if(b.status = 28, 1, 0))/count(b.customer_number)as'接通率',
/sum(if(b.status = 28, 1, 0))as'接通试听率',
/as'试听转化率'
from crm_form_record a 
left join crm_call_outcome_record b on a.telephone_number=b.customer_number
left join  


-----------

某特定渠道用户跟进清单
#select k.telephone_number as '用户手机号码',k.source as '渠道',k.user_id as '用户ID',
#sum(k.tels) as '拨打电话数',sum(if(tels>0,1,0))as '拨打用户数',sum(k.tel) as '接通电话数',sum(if(tel>0,1,0))as '接通用户数',
#sum(k.st) as '完成试听数',sum(if(k.st>0,1,0)) as '试听用户数',sum(k.cd)as'成单数',sum(if(k.cd>0,1,0))as '成单用户数',sum(k.fee)as'成单金额',
#sum(k.tels)/sum(if(tels>0,1,0)) as '平均拨打次数 3',
#sum(k.tel)/sum(k.tels) as '拨打接通率 30%',
#sum(if(tel>0,1,0))/sum(if(tels>0,1,0)) as'用户接通率 50%',
#sum(k.st)/sum(if(tel>0,1,0)) as'接通用户-试听率 2%',
#sum(k.cd)/sum(k.st) as'试听-成单率 10%',
#sum(k.cd)/sum(if(tels>0,1,0)) as'拨打用户-成单率 0.05%',
#sum(k.fee)/sum(if(tels>0,1,0)) as'ROI'
#from (


 #Mysql脚本

#资源数据 资源创建时间 


select w.telephone_number as'手机号码',w.source as'渠道',w.user_id as'用户ID',w.t1 as'线索创建时间',x.ccs as '跟进咨询师数',x.client_name as'拨打咨询师', x.fc as'首次拨打时间',x.tels as'拨打次数',x.tel as'接通次数',y1.planner_name as'试听咨询师',y1.tutor_record_id as '试听课ID',y1.t2 as '试听课创建时间',y1.t3 as '试听课上课时间' ,y.t4 as '试听课完成时间',z.t5 as'成单时间',z.fee as'成单金额'
from 
#资源&拨打数据 资源创建时间 跟进咨询师人数 首次拨打时间 拨打次数 [首次接通时间] 接通次数 
(select a.telephone_number,c.user_id,a.source ,min(from_unixtime(a.create_time)) as t1
from crm_form_record a left join user_online c
on a.telephone_number=c.telephone_num
where from_unixtime(a.create_time)>='2017-10-27'#在这里可以更改线索创建或者首次呼出时间#
and a.source like '%599zuowen%' #在这里可以更改或补充想要看的线索# 
group by a.telephone_number) as w
left join 
(select b.customer_number,count(distinct b.client_name) as ccs,b.client_name,min(from_unixtime(b.start_time))as fc ,count(b.customer_number) as tels,sum(if(b.status=28,1,0)) as tel
from crm_call_outcome_record b
where from_unixtime(b.start_time)>='2017-10-27'#在这里可以更改呼出时间#
group by b.customer_number) as x
on w.telephone_number=x.customer_number
left join
#试听数据 创建试听时间 邀约试听时间
(select d.student_user_id,d.tutor_record_id,d.planner_name,from_unixtime(d.create_time) as t2,from_unixtime(d.start_time) as t3
from tutor_preorder d
where d.category = 'DEMO'
	AND d.name not like '题目%'
	AND d.content not like '内容%'
	AND d.name NOT LIKE '测试%'
	AND d.content NOT LIKE '测试%'
	AND from_unixtime(d.create_time)>='2017-10-27'#试听课创建时间，要在活动时间之后#
	AND d.student_user_id NOT IN (250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,247444506)
	group by d.student_user_id) as y1
on w.user_id=y1.student_user_id
left join
#试听数据 邀约试听时间 完成试听时间
(select d.student_user_id,from_unixtime(floor(e.end_time/1000)) as t4
from tutor_preorder d left join audio_record_info e
on d.tutor_record_id = e.tutor_record_id
where d.status NOT LIKE 'CANCEL'
	AND d.category = 'DEMO'
	AND d.name not like '题目%'
	AND d.content not like '内容%'
	AND d.name NOT LIKE '测试%'
	AND d.content NOT LIKE '测试%'
	AND d.tutor_record_id = e.tutor_record_id
	AND from_unixtime(floor(e.start_time/1000)) IS NOT NULL
	AND round((e.end_time-e.start_time)/60000) > 15
	AND d.student_user_id NOT IN (250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,247444506)
	group by d.student_user_id) as y
on y1.student_user_id=y.student_user_id
left join
#成单数据 成单时间 成单金额
(SELECT f.student_user_id,from_unixtime(f.update_time) as t5,sum(f.amount/100) as fee
FROM series_order f
WHERE (f.note NOT LIKE '%zyb%')
  AND (f.name NOT LIKE '%测试%')
  AND (from_unixtime(f.update_time)>='2017-10-27')#订单支付时间，要在活动时间之后#
  AND (f.name NOT LIKE '%test%')
  and f.status ='SUCCESS'
  AND f.amount/100>100
  AND f.student_user_id NOT IN (148811250,141321906,141321906,43744461,250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,88452392,122839998,247444506,247673969)
 group by f.student_user_id) as z 
on w.user_id=z.student_user_id 
group by w.telephone_number
order by w.t1

#) as k
#group by k.telephone_number



-------
select count(k.telephone_number) as '用户数',count(k.user_id) as 'ID用户数',
sum(k.tels) as '拨打电话数',sum(if(tels>0,1,0))as '拨打用户数',sum(k.tel) as '接通电话数',sum(if(tel>0,1,0))as '接通用户数',
sum(k.st) as '完成试听数',sum(if(k.st>0,1,0)) as '试听用户数',sum(k.cd)as'成单数',sum(if(k.cd>0,1,0))as '成单用户数',sum(k.fee)as'成单金额',
sum(k.tels)/sum(if(tels>0,1,0)) as '平均拨打次数 3',
sum(k.tel)/sum(k.tels) as '拨打接通率 30%',
sum(if(tel>0,1,0))/sum(if(tels>0,1,0)) as'用户接通率 50%',
sum(k.st)/sum(if(tel>0,1,0)) as'接通用户-试听率 2%',
sum(k.cd)/sum(k.st) as'试听-成单率 10%',
sum(k.cd)/sum(if(tels>0,1,0)) as'拨打用户-成单率 0.05%',
sum(k.fee)/sum(if(tels>0,1,0)) as'ROI'
from 
(
select x.telephone_number,x.user_id,x.source,x.tels,x.tel,y.st,z.cd,z.fee
from 
(select b.telephone_number,c.user_id,count(b.customer_number) as tels,sum(if(b.status=28,1,0)) as tel
from crm_call_outcome_record b 
left join user_online c 
on b.telephone_number=c.telephone_num
where from_unixtime(a.create_time)>='2017-04-01'#在这里可以更改线索创建或者首次呼出时间#
and  b.telephone_number in (13403260170, 13513224631, 13630854479, 13633229506, 13730205608, 13730222626, 13730226655, 13931223146, 13730470187, 13733370097, 15103120866, 13633121666, 13803276028, 15103121216, 13832221358, 13731682096, 15533120371, 13832292078, 13832299753, 15176291367, 13833213607, 13513326272, 13903320662, 15081200056, 13932258495, 13933232581, 15903120944, 15028239380, 13733220248, 15103128702, 15103322104, 13400390961, 15284221845, 15512278228, 15832276179, 13784965566, 15903127580, 15930238880, 15932129622, 18830209836, 13785233258, 13001875428, 15103122888, 13582226988, 13903128583, 13784435666, 13903128765, 13613321464, 15990643211, 13082360081, 13102965189, 13833200066, 13933231868, 13103129254, 13722208486, 15231265517, 13131233239, 13513223809, 13171678908, 13931282619, 13230632086, 13484281028, 13313125885, 15231294233, 13613126333, 13932250992, 13603128281, 13315292899, 13323244357, 13331215656, 13785281133, 15632282635, 13603125799, 13703129112, 15032235677, 15903124444, 13780327067, 15231274931, 13582053753, 13803273578, 13403263333, 13463206519, 13463284432, 13463688686, 13463691349, 13933288700, 13472214992, 15033255029, 13473210396, 13463829229, 13473425476, 13483211169, 13931287189, 13931384833, 18833265534, 13483458748, 13930221456, 13931699957, 13503127858, 13503223007, 13930203173, 15831298598, 13503364658, 15103123567, 15830899198, 13931217359, 13513123617, 13933247022, 13803122608, 13930826265, 13930859603, 13513226865, 15930859603, 13513322033, 13931202895, 13513432459, 15531205218, 15831531560, 15931895038, 15132223222, 13582057693, 18732222222, 13582210024, 13831205588, 15931899999, 15832207216, 13582229498, 15832218528, 13582231126, 13582234128, 13582255256, 13582255568, 13582257955, 13930292860, 18233312003, 13831243919, 13582272598, 13582276555, 13832256516, 13582394722, 13582398222, 13633220777, 15832238081, 13903127248, 15930293201, 13603328585, 18331140538, 13643126173, 13930262950, 13603240311, 13603247499, 13603249268, 13603288886, 13784966958, 13930804039, 15103120288, 13733388088, 13784966947, 13613224634, 15033232344, 13613324958, 13613326096, 13613329157, 13613395008, 13833006669, 13833099686, 15720109799, 13633125572, 15188666388, 13633221112, 15832239658, 15031965035, 15188655821, 13931231772, 13933216130, 13784978666, 13633388788, 15720026678, 13643393494, 15081238855, 13513228883, 13722225618, 13653229772, 13653228812, 13663125310, 18132565888, 13472270998, 15350627995, 13663243363, 13663302888, 13833089300, 13663314446, 13663319961, 13930238659, 15128298800, 13012077999, 13673280186, 13930866088, 13722223218, 13700329794, 13333126209, 13833018181, 15033753888, 13703120635, 15930280119, 13703120336, 13703127027, 13703122229, 13703128899, 13513129276, 15830256993, 13833001691, 13703223697, 13833002100, 15713320088, 13703329867, 15031238888, 13722201687, 13722207978, 15713329988, 13730204581, 13833030171, 13582057676, 13932276615, 13903325968, 13930899278, 13722232320, 13722236817, 15930257099, 18632235505, 15103123831, 15932233133, 13722285892, 13731236213, 13722425988, 15931788064, 15176306575, 15903120287, 13315280000, 13331232000, 13730151299, 13730155511, 18833218688, 13930248594, 13730182031, 18231263380, 13730209018, 13730209093, 13400261799, 13473240101, 13730228890, 13730251978, 13832255332, 13930886518, 13730151222, 13831268877, 13932260798, 13730293008, 15103120268, 13730299828, 13730449677, 13731050117, 15130285716, 13731228255, 13780420788, 13731239306, 13731250902, 13731253158, 13731258505, 13930878999, 13731287680, 13582261040, 15033761705, 13730274116, 15933785288, 13932253882, 13932287768, 13733228187, 13903126428, 13932295587, 13903223399, 13733395086, 13903326969, 13013255455, 13780248887, 13730273104, 13722285757, 15903125302, 13784283338, 13933202123, 18631225568, 13784957037, 15128990778, 15188985188, 13722231077, 13930205931, 15033258228, 15033286966, 13785210814, 13785211976, 13931251946, 13785233010, 15231231880, 13703128162, 13785257356, 13785257885, 13730290131, 13731470070, 15933773565, 13785284566, 13673129675, 13803128899, 13803272311, 13693369839, 13483290579, 13803288017, 13582087880, 13785225341, 13831208339, 13831218812, 15128493007, 13582399969, 15103129182, 13831227979, 13831228485, 13831228678, 13582213722, 15603125666, 13931695365, 13785266757, 13811733019, 15128279998, 13831280066, 15830958880, 13603129925, 13833029527, 13832210265, 13633221361, 15831515521, 13739706503, 13832219685, 13903129310, 13832241252, 13521567092, 17732205176, 13832252728, 13633228088, 15531278879, 13832256886, 15232943319, 13832261790, 13832262555, 13832276815, 13832280299, 15830297670, 13831293028, 13832299185, 13833003368, 15027885760, 13373320973, 13903124813, 13833003021, 13933277672, 13833006159, 13833012432, 13833006861, 18732270111, 13483449990, 13833012808, 13833013298, 13833013809, 13833013823, 13833015090, 13833276764, 13603288919, 13603326611, 15803120663, 15830881528, 13933270722, 18632232926, 13582269861, 13931369800, 13832291178, 13833069993, 15933550026, 13103126518, 15933909592, 13722295165, 13832210428, 13833222656, 13833226419, 13833243344, 15603230056, 13833291999, 13833299338, 13903120912, 13903121073, 13903121270, 18131279017, 13831219552, 13931364799, 15033773377, 13903126293, 15930732777, 15003120111, 18832202003, 13930856870, 15033206452, 13903129337, 13663307668, 13903220066, 13931364535, 13932296918, 17717127007, 13722430230, 13733395259, 13903329016, 15175211508, 15932120592, 13582625535, 13930202051, 13722263631, 13903320119, 13930206090, 13931698811, 13400339899, 13930806611, 13903327987, 13930242275, 13930248155, 13930200971, 13930254312, 13784273230, 13930236361, 13930272992, 13784368338, 13930282900, 15103321155, 13930288887, 13833009918, 13930297599, 13930800986, 13931255591, 13930805111, 13833058515, 13930808295, 13633385888, 13032012567, 13831254101, 13785233666, 13930819558, 13831222818, 13292930688, 13930828717, 13930835571, 13582230688, 13703320219, 13831256626, 13931217691, 13931396922, 15931786866, 13930861308, 13671071944, 13930866459, 13930866998, 13503120170, 13930870725, 13693336812, 13933256536, 13582994443, 13930881460, 15033807755, 13930898079, 13630857341, 13833043345, 13931206893, 13931206967, 13733325818, 13931211556, 13930816809, 18631268763, 13931227777, 15127278658, 18131257921, 13733222092, 13931241998, 13931248221, 13930269983, 18330278575, 13582266938, 13613121911, 13230207218, 13333023810, 13931268816, 13931270899, 13931281638, 13070594567, 13931286608, 13722277753, 13931288025, 13931290069, 13582998889, 13933263699, 13931298811, 13931359133, 13832250163, 15033788918, 13931366616, 15103128779, 13931378799, 13931382680, 15933779995, 13651203915, 13931386720, 13730291548, 13931691403, 18003329386, 15933768222, 18031271234, 13931699638, 15128221232, 13932221122, 13932223831, 13932225116, 13932226864, 13932229299, 18632239162, 13833068081, 13933216822, 15531280000, 15931873000, 13932268285, 18131218507, 13932285133, 18131218537, 13503387225, 15132268080, 13703120119, 15512267630, 13933212229, 13930856966, 13730225666, 15833335333, 13933225739, 18330290059, 13503226918, 13722970866, 13503328046, 13933242332, 13722244385, 13731203969, 13933256888, 13933260510, 13933262496, 18931236388, 13663222056, 13933273666, 13933294608, 13833265168, 13730263666, 13933290101, 13653225566, 13833015555, 13333222330, 13933898568, 13933975258, 13933978006, 13930808738, 13996279351, 13603123298, 15003322336, 15022692660, 15028219474, 15028281972, 15030209993, 18833219998, 15031237146, 13831252066, 13703120170, 15031644018, 13722220110, 15031978331, 15032210806, 13731281193, 15032483440, 13832200381, 15033228690, 13513222509, 15033240075, 13513223313, 13931234567, 18803128858, 15033728669, 15033744075, 13503382215, 13930880185, 13832283812, 15033773554, 13932259075, 13930279808, 15075286692, 13933297060, 15832279999, 15081286066, 15132277626, 15100233555, 18233318898, 15103120289, 15132277636, 15103120896, 15103120908, 13784280328, 15103121237, 13930828386, 15103122600, 15103122706, 13784958559, 13785260842, 13111653586, 15103128703, 15932022433, 13315255508, 13831296669, 13730227738, 18132394009, 13633320311, 13931253683, 13633328333, 15128975868, 15128976599, 13933222910, 13933276553, 15131228936, 15131293880, 13703120985, 13933896565, 13082310360, 13111652935, 13730175725, 15133209686, 15133216881, 15133219090, 15133260068, 13933979550, 15175268588, 13931385772, 15176236866, 15130429789, 18831257886, 13703129873, 13903220062, 13930808730, 15188680634, 15188797918, 13930808804, 15194779088, 13013258507, 13582050062, 15200090725, 15200091878, 15227043477, 15227068888, 15230207733, 15230436277, 15231221068, 13703129905, 15231244777, 13703288810, 15231271917, 15103121797, 15713021777, 15231981666, 15232260779, 15232901505, 15232927923, 13930283101, 15232980090, 15233122333, 15233704120, 18831200121, 15284220585, 13931696611, 18348933653, 15530210586, 15031296633, 13931290129, 15200055333, 13803129202, 15533275510, 13930876261, 13933235370, 15603261116, 15603261117, 15631239969, 13832291234, 13730167891, 15703121797, 15712576555, 15831471518, 15713026081, 15097405952, 15132268969, 15713323376, 15933125050, 15933125059, 15720088598, 13331268111, 15720088838, 13731670889, 13931230353, 15832278005, 15803223728, 15930261195, 15830837089, 15830291583, 17736262815, 15830798276, 13832238686, 18833219696, 13930224488, 15830919082, 15830955366, 15833855888, 15831245498, 13930229071, 15831286187, 18131218759, 13315225511, 13784975979, 13363125700, 13633228068, 15831575886, 15832206896, 15832207069, 13663120060, 15713126799, 13032058999, 13930855255, 15832254441, 13833088881, 13933225917, 15833332328, 13833088882, 13722224331, 15833862956, 15803328800, 15903120335, 13483233158, 15903125071, 15903125095, 15903125283, 13930869382, 15903125488, 15903128271, 15930042383, 13582291035, 15030291333, 13722961162, 15803125668, 13831226173, 15930046962, 13833066885, 13833066889, 15931292530, 15931769001, 15931789298, 13663328150, 13730295528, 15931827585, 15931838583, 15931861242, 15233707783, 13832221207, 13833020905, 13832216401, 13930840905, 15932230577, 13903121359, 15932289698, 13903121395, 13833000838, 15933125991, 15933127373, 15933452562, 13833000868, 15933730882, 13663128218, 15933773003, 13663129318, 13633228808, 15933784991, 13730282828, 15194976666, 15933928326, 15831255888, 13503380358, 13731656789, 13102999666, 13832213220, 13931262566, 18031289956, 15803120096, 13831263711, 13903368808, 13931257076, 13931261971, 13722431777, 18803125719, 13733387337, 18233257516, 15930761222, 13930860656, 18233329886, 13933209960, 18330279267, 18330286100, 13703366328, 18330290819, 13722216088, 18331263298, 15175399317, 18531221022, 18630299949, 13903123018, 13131288878, 13315226099, 13933231387, 15188601640, 18633636771, 18730209584, 18730223487, 18731209906, 18731293180, 18731295632, 13903363366, 18732231885, 15831515881, 18733267198, 18803121102, 18803122299, 13832282336, 13832247539, 18803129808, 18830204265, 13833016866, 18831266566, 13931298568, 18832221699, 15633272698, 13582219606, 13932233505, 13803280192, 18833267799, 18833280105, 18903127038, 18903361662, 18903366869, 18931217216, 13832260755) #在这里可以更改或补充想要看的线索#
group by a.telephone_number) as x
left join
(select d.student_user_id,count(d.pid) as st
from tutor_preorder d left join audio_record_info e
on d.tutor_record_id = e.tutor_record_id
where d.status NOT LIKE 'CANCEL'
	AND d.category <> 'SERIES'
	AND d.name not like '题目%'
	AND d.content not like '内容%'
	AND d.name NOT LIKE '测试%'
	AND d.content NOT LIKE '测试%'
	AND d.tutor_record_id = e.tutor_record_id
	AND from_unixtime(floor(e.start_time/1000)) IS NOT NULL
	AND round((e.end_time-e.start_time)/60000) > 15
	AND d.student_user_id NOT IN (250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,247444506)
	group by d.student_user_id) as y
on x.user_id=y.student_user_id
left join
(SELECT f.student_user_id,count(f.pid) as cd,sum(f.amount/100) as fee
FROM series_order f
WHERE (f.note NOT LIKE '%zyb%')
  AND (f.name NOT LIKE '%测试%')
  AND (f.name NOT LIKE '%test%')
  and f.status ='SUCCESS'
  AND f.amount/100>100
  AND f.student_user_id NOT IN (148811250,141321906,141321906,43744461,250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,88452392,122839998,247444506,247673969)
 group by f.student_user_id) as z 
on x.user_id=z.student_user_id ) as k



----------
年级维度转化率分析-创建
select k.grade as '年级',count(k.telephone_number) as '用户数',count(k.user_id) as 'ID用户数',
sum(k.tels) as '拨打电话数',sum(if(tels>0,1,0))as '拨打用户数',sum(k.tel) as '接通电话数',sum(if(tel>0,1,0))as '接通用户数',
sum(k.st) as '完成试听数',sum(if(k.st>0,1,0)) as '试听用户数',sum(k.cd)as'成单数',sum(if(k.cd>0,1,0))as '成单用户数',sum(k.fee)as'成单金额',
sum(k.tels)/sum(if(tels>0,1,0)) as '平均拨打次数 3',
sum(k.tel)/sum(k.tels) as '拨打接通率 30%',
sum(if(tel>0,1,0))/sum(if(tels>0,1,0)) as'用户接通率 50%',
sum(k.st)/sum(if(tel>0,1,0)) as'接通用户-试听率 2%',
sum(k.cd)/sum(k.st) as'试听-成单率 10%',
sum(k.cd)/sum(if(tels>0,1,0)) as'拨打用户-成单率 0.05%',
sum(k.fee)/sum(if(tels>0,1,0)) as'ROI'
from 
(
select x.telephone_number,x.user_id,x.grade,x.tels,x.tel,y.st,z.cd,z.fee
from 
#拨打数据
(select a.telephone_number,c.user_id ,a.grade,count(b.customer_number) as tels,sum(if(b.status=28,1,0)) as tel
from crm_form_record a left join crm_call_outcome_record b 
on a.telephone_number = b.customer_number
left join user_online c 
on a.telephone_number=c.telephone_num
where from_unixtime(a.create_time)>='2017-04-01'#在这里可以更改线索创建或者首次呼出时间#
group by a.telephone_number
) as x
left join
#试听课数据
(select d.student_user_id,count(d.pid) as st
from tutor_preorder d left join audio_record_info e
on d.tutor_record_id = e.tutor_record_id
where d.status NOT LIKE 'CANCEL'
	AND d.category <> 'SERIES'
	AND d.name not like '题目%'
	AND d.content not like '内容%'
	AND d.name NOT LIKE '测试%'
	AND d.content NOT LIKE '测试%'
	AND d.tutor_record_id = e.tutor_record_id
	AND from_unixtime(floor(e.start_time/1000)) IS NOT NULL
	AND round((e.end_time-e.start_time)/60000) > 15
	AND d.student_user_id NOT IN (250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,247444506)
	group by d.student_user_id) as y
on x.user_id=y.student_user_id
left join
#成单数据
(SELECT f.student_user_id,count(f.pid) as cd,sum(f.amount/100) as fee
FROM series_order f
WHERE (f.note NOT LIKE '%zyb%')
  AND (f.name NOT LIKE '%测试%')
  AND (f.name NOT LIKE '%test%')
  and f.status ='SUCCESS'
  AND f.amount/100>100
  AND f.student_user_id NOT IN (148811250,141321906,141321906,43744461,250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,88452392,122839998,247444506,247673969)
 group by f.student_user_id) as z 

on x.user_id=z.student_user_id ) as k
group by k.grade
order by '年级'

拨打
select k.grade as '年级',count(k.telephone_number) as '用户数',count(k.user_id) as 'ID用户数',
sum(k.tels) as '拨打电话数',sum(if(tels>0,1,0))as '拨打用户数',sum(k.tel) as '接通电话数',sum(if(tel>0,1,0))as '接通用户数',
sum(k.st) as '完成试听数',sum(if(k.st>0,1,0)) as '试听用户数',sum(k.cd)as'成单数',sum(if(k.cd>0,1,0))as '成单用户数',sum(k.fee)as'成单金额',
sum(k.tels)/sum(if(tels>0,1,0)) as '平均拨打次数 3',
sum(k.tel)/sum(k.tels) as '拨打接通率 30%',
sum(if(tel>0,1,0))/sum(if(tels>0,1,0)) as'用户接通率 50%',
sum(k.st)/sum(if(tel>0,1,0)) as'接通用户-试听率 2%',
sum(k.cd)/sum(k.st) as'试听-成单率 10%',
sum(k.cd)/sum(if(tels>0,1,0)) as'拨打用户-成单率 0.05%',
sum(k.fee)/sum(if(tels>0,1,0)) as'ROI'
from 
(
select x.telephone_number,x.user_id,x.grade,x.tels,x.tel,y.st,z.cd,z.fee
from 
#拨打数据
(select a.telephone_number,min(from_unixtime(b.start_time)) as fdt,c.user_id ,a.grade,count(b.customer_number) as tels,sum(if(b.status=28,1,0)) as tel
from crm_form_record a left join crm_call_outcome_record b 
on a.telephone_number = b.customer_number
left join user_online c 
on a.telephone_number=c.telephone_num
group by a.telephone_number
having fdt>='2017-09-01'#在这里可以输入线索首次呼出的时间 
) as x
left join
#试听课数据
(select d.student_user_id,count(d.pid) as st
from tutor_preorder d left join audio_record_info e
on d.tutor_record_id = e.tutor_record_id
where d.status NOT LIKE 'CANCEL'
	AND d.category <> 'SERIES'
	AND d.name not like '题目%'
	AND d.content not like '内容%'
	AND d.name NOT LIKE '测试%'
	AND d.content NOT LIKE '测试%'
	AND d.tutor_record_id = e.tutor_record_id
	AND from_unixtime(floor(e.start_time/1000)) IS NOT NULL
	AND round((e.end_time-e.start_time)/60000) > 15
	AND d.student_user_id NOT IN (250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,247444506)
	group by d.student_user_id) as y
on x.user_id=y.student_user_id
left join
#成单数据
(SELECT f.student_user_id,count(f.pid) as cd,sum(f.amount/100) as fee
FROM series_order f
WHERE (f.note NOT LIKE '%zyb%')
  AND (f.name NOT LIKE '%测试%')
  AND (f.name NOT LIKE '%test%')
  and f.status ='SUCCESS'
  AND f.amount/100>100
  AND f.student_user_id NOT IN (148811250,141321906,141321906,43744461,250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,88452392,122839998,247444506,247673969)
 group by f.student_user_id) as z 

on x.user_id=z.student_user_id ) as k
group by k.grade
order by '年级'



每个月渠道转化对比
select k.source as '渠道',count(k.telephone_number) as '用户数',count(k.user_id) as 'ID用户数',
sum(k.tels) as '拨打电话数',sum(if(tels>0,1,0))as '拨打用户数',sum(k.tel) as '接通电话数',sum(if(tel>0,1,0))as '接通用户数',
sum(k.st) as '完成试听数',sum(if(k.st>0,1,0)) as '试听用户数',sum(k.cd)as'成单数',sum(if(k.cd>0,1,0))as '成单用户数',sum(k.fee)as'成单金额',
sum(k.tels)/sum(if(tels>0,1,0)) as '平均拨打次数 3',
sum(k.tel)/sum(k.tels) as '拨打接通率 30%',
sum(if(tel>0,1,0))/sum(if(tels>0,1,0)) as'用户接通率 50%',
sum(k.st)/sum(if(tel>0,1,0)) as'接通用户-试听率 2%',
sum(k.cd)/sum(k.st) as'试听-成单率 10%',
sum(k.cd)/sum(if(tels>0,1,0)) as'拨打用户-成单率 0.05%',
sum(k.fee)/sum(if(tels>0,1,0)) as'ROI'
from 
(
select x.telephone_number,x.user_id,x.source,x.tels,x.tel,y.st,z.cd,z.fee
from 
(select a.telephone_number,min(from_unixtime(b.start_time)) as fdt,c.user_id ,a.source,count(b.customer_number) as tels,sum(if(b.status=28,1,0)) as tel
from crm_form_record a left join crm_call_outcome_record b 
on a.telephone_number = b.customer_number
left join user_online c 
on a.telephone_number=c.telephone_num
where from_unixtime(a.create_time)>='2017-08-01' and from_unixtime(a.create_time)<'2017-09-01'#在这里可以更改线索创建或者首次呼出时间#
group by a.telephone_number
# having fdt>='2017-10-01' AND fdt<'2017-11-01'#在这里可以输入线索首次呼出的时间 
) as x
left join
(select d.student_user_id,count(d.pid) as st
from tutor_preorder d left join audio_record_info e
on d.tutor_record_id = e.tutor_record_id
where d.status NOT LIKE 'CANCEL'
	AND d.category <> 'SERIES'
	AND d.name not like '题目%'
	AND d.content not like '内容%'
	AND d.name NOT LIKE '测试%'
	AND d.content NOT LIKE '测试%'
	AND d.tutor_record_id = e.tutor_record_id
	AND from_unixtime(floor(e.start_time/1000)) IS NOT NULL
	AND round((e.end_time-e.start_time)/60000) > 15
	AND d.student_user_id NOT IN (250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,247444506)
	group by d.student_user_id) as y
on x.user_id=y.student_user_id
left join
(SELECT f.student_user_id,count(f.pid) as cd,sum(f.amount/100) as fee
FROM series_order f
WHERE (f.note NOT LIKE '%zyb%')
  AND from_unixtime(update_time)>='2017-08-01' and from_unixtime(update_time)<'2017-09-01' #订单支付区间
  AND (f.name NOT LIKE '%测试%')
  AND (f.name NOT LIKE '%test%')
  and f.status ='SUCCESS'
  AND f.amount/100>100
  AND f.student_user_id NOT IN (148811250,141321906,141321906,43744461,250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,88452392,122839998,247444506,247673969)
 group by f.student_user_id) as z 
on x.user_id=z.student_user_id ) as k
group by k.source
order by '渠道'















