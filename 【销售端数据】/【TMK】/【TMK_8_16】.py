#!/usr/bin/env python
# -*- coding: utf-8 -*-
from openpyxl.writer.excel import ExcelWriter
from openpyxl import load_workbook
import afanti_mysql as aft 
from afanti_mail import MailSender
import pandas 
import codecs
import types
import MySQLdb
import datetime
import os.path
import sys
reload(sys)
sys.setdefaultencoding('utf8') 

today = datetime.date.today()
delta_days = datetime.timedelta(days=1)
yesterday = today - delta_days
yesterday_day = datetime.datetime.strftime(yesterday, '%m-%d')
print yesterday
# ---------------------------------------------------
# ---------------------------------------------------
db = aft.connect('1on1_inner_db')

sql = 'select p.content,p.status, count(j2.customer_number),count(distinct j2.customer_number) \
        from crm_personnel p \
        left join (\
                select c.client_name,c.customer_number \
                from lzj0_call_outcome_record c  \
        where date_format(from_unixtime(c.start_time),"%m-%d") > "08-09") j2  \
        on p.content = j2.client_name\
        where p.role like "%TMK%" \
        group by p.content;'.format(yesterday_day)

cur = db.cursor()
cur.execute(sql)
result = cur.fetchall()
grid0 = pandas.DataFrame(list(result)).T
print grid0
# -------------------------------------------------------------------
# -------------------------------------------------------------------
# -------------------------------------------------------------------
# -------------------------------------------------------------------
db = aft.connect('1on1_inner_db')
sql = 'select  count(j2.customer_number),count(distinct j2.customer_number) \
        from crm_personnel p \
        left join (select c.client_name,c.customer_number from lzj0_call_outcome_record c  \
        where c.status = 28 \
        and date_format(from_unixtime(c.start_time),"%m-%d") > "08-09" ) j2 \
        on p.content = j2.client_name \
        where p.role like "%TMK%" \
        group by p.content;'.format(yesterday_day)

cur = db.cursor()
cur.execute(sql)
result = cur.fetchall()
grid = pandas.DataFrame(list(result)).T
print grid
grid0=pandas.concat([grid0,grid],ignore_index=True)
# --------------------------------------------------
# --------------------------------------------------
# --------------------------------------------------
db = MySQLdb.connect(host='10.173.39.219',
                     user='crm',
                     passwd='Aftcrmdb6yj8',
                     db='crm',
                     charset = 'utf8')

cur = db.cursor()
sql = 'select lead_id from crm_leads_info c \
where c.tmk_distributed="true" ;'
cur.execute(sql)
result = cur.fetchall()

a = []
# print result
for j in range(len(result)):
    b = list()
    for e in range(len(result[j])):
        b.append(result[j][e].encode('utf8'))
    a.append(''.join(b))

leads_id = '","'.join(a)
leads_id = '"'+leads_id+'"'
cur.close()

db = aft.connect('1on1_inner_db')

sql = ('select count(distinct j2.lead_id) \
        from crm_personnel j1 \
        left join (select c.lead_id,p.content from crm_personnel p \
        inner join crm_con_record c on p.content = c.owner \
        and date_format(from_unixtime(c.last_modify_time),"%m-%d") > "08-09" \
        and c.lead_id in ({0})) j2 \
        on j1.content = j2.content \
        where j1.role like "%TMK%" \
        group by j1.content;').format(leads_id,yesterday_day)
# print sql
cur = db.cursor()
cur.execute(sql)
result = cur.fetchall()
grid = pandas.DataFrame(list(result)).T
print grid
grid0=pandas.concat([grid0,grid],ignore_index=True)
# -------------------------------------------------------------------
# -------------------------------------------------------------------
db = aft.connect('1on1_inner_db')

sql = 'select count(distinct j2.customer_number) \
        from crm_personnel  j1 \
        left join \
        (select p2.content,o.customer_number \
            from crm_personnel p2 \
            left join lzj0_call_outcome_record o on p2.content = o.client_name \
            left join user_online u on o.customer_number = u.telephone_num \
            left join tutor_preorder t on u.user_id = t.student_user_id \
            left join tutor_preorder_info i on t.tutor_record_id=i.tutor_record_id \
            where p2.role like "%TMK%" \
            and u.user_name not like "%测试%" \
            and u.user_name not like "%test%" \
            and t.status = "BOOK" \
            and date_format(from_unixtime(t.create_time),"%m-%d") > "08-09" \
            and t.category = "DEMO" \
            and t.name not like "%测试%" \
            and t.content not like "%测试%" \
            and t.name not like "%题目%" \
            and t.content not like "%内容%" ) j2 \
        on j1.content = j2.content \
        where j1.role like "%TMK%" \
        group by j1.content ;'.format(yesterday_day)
# print sql
cur = db.cursor()
cur.execute(sql)
result = cur.fetchall()
grid = pandas.DataFrame(list(result)).T
print grid
grid0=pandas.concat([grid0,grid],ignore_index=True)
# -------------------------------------------------------------------
# -------------------------------------------------------------------
db = aft.connect('1on1_inner_db')

sql = 'select count(distinct j2.customer_number) \
        from crm_personnel  j1 \
        left join \
        (select p2.content,o.customer_number \
            from crm_personnel p2 \
            left join lzj0_call_outcome_record o on p2.content = o.client_name \
            left join user_online u on o.customer_number = u.telephone_num \
            left join tutor_preorder t on u.user_id = t.student_user_id \
            left join tutor_preorder_info i on t.tutor_record_id=i.tutor_record_id \
            where (i.period_confirm = 1) \
            and t.status = "BOOK" \
            and date_format(from_unixtime(t.create_time),"%m-%d") > "08-09" \
            and t.category = "DEMO" \
            and p2.role like "%TMK%" \
            and u.user_name not like "%测试%" \
            and u.user_name not like "%test%" \
            and t.name not like "%题目%" \
            and t.content not like "%内容%" ) j2 \
        on j1.content = j2.content \
        where j1.role like "%TMK%" \
        group by j1.content ;'.format(yesterday_day)
# print sql
cur = db.cursor()
cur.execute(sql)
result = cur.fetchall()
grid = pandas.DataFrame(list(result)).T
print grid
grid0=pandas.concat([grid0,grid],ignore_index=True)
# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------
db = aft.connect('1on1_inner_db')

sql = 'select count(distinct j2.customer_number), sum(j2.amount)/100 as e \
        from crm_personnel  j1 \
        left join \
        (select p2.content,o.customer_number,s.amount \
            from crm_personnel p2 \
            left join lzj0_call_outcome_record o on p2.content = o.client_name \
            left join user_online u on o.customer_number = u.telephone_num \
            left join series_order s on u.user_id = s.student_user_id \
            where (s.status = "SUCCESS") \
            and date_format(from_unixtime(s.create_time),"%m-%d") > "08-09" \
            and s.amount/100 >100 \
            and p2.role like "%TMK%" \
            and u.user_name not like "%测试%" \
            and u.user_name not like "%test%") j2 \
        on j1.content = j2.content \
        where j1.role like "%TMK%" \
        group by j1.content ;'.format(yesterday_day)
# print sql
cur = db.cursor()
cur.execute(sql)
result = cur.fetchall()
grid = pandas.DataFrame(list(result)).T
print grid
grid0=pandas.concat([grid0,grid],ignore_index=True)

grid0 = grid0.T

def fun(x,y):
    try:
        return "%.2f%%" % (float(x)/float(y) * 100)
    except:
        return 0
a =len(grid0[0]) 
print a

grid=[]
temp = []
for i in range(len(grid0[0])):
    temp.append(fun(grid0[4][i],grid0[2][i]))
grid.append(temp)
temp = []
for i in range(len(grid0[0])):
    temp.append(fun(grid0[5][i],grid0[3][i]))
grid.append(temp)
temp = []
for i in range(len(grid0[0])):
    temp.append(fun(grid0[6][i],grid0[5][i]))
grid.append(temp)
temp = []
for i in range(len(grid0[0])):
    temp.append(fun(grid0[8][i],grid0[6][i]))
grid.append(temp)
temp = []
for i in range(len(grid0[0])):
    temp.append(fun(grid0[9][i],grid0[8][i]))
grid.append(temp)
temp = []
for i in range(len(grid0[0])):
    temp.append(fun(grid0[10][i],grid0[3][i]))
grid.append(temp)
# print grid
grid1 = pandas.DataFrame(grid)
print grid1
print grid0
grid0 = pandas.concat([grid0.T,grid1],ignore_index=True)

grid0 = grid0.T
print len(grid0[0])
grid0.columns=[u'姓名',u'状态',u'拨打电话数', u'拨打用户数',u'接听电话数',\
    u'接听用户数',u'确认转CC',u'试听邀约数',u'试听完成数',u'订单完成数',u'订单金额',\
    u'拨打接通率=接听电话数/拨打电话数',u'用户接通率=接听用户数/拨打用户数',u'接通意向率=确认转CC/接通用户数',\
    u'意向试听率=试听完成数/确认转CC',u'试听成单率=订单完成数/试听完成数',u'ROI=订单金额/拨打用户数']
df1 = grid0.T
df1.to_excel('test.xls', header = 0, encoding = 'gbk')
# ---------------------------------------------------
# ---------------------------------------------------
yesterday_day = datetime.datetime.strftime(yesterday, '%m-%d')
db = aft.connect('1on1_inner_db')

sql = 'select p.content,p.status, count(j2.customer_number),count(distinct j2.customer_number) \
        from crm_personnel p \
        left join (\
                select c.client_name,c.customer_number \
                from lzj0_call_outcome_record c  \
        where date_format(from_unixtime(c.start_time),"%m-%d") = "{0}") j2  \
        on p.content = j2.client_name\
        where p.role like "%TMK%" \
        group by p.content;'.format(yesterday_day)

cur = db.cursor()
cur.execute(sql)
result = cur.fetchall()
grid0 = pandas.DataFrame(list(result)).T
print grid0
# -------------------------------------------------------------------
# -------------------------------------------------------------------
# -------------------------------------------------------------------
# -------------------------------------------------------------------
db = aft.connect('1on1_inner_db')
sql = 'select  count(j2.customer_number),count(distinct j2.customer_number) \
        from crm_personnel p \
        left join (select c.client_name,c.customer_number from lzj0_call_outcome_record c  \
        where c.status = 28 \
        and date_format(from_unixtime(c.start_time),"%m-%d") = "{0}" ) j2 \
        on p.content = j2.client_name \
        where p.role like "%TMK%" \
        group by p.content;'.format(yesterday_day)

cur = db.cursor()
cur.execute(sql)
result = cur.fetchall()
grid = pandas.DataFrame(list(result)).T
print grid
grid0=pandas.concat([grid0,grid],ignore_index=True)
# --------------------------------------------------
# --------------------------------------------------
# --------------------------------------------------
db = MySQLdb.connect(host='10.173.39.219',
                     user='crm',
                     passwd='Aftcrmdb6yj8',
                     db='crm',
                     charset = 'utf8')

cur = db.cursor()
sql = 'select lead_id from crm_leads_info c \
where c.tmk_distributed="true" ;'
cur.execute(sql)
result = cur.fetchall()

a = []
# print result
for j in range(len(result)):
    b = list()
    for e in range(len(result[j])):
        b.append(result[j][e].encode('utf8'))
    a.append(''.join(b))

leads_id = '","'.join(a)
leads_id = '"'+leads_id+'"'
cur.close()

db = aft.connect('1on1_inner_db')

sql = ('select count(distinct j2.lead_id) \
        from crm_personnel j1 \
        left join (select c.lead_id,p.content from crm_personnel p \
        inner join crm_con_record c on p.content = c.owner \
        and date_format(from_unixtime(c.last_modify_time),"%m-%d") = "{1}" \
        and c.lead_id in ({0})) j2 \
        on j1.content = j2.content \
        where j1.role like "%TMK%" \
        group by j1.content;').format(leads_id,yesterday_day)
# print sql
cur = db.cursor()
cur.execute(sql)
result = cur.fetchall()
grid = pandas.DataFrame(list(result)).T
print grid
grid0=pandas.concat([grid0,grid],ignore_index=True)
# -------------------------------------------------------------------
# -------------------------------------------------------------------
db = aft.connect('1on1_inner_db')

sql = 'select count(distinct j2.customer_number) \
        from crm_personnel  j1 \
        left join \
        (select p2.content,o.customer_number \
            from crm_personnel p2 \
            left join lzj0_call_outcome_record o on p2.content = o.client_name \
            left join user_online u on o.customer_number = u.telephone_num \
            left join tutor_preorder t on u.user_id = t.student_user_id \
            left join tutor_preorder_info i on t.tutor_record_id=i.tutor_record_id \
            where p2.role like "%TMK%" \
            and u.user_name not like "%测试%" \
            and u.user_name not like "%test%" \
            and t.status = "BOOK" \
            and date_format(from_unixtime(t.create_time),"%m-%d") = "{0}" \
            and t.category = "DEMO" \
            and t.name not like "%测试%" \
            and t.content not like "%测试%" \
            and t.name not like "%题目%" \
            and t.content not like "%内容%" ) j2 \
        on j1.content = j2.content \
        where j1.role like "%TMK%" \
        group by j1.content ;'.format(yesterday_day)
# print sql
cur = db.cursor()
cur.execute(sql)
result = cur.fetchall()
grid = pandas.DataFrame(list(result)).T
print grid
grid0=pandas.concat([grid0,grid],ignore_index=True)
# -------------------------------------------------------------------
# -------------------------------------------------------------------
db = aft.connect('1on1_inner_db')

sql = 'select count(distinct j2.customer_number) \
        from crm_personnel  j1 \
        left join \
        (select p2.content,o.customer_number \
            from crm_personnel p2 \
            left join lzj0_call_outcome_record o on p2.content = o.client_name \
            left join user_online u on o.customer_number = u.telephone_num \
            left join tutor_preorder t on u.user_id = t.student_user_id \
            left join tutor_preorder_info i on t.tutor_record_id=i.tutor_record_id \
            where (i.period_confirm = 1) \
            and t.status = "BOOK" \
            and date_format(from_unixtime(t.create_time),"%m-%d") = "{0}" \
            and t.category = "DEMO" \
            and p2.role like "%TMK%" \
            and u.user_name not like "%测试%" \
            and u.user_name not like "%test%" \
            and t.name not like "%题目%" \
            and t.content not like "%内容%" ) j2 \
        on j1.content = j2.content \
        where j1.role like "%TMK%" \
        group by j1.content ;'.format(yesterday_day)
# print sql
cur = db.cursor()
cur.execute(sql)
result = cur.fetchall()
grid = pandas.DataFrame(list(result)).T
print grid
grid0=pandas.concat([grid0,grid],ignore_index=True)
# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------
db = aft.connect('1on1_inner_db')

sql = 'select count(distinct j2.customer_number), sum(j2.amount)/100 as e \
        from crm_personnel  j1 \
        left join \
        (select p2.content,o.customer_number,s.amount \
            from crm_personnel p2 \
            left join lzj0_call_outcome_record o on p2.content = o.client_name \
            left join user_online u on o.customer_number = u.telephone_num \
            left join series_order s on u.user_id = s.student_user_id \
            where (s.status = "SUCCESS") \
            and date_format(from_unixtime(s.create_time),"%m-%d") = "{0}" \
            and s.amount/100 >100 \
            and p2.role like "%TMK%" \
            and u.user_name not like "%测试%" \
            and u.user_name not like "%test%") j2 \
        on j1.content = j2.content \
        where j1.role like "%TMK%" \
        group by j1.content ;'.format(yesterday_day)
# print sql
cur = db.cursor()
cur.execute(sql)
result = cur.fetchall()
grid = pandas.DataFrame(list(result)).T
print grid
grid0=pandas.concat([grid0,grid],ignore_index=True)

grid0 = grid0.T

def fun(x,y):
    try:
        return "%.2f%%" % (float(x)/float(y) * 100)
    except:
        return 0
a =len(grid0[0]) 
print a

grid=[]
temp = []
for i in range(len(grid0[0])):
    temp.append(fun(grid0[4][i],grid0[2][i]))
grid.append(temp)
temp = []
for i in range(len(grid0[0])):
    temp.append(fun(grid0[5][i],grid0[3][i]))
grid.append(temp)
temp = []
for i in range(len(grid0[0])):
    temp.append(fun(grid0[6][i],grid0[5][i]))
grid.append(temp)
temp = []
for i in range(len(grid0[0])):
    temp.append(fun(grid0[8][i],grid0[6][i]))
grid.append(temp)
temp = []
for i in range(len(grid0[0])):
    temp.append(fun(grid0[9][i],grid0[8][i]))
grid.append(temp)
temp = []
for i in range(len(grid0[0])):
    temp.append(fun(grid0[10][i],grid0[3][i]))
grid.append(temp)
# print grid
grid1 = pandas.DataFrame(grid)
print grid1
print grid0
grid0 = pandas.concat([grid0.T,grid1],ignore_index=True)

grid0 = grid0.T
print len(grid0[0])
grid0.columns=[u'姓名',u'状态',u'拨打电话数', u'拨打用户数',u'接听电话数',\
    u'接听用户数',u'确认转CC',u'试听邀约数',u'试听完成数',u'订单完成数',u'订单金额',\
    u'拨打接通率=接听电话数/拨打电话数',u'用户接通率=接听用户数/拨打用户数',u'接通意向率=确认转CC/接通用户数',\
    u'意向试听率=试听完成数/确认转CC',u'试听成单率=订单完成数/试听完成数',u'ROI=订单金额/拨打用户数']
df2 = grid0.T
df2.to_excel('test.xls', header = 0, encoding = 'gbk')


yest_in_name = datetime.datetime.strftime(yesterday, '%y年%m月%d日')
datafile_name = '17年08月09日--- %s TMK成员累计数据报表.xls' % yest_in_name

writer = pandas.ExcelWriter(datafile_name)
df1.to_excel(writer,sheet_name = u'累计',header=0,encoding = 'gbk',engine='xlwt')
df2.to_excel(writer,sheet_name = u'按天',header=0,encoding = 'gbk',engine='xlwt')
writer.save()
mail_sender = MailSender()
to_addresses = ["meijuan.li@lejent.cc","jerry@lejent.cc","jerry@lejent.com","john@lejent.com",\
"jun.zhu@lejent.com","salescommittee@lejent.com","zhijie.liu@lejent.com"]  # 收件人邮箱
# to_addresses = ['zhijie.liu@lejent.com']
mail_sender.send(to_addresses,
                 datafile_name,
                 '',
                 [datafile_name, ]
                 )
mail_sender.close()