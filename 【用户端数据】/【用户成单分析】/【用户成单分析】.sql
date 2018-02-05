
#1 2支付宝，3银联， 4wpay，5充值卡充值，6系统赠送， 7app store 支付，8微信公众帐号支付

select b.student_user_id,b.pid as '订单ID',from_unixtime(b.create_time) as '订单创建时间',from_unixtime(b.update_time) as '支付时间',from_unixtime(a.end_time) as '付款时间',b.amount/100 as '成单金额',
CASE
    WHEN a.charge_type=1 then '微信'
    WHEN a.charge_type=2 then '支付宝'
    WHEN a.charge_type=3 then '银联'
    WHEN a.charge_type=4 then 'wpay'
    WHEN a.charge_type=5 then '充值卡'
    WHEN a.charge_type=6 then '系统赠送'
    WHEN a.charge_type=7 then 'App store'
    WHEN a.charge_type=8 then '招行掌中宝'
    WHEN a.charge_type=11 then '支付宝'
    WHEN a.charge_type=14 then '微信'
    WHEN a.charge_type=15 then '百度支付'
    END as '支付渠道',
CASE
    WHEN b.payment="DEPOSIT" then '定金尾款'
    WHEN b.payment="FULL" then '全款'
    WHEN b.payment="INSTALL" then '分期付款'
    END as '支付方式',
CASE
          WHEN b.grade=1 then '一年级'
          WHEN b.grade=2 then '二年级'
          WHEN b.grade=3 then '三年级'
          WHEN b.grade=4 then '四年级'
          WHEN b.grade=5 then '五年级'
          WHEN b.grade=6 then '六年级'  
          WHEN b.grade=7 then '七年级'
          WHEN b.grade=8 then '八年级'  
          WHEN b.grade=9 then '九年级'
          WHEN b.grade=10 then '小学'  
          WHEN b.grade=11 then '高一'
          WHEN b.grade=12 then '高二'   
          WHEN b.grade=13 then '高三' 
          Else '其他'      
      END as '年级',
 CASE
          WHEN b.subject=1 then '语文'
          WHEN b.subject=2 then '数学'
          WHEN b.subject=3 then '英语'
          WHEN b.subject=4 then '科学'
          WHEN b.subject=5 then '物理'
          WHEN b.subject=6 then '化学'
          WHEN b.subject=7 then '地理'
          WHEN b.subject=8 then '历史'
          WHEN b.subject=9 then '生物'
          WHEN b.subject=10 then '政治'
          WHEN b.subject=11 then '知心导师'
       END as  '学科',
       b.deposit_out_trade_no as '订单号',
       b.deposit_amount/100 as '定金金额'
      from_unixtime(b.deposit_update_time) as '支付时间'   
from series_order b left join charge_record a 
on a.charge_no = b.out_trade_no 
where (b.note NOT LIKE '%zyb%')
  AND (b.name NOT LIKE '%测试%')
  AND (b.name NOT LIKE '%test%')
  and b.status ='SUCCESS'
  AND b.amount/100>100
  AND a.charge_type in ('1','14')
  AND b.student_user_id NOT IN (148811250,
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
                              247444506,
                              247673969)




定金支付
select deposit_out_trade_no as '订单号',deposit_amount/100 as '定金金额',from_unixtime(deposit_update_time) as '支付时间',phase
from series_order
WHERE deposit_update_time BETWEEN unix_timestamp('2017-08-01') AND unix_timestamp('2017-09-01')
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and payment ='DEPOSIT'
  AND amount/100>100
  and deposit_out_trade_no in ()
  AND student_user_id NOT IN (148811250,
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
                              247444506,
                              247673969)
group by deposit_out_trade_no

订单号查询支付类型
SELECT a.pid,b.charge_type
from series_order a join charge_record b 
on a.out_trade_no=b.charge_no
where pid in ('5FZkfmS45Fw', '5FwPyqdMTHb', '5FyrPFyPLrF', '5Fyysa6envp', '5G4kAirJiF4', '5GWt7HQanYC', '5HKC8uXEzLD', '5HKhEhWYBy2', '5HKm8tiUPcE', '5HXHSYJiECB', '5HqkjqsEeUB', '5J5CdGLEgfK', '5J82RGUB5K3', '5JMdWzx4U4h', '5JWgX7QDwWm', '5Jk2yWjVRXR', '5JkB9J5VFBn', '5JmfWqYYeuY', '5K4NeRZLevf', '5K4bd2TJ4mu', '5K4cgRsyjWe', '5KC4EHS57zY', '5KGa9WKwXwc', '5KatmjszLn3', '5KwMDjRdisu', '5KyuR89Jqwx', '5KzRqDJg426', '5L9ARuvfUYq', '5LMVvUKX64g', '5Lbzbe3itGn', '5Ln26Zmhdgz', '5LnXM59dxiv', '5LnZ9QnUuSe', '5LuXSmjWeP2', '5M2w6qfnu4n', '5M3YYsTR6i6', '5M4tFMyeF3N', '5MHz6exjruD', '5RURYiXE88L', '5RVCZyRGjmW', '5Rt9mbGNqPK', '5SFXE5TLuZj', '5SWppGkNfar', '5SYLepQz5FN', '5SdpkYdyVSz', '5SpXvmbD7jG', '5TavZASb4jQ', '5TcvxZbpxTN', '5TtWFVLkedr', '5TtXdvKqDrj', '5Ty7TdWDXsL', '5UA2gMgWCFQ', '5UFKutvVuxx', '5UGGLJazmdD', '5UJDaVUfF7s', '5UW7qAJfcFk', '5UfmfDRkKj4', '5Ug86N7xzrD', '5UqPeTEd6tC', '5V4T9qxYqLX', '5V6xRsDxB35', '5VDj3kyj8wv', '5VMkeCjaADZ', '5VW53QfzdQC', '5Vac5rEF3EQ', '5Vd3w4nPM53', '5VdBbuHdmRn', '5VyBmnJTKdJ', '5VyTuV5P3jB', '5VyxNMRjUW2', '5WYnQayttzj', '5WdSTVfhUyZ', '5WnuUzhY9Hp', '5WxaLrmT5dj', '5X7KzwJSbT7', '5XNaNsmC5hQ', '5XNdLu63g5n', '5XT5UHeyJwa', '5XaPTJtdMDs', '5Xuh8ybJDNU', '5YFxLitaba5', '5YGqdc9peAT', '5YK7vF7jCcR', '5YPSibbXzVm', '5YQh3MBkBzF', '5YSSS5FM7Ya', '5YWcKAQNn4F', '5ZDsqneexNS', '5ZEhjuCD4BX', '5ZFQs7kLyxV', '5ZFiE2KjtE8', '5ZG8JGVFj9s', '5ZNrrHNddZu', '5ZP6ARR6bTf', '5ZP77EWFauG', '5ZVx3hhmWgH', '5ZcAwYmVsrn', '5Zd2h56JdfF', '5ZdBT4ic8Q9', '5Zze9fzmTCW', '5a46YK6tBaZ', '5aBdDCHcqPi', '5aK9XYGKLrd', '5aQYybLtGGG', '5anNyWaHuGM', '5aqWbFkQk3i', '5b77DAYAp7T')

订单号查询学生ID
select pid, student_user_id
from series_order
where pid in ('56SkCir4Epc', '56SxjeMVB2S', '57EXEh9us4P', '57xBtPiUncS', '58hKYdhdVVx', '58hKmKkVg4D', '58hKxTvxuaX', '59RtwxTPuu6', '59vQ7hT47mF', '5AAkbhWqbus', '5AEMuXB2zxZ', '5AaLfdbYXXk', '5Aq9FwwUyTB', '5AqyKiRVEeW', '5Ar6zRA4PUf', '5AsDBZg8XWp', '5AsUBBDke4X', '5B2NthdQL48', '5BYfYZxFDZf', '5BeDmkFwnAH', '5BeFAHErS55', '5BeFahyJHbp', '5BeJFuKakGq', '5BmRBvAsgYZ', '5Bx9s4hLA7y', '5BxD4L63Yge', '5C4Sj8vWpWE', '5C5CFksnMrC', '5C6TZuQN8Sk', '5C6bGFkrvRj', '5C6yjaJyDWR', '5CBw3SBKctr', '5CDvGhtp2MB', '5CEPmKm2hAw', '5CEWDi4Njca', '5CEYJVJ8ntZ', '5CNi8bydiLs', '5CVNhQ5AsAA', '5CVgxgxsfQU', '5Ca3nWKSvHV', '5CcnQnAe4ip', '5CctC4fPE6E', '5CdpPBmwgtf', '5ChQjVacZAM', '5ChRPDwmtAp', '5ChZqetMqK9', '5ChhbQX6MFB', '5CjvFukNbVK', '5CkeEdu5fxP', '5CrtZqpMA9b', '5CsYUgKKMSb', '5Ct63vd4M4A', '5CyRP8p9fAi', '5CyXKCmiXVF', '5CzWjHWEYQ5', '5D2AdqtUU4t', '5D2Q5N8HnTg', '5D2aWFhZbE6', '5D3FHVuBUfz', '5D7vrjdUpu8', '5D8fBF5hMMu', '5D9PAm4a4sx', '5DAuGGnEsJg', '5DB8x9y9LyK', '5DBGV98SWhE', '5DG3NfY76s2', '5DR5q5K2tJ7', '5DSLHSnyipz', '5Dg6wrbfrxJ', '5Dh6KNr2B4i', '5DncJhAGpY2', '5Dp9fR4cGbL', '5DrVmNGLKtU', '5DuqWPdzAKS', '5Dvjm9MbmpC', '5DyMGEUJTzM', '5DyP9nABSkb', '5E56Szez3Eg', '5EEi3JvL574', '5EFEeYzubzg', '5EFGMCHYbZi', '5EFLYyhRxZj', '5ET9R6nTF6S', '5EUdfCAM8tt', '5EVvDSuuSR8', '5EW47majeBC', '5EaQi8egjWv', '5EaiESmecKc', '5EbTSPjNuPE', '5Ed8DWhC7KP', '5EdRqNzYvJX', '5EdyFduw2fU', '5EiD5D5RiVQ', '5EtvasJCdsa', '5EyuCwaYFdi', '5Ezrr7mi827', '5EzsVGDmJDG', '5F9PDN9tqCJ', '5FBnwnfwiqF', '5FBxhPKUyTq', '5FPHmk5FriB', '5FPZEVg2LVm', '5FPZEW7f5rB', '5FPtbiKMquc', '5FS92pamUHK', '5FSCvzmQcLm', '5FSQY69hVyB', '5FSswhzubwY', '5FZkfmS45Fw', '5FZwm8wQfqS', '5FhRPZ6W5Sx', '5FwLCB9Fv7v', '5FwPyqdMTHb', '5Fx3BqkPFKC', '5FyYPcc2Qn4', '5FyrPFyPLrF', '5Fyysa6envp', '5G4kAirJiF4', '5GDg7pF9kss', '5GFMW4bS8CL', '5GFd4ScWyj4', '5GL9jhn8DqV', '5GNC3sZ4Zby', '5GTbi8QuxWC', '5GTvbG9vCEu', '5GV3CSv6AGw', '5GVJDZssgue', '5GVxSbpwWS7', '5GWXiuUV3Ju', '5GWt7HQanYC', '5GctVVLZqjK', '5GkqRH3AAuA', '5GsCuHrM4pL', '5H8eJScdSma', '5H9mvwF42G7', '5HAmyHcigRa', '5HBFiHB27cN', '5HBKv6QxEjq', '5HFnupij5mM', '5HFw3E9buRa', '5HGkWRn5Vih', '5HHJnGhXy6x', '5HJB4v7aJau', '5HJjqYkmbcp', '5HKC8uXEzLD', '5HKgPYxwGQt', '5HKhEhWYBy2', '5HKm8tiUPcE', '5HTH9cKXein', '5HXHSYJiECB', '5HYGj5gV3Ed', '5Ha4yUE8Bz4', '5HaZMKGYraf', '5HajwAmMwzY', '5HnNpKzhHTk', '5HpMPJnZDLd', '5HqkjqsEeUB', '5Hvbqtus8YY', '5HvfVwkejDA', '5Hvu5DPBkTq', '5HyeH6cdRyu', '5HzJgh6ywUa', '5J5CdGLEgfK', '5J82RGUB5K3', '5J8LtHbzXdr', '5JEYwGyXqeh', '5JF4cUkS2CK', '5JFBtkian4V', '5JFFgczAyWC', '5JLJwRnVUMF', '5JMdWzx4U4h', '5JPGz5egN2T', '5JPWraxjA3Q', '5JTPRfqtnj5', '5JTvzYw8uzt', '5JV6Vpgmt9W', '5JVDSnewrFW', '5JW88KAtZDF', '5JWgX7QDwWm', '5Jd2JyhWKJV', '5Jk2yWjVRXR', '5JkB9J5VFBn', '5JkgqEZW2cd', '5JkqbjnBbH3', '5JmfWqYYeuY', '5JrvxWxWQLf', '5K2QUbsMz4Z', '5K32UmrTaLy', '5K3bwiX4tTQ', '5K3hfVQEMCE', '5K3qPZNqHyn', '5K4NeRZLevf', '5K4bd2TJ4mu', '5K4cgRsyjWe', '5K4ukR5X8Fs', '5K8ziTNKuMZ', '5K9CTJxsSVf', '5K9HmeTPXDN', '5K9SdxTbqKQ', '5KAabhvQT9U', '5KAybrQjAzt', '5KB9arshRdP', '5KBTmxyatfp', '5KBryzj4m4E', '5KC4EHS57zY', '5KCVGewu6r9', '5KGVEQHuA3A', '5KGa9WKwXwc', '5KGh4BqYpNR', '5KHNyKtj96T', '5KHiWqRmCW7', '5KJtpP3eNjR', '5KKQueayuSi', '5KKr6K7xVbQ', '5KKsP5vkGyw', '5KKsyiV8HHZ', '5KPkLwSkcff', '5KQ7mmZU38P', '5KQRi9ehT4e', '5KRaJb4x7U3', '5KS7KfjtfJ3', '5KSsvKM4Cy3', '5KT6JAhdV8T', '5KXszhRtDgm', '5KatmjszLn3', '5Kf9SmCwvvX', '5KfL5QAFDP5', '5KfaH7Hag4e', '5Kg7WsVuB32', '5KhcKj6A9Pa', '5Ki54VCQxMa', '5Ki8JaqURET', '5KnPzbppdrq', '5Knj3YcPvUW', '5KnunUn7xaN', '5KpnTwJcMBD', '5KrNAXhQqcC', '5KrpZ8sc5wu', '5KwEuwStmS7', '5KwMDjRdisu', '5Kx8GV2Kwj7', '5KxLjwVhJra', '5Ky74qPSVQF', '5KyAHCJecsy', '5KyuR89Jqwx', '5KzRqDJg426', '5KzeGaj77xx', '5L7uqGL3RM2', '5L9ARuvfUYq', '5LCyNXAsQDS', '5LDDSghX5uh', '5LE9QYgPGtZ', '5LFycp8UEUh', '5LMSv4ArhJz', '5LMVvUKX64g', '5LMcmRvWi4j', '5LNNQJu3MEa', '5LNTw8MxuUY', '5LPGb7drjc5', '5LPZVqExQV5', '5LParr3VcY4', '5LPt9iyipW8', '5LPyxyA7CFN', '5LQEfSurgbC', '5LQQt6ejAMn', '5LV2AFNtwu4', '5Lbzbe3itGn', '5LdCqSgDCcd', '5LeuzRtHnD4', '5Ljq5PJEa7B', '5LkWBUGPVAk', '5LktGjiQTGL', '5Lm8n5zWAEJ', '5LmsrCf9D5y', '5LmtDsinDwk', '5Ln26Zmhdgz', '5LnFW6bddBC', '5LnMXdNzqE8', '5LnXM59dxiv', '5LnZ9QnUuSe', '5Lnw9gSh2m8', '5LtXn5GLjhP', '5LtxSuS4JyP', '5LuRRt5Hx9w', '5LuXSmjWeP2', '5LudMerbyha', '5LupJTwXpPB', '5Lw4tShh7Tv', '5M2w6qfnu4n', '5M3VbhAwAFm', '5M3YYsTR6i6', '5M3zgheNfXR', '5M42NYVQKhR', '5M4ZrqcaMhi', '5M4gVjkyyp5', '5M4pKcy9ZBE', '5M4tFMyeF3N', '5MBCJrWWycm', '5MBcyDC4ETg', '5MC5DUjKPGf', '5MCAXXaSjBE', '5MD3ADNgAcd', '5MD73vkw3L3', '5MHHDSKKQsz', '5MHSR5QcYtv', '5MHgfaYF67q', '5MHiTdMeD5r', '5MHsBjunVs6', '5MHz6exjruD', '5MJA9bYkdMm', '5MJBywYRuZU', '5MJHpcQ9r6y', '5MJnh2wtdty', '5MKJY7itRaE', '5MKMy2Sjkt5', '5MKP26d2YSW', '5MKm7xa4KQD', '5MLLEpbhTtN', '5MQbR5ZEMM9', '5MQnPTifZdE', '5MQqeTRFDMf', '5MTrinzpDQb', '5MYVaEiAWVH', '5MagvdjFWRj', '5Mbq2UgxYmy', '5Mh6QZP6jzv', '5MitGPTjjbe', '5MsK8KLN2KP', '5Msdvqdwigb', '5MxAyRyYRPY', '5MyUYHSmcGv', '5Mye4ZJaQUQ', '5MzfZR7PWWk', '5N25jgWxv2k', '5N6iwiLhhhA', '5N78JBDrDkK', '5N7V7ervApY', '5N8iszRKiPR', '5N9VKwmvtA2', '5N9kuRNX6tY', '5N9v43gpWm9', '5N9zeWL3QcJ', '5NE9WCa6iSG', '5NGeMhwyPQt', '5NGyuadBsgn', '5NH2p3CTxpP', '5NLvWZzpaKa', '5NMw9qcjtZP', '5NMyzGrKiCB', '5NQFzWnp8iZ', '5NVEzuAszyU', '5NVnUeiNLq2', '5NVnsbpPBF6', '5NVnyzMJNTp', '5NVpr422mvX', '5NVrR2BnG9z', '5NVrXifxFE2', '5NVryu5LVJk', '5NWH94N5HEx', '5NWHKAvEt7m', '5NWHk2vH5KH', '5NWKiAXZTQp', '5NX2QNXUTVN', '5NXk3Gh4sZW', '5NY9kJDat8w', '5NdjuQwauxb', '5NfHsQGrs5D', '5NfMJxN7mxG', '5NfUMwcsK9Q', '5NfbzWjniA2', '5NjFjVMpY8A', '5Nk46nukrLu', '5Nka9NegBXk', '5NmVyw2FX6H', '5NntEhcKatk', '5NuRFsTg4h5', '5P3WKQSpWLE', '5P3gvbD9CPS', '5P4iFWL5q9F', '5P4kk427qj5', '5P5xrzCCHnk', '5PCLGJNrSjA', '5PDGrBa2Yh5', '5PHJ47s6Nbg', '5PJXSJUbihk', '5PKZusePYWE', '5PRKZSaf4ze', '5PRcDJnEJNc', '5PTei2Svmyr', '5PU6QfZZWR6', '5PZLEGJsnUc', '5PaSQgRrRQ5', '5PbXpcLCWzq', '5PbbFZZM9pV', '5PbdU3LJ7X3', '5Pbgt6yuxRs', '5PhJhPDE2kr', '5PhjhfxDL2n', '5PivbSJ4EJ7', '5Pj9imV8ZJe', '5PjJLrPs4pm', '5PjnqYA7PZ9', '5Pjnxdt4B85', '5Pjr347bVHm', '5Pk3LpQhyES', '5Ppia6y36QX', '5PqatdVHJqX', '5PqeLsVWZkX', '5PrkaLtWGMH', '5PrpVWm7qJS', '5PsnvLMn93f', '5PtFwPZWrYX', '5PxNyRuamut', '5PxfDW9eNvt', '5PyLaqaFW2y', '5Pyty84qujy', '5Q6EhnSMSsR', '5Q7UdJbAuMm', '5Q9hkSEigZn', '5QA4sa43sHy', '5QAALmdh2Lh', '5QAHxG64mza', '5QEQE4jHgZ4', '5QFeMHD8Buq', '5QNFs6AdfKw', '5QQd4EmttQg', '5QQiVqRL7cs', '5QUY7JFpGuc', '5QVFnNBQPCr', '5QXspY7mgTm', '5QYF2GaVSMy', '5QYJPZWvebW', '5QYMYX3s2GD', '5QYSc5CXHdP', '5Qd7WGxbfk7', '5QeDaRpgPx3', '5QfCNgTuTrE', '5QfHrmy4JZy', '5QfM3WwJGFB', '5QfqgaccEDz', '5Qg27byQXdd', '5QkUpHVESeU', '5QmNn9La2AG', '5QmUGKtRcN9', '5QnPe3v64EK', '5Qp7UGVQLNF', '5QpU2MJC5qq', '5Qppnh5KSyH', '5QtCQvFYAEk', '5QtDRqM7Zd8', '5QuN2pPTqVW', '5QudWwmZCGJ', '5QvjGZgrPQw', '5QxCAyQUR5F', '5R4ihdBgS9a', '5R5iXrHS555', '5RATW7VqTrx', '5RBG73UUDdK', '5RBnRAukuZ6', '5RDneqeGp64', '5RE3xnJcFfY', '5RE4ArAY4VL', '5RE6Y5VhKSu', '5RK5iCQq5ae', '5RLpKtxefVr', '5RM8biqcLqU', '5RMSaVNG6nR', '5RReZWRxSeE', '5RS6CdcyMFy', '5RSSxM3efxm', '5RSdrfBbKQn', '5RSp5eXtydT', '5RTAzZWiQVg', '5RTLxcXXUCa', '5RUPHNVx4BG', '5RURYiXE88L', '5RUeTBQLSP9', '5RUsMpvSGNK', '5RUuqxAEmw9', '5RVCZyRGjmW', '5Rb8YW5BVHh', '5RbvpL9znHt', '5Rcnn2VWphF', '5Rk4f2n57V4', '5Rr8yJVpDZZ', '5RrrFmQGwrC', '5Rt9mbGNqPK', '5Rz3ciJPazK', '5S289xkFp6H', '5S2VL9bydgU', '5SAKuLRk6Hm', '5SFXE5TLuZj', '5SRPmJ3vGnH', '5SWppGkNfar', '5SYLepQz5FN', '5SdhDgyGpDg', '5Sdhnn3yfgH', '5Sdpj9h8wuP', '5SdpkYdyVSz', '5SfkQS3VFmR', '5SfnEbz6VGn', '5SfpAxNEa8a', '5SgMqZ3zgAw', '5SgTLEq5e7q', '5SgU4AcVs8d', '5SpBdqEvXiG', '5SpMzAwdvTy', '5SpXvmbD7jG', '5SxPKeQWx3M', '5T3nuDiCEvK', '5T4pyWrQ3uU', '5TCRGtaiCtX', '5TCyeLwbdxw', '5TDTJySSM9c', '5TDXNwr2Wqb', '5TLLd5vH3aB', '5TV7cs3bQu8', '5TVLsZ8J2i5', '5TVZazDhbG6', '5TanhFB9q2p', '5TavZASb4jQ', '5TbXumduqa3', '5TcfaBArTes', '5TctBBAD9MX', '5TcvxZbpxTN', '5Tcxkpre7Cp', '5TggYMGugT6', '5TiZBxtazx3', '5TiaC3nGVnu', '5TkDugzz9hk', '5TkFpGm9wNd', '5TkcNzRAGtQ', '5TtWFVLkedr', '5TtXdvKqDrj', '5Ty7TdWDXsL', '5TzxEVa36AF', '5U3GAAkNgX2', '5U7kNCLLQHz', '5U85MTL3VBa', '5U9A6BriwXf', '5UA2gMgWCFQ', '5UA5n99Lwth', '5UA62pKHdNK', '5UAN8vNYmFQ', '5UApKhaLEHr', '5UAtukd3DR6', '5UFKutvVuxx', '5UFkyTfWdiV', '5UFqj7DZNTf', '5UGGLJazmdD', '5UHyZBgBEC9', '5UJDaVUfF7s', '5UNbyVd59xB', '5UNmJN3nzT7', '5UPXKPsj4xs', '5UPnduwwJdK', '5URcvQ6uS6d', '5US7AVUJMaG', '5US7Sv9QmZu', '5UW7qAJfcFk', '5UWBbyngsuv', '5UWLCMKepJk', '5UXAJDHuBJ6', '5UYACUR4yyz', '5UYAsGVDttx', '5UYVNSMFCHW', '5UYp89r63Jj', '5UYtKBgiuuw', '5UZAqvAGKRN', '5UZQA4sqhgc', '5UZQfTWF43p', '5UeeMtwGVpg', '5UefN8CLN7w', '5UetP8iduS4', '5Uf9a9VTZDD', '5UfDRkDNcJX', '5UfJc3BfWqG', '5UfkZTPpvpV', '5UfmfDRkKj4', '5Ug86N7xzrD', '5UgKTvYW8iW', '5UgfYdHrGKE', '5UmjwE5Qxnd', '5Un3EZxLJxQ', '5UnpfSGSxZV', '5Up9uSzTedy', '5UpNvssaLJH', '5UpTmUGHkHf', '5UqAnzFXzwC', '5UqL6c9KFK5', '5UqMHFHJ7wC', '5UqPeTEd6tC', '5UwTVgbeatW', '5UxFaCytYeq', '5UxGRARSuRk', '5UxMrP7JASb', '5UyXwQUZ63R', '5UyZcKVrve4', '5V3k29KjgTc', '5V4T9qxYqLX', '5V4gESFQDDv', '5V5G9vEYJDN', '5V5ZEs4bwFU', '5V6w3aAkUNr', '5V6xRsDxB35', '5VC9YBgAxVr', '5VDj3kyj8wv', '5VEBES6uzZg', '5VESDBMaP9U', '5VEYnPu7k4J', '5VEvcrRgC7n', '5VKTRJt74BZ', '5VL7mPWUR89', '5VLFaY7FE5p', '5VLewLPQfPk', '5VM4UJwPjcR', '5VMVcexFXqU', '5VMeHuYw5TB', '5VMjmRE8yVx', '5VMkeCjaADZ', '5VN2mhZkBaG', '5VU65DCFqZR', '5VUmJLMXNgs', '5VVKZVHug7r', '5VVR3zZGFwn', '5VVWA4F2Syi', '5VVmB6KnsQb', '5VVncrxajXE', '5VVzdPVgage', '5VW53QfzdQC', '5Vac5rEF3EQ', '5Vc6dv6DeGP', '5VcDV9hSvLh', '5VcrgG4MiLw', '5Vcx6e6gTeh', '5Vd3w4nPM53', '5VdBbuHdmRn', '5VdUQh7J5rq', '5ViTRLW4Zvm', '5Vk3zBfq93G', '5VkK7ZMdChM', '5VkMdJ4EuS4', '5VkRH5qLxmu', '5VkSyEY7iFh', '5Vu5cVhWLHp', '5VuAbHCBCQL', '5VyBJhF7MpN', '5VyBmnJTKdJ', '5VyTuV5P3jB', '5VyVFxFgL7u', '5VyxNMRjUW2', '5W22WnECrdd', '5W23SNTrq38', '5W2BiBY4NzB', '5W3AC5eYwdi', '5W3hGTcpELY', '5W8VcJ2NhDG', '5W8YHNr7ueH', '5W8xpK837EM', '5W9Teeb4Lph', '5W9iDeRYr69', '5WBAhnMxTzn', '5WBNVU4ak3p', '5WGG8W8tSmQ', '5WGUrpvpxTm', '5WGWFLLT7qc', '5WGXSERAmt3', '5WGgUkRNGYe', '5WHrxvciqFP', '5WHuBzHGJML', '5WPPfnQxjyx', '5WPQ8Wva9W8', '5WSVwGZbXKx', '5WWT62PVRvz', '5WWgNKzXMkd', '5WYnQayttzj', '5WZW25d8sDF', '5WZWziU2u2U', '5WZXa7LNZbt', '5WdSTVfhUyZ', '5WeAA6jJueh', '5WeGmptr2fX', '5WeHyeJEVQU', '5WgQTjYPyJa', '5WgeNLKWPbh', '5Wm3ifSmsdF', '5WnuUzhY9Hp', '5WrRqw6sTvc', '5WxaLrmT5dj', '5WxfvEpNZMA', '5Wy4SwSNs3m', '5X7B4W38tZ9', '5X7KzwJSbT7', '5X7TsrR8ngB', '5X7haXdMjHv', '5X8CetgAZnh', '5XCBXsVwdBS', '5XFHnr5eT9g', '5XKFtR9Qvb8', '5XKLmV7mUfd', '5XL32yaTfX9', '5XLYDBhq2y9', '5XLeGs3AFni', '5XM47m9Htv9', '5XMNip4QTCh', '5XN8nXL2pXN', '5XNHJxXB6c9', '5XNaNsmC5hQ', '5XNdLu63g5n', '5XNdWfRM3xD', '5XT2JNSGa2e', '5XT5UHeyJwa', '5XV46tXgxEf', '5XVPimsaWYE', '5XVkDLSkn7g', '5XW2wk5jEN6', '5XWDdxZUHAE', '5XaPTJtdMDs', '5XbRkmJpPup', '5XdC2Pg8EnT', '5XdVA292EPC', '5XdaiLkq6if', '5XsCcZfkndG', '5XsEkNvBdHn', '5Xuh8ybJDNU', '5XzhnVUB2KN', '5Y2xEPWEwV8', '5Y3DP8JnvvR', '5Y3ZwGxacx4', '5Y3kqrduRmD', '5Y9JfhPzijx', '5Y9wyWFMW2K', '5YAjbg4Qncn', '5YAnCvGm54x', '5YAnxZ67xr5', '5YFLX277uWj', '5YFZSVNCgnF', '5YFxLitaba5', '5YGqdc9peAT', '5YHDsJQ4zCe', '5YJidsTLJH8', '5YK5tHvhAXZ', '5YK7vF7jCcR', '5YPJQpcfkmN', '5YPSibbXzVm', '5YPvBWqycaB', '5YQB9ZfuMmP', '5YQh3MBkBzF', '5YRmw9eez2C', '5YS3FAn5ig5', '5YS8zgnvvgX', '5YSJ7qdbwCE', '5YSSS5FM7Ya', '5YSq7kNhniu', '5YWcKAQNn4F', '5YXnZU26bVe', '5YYxDxx3TTY', '5YZATJaq7dP', '5YZasPcRHd3', '5YZdmJkYD7F', '5YepG6wd7N6', '5YgJSWkbDjd', '5YgnrULypCG', '5YnSErhfkPK', '5Ypk33im2KC', '5YuxUgYYx7i', '5YvtfQwC9mA', '5YwYBtcEkPF', '5YyrCkYi9C8', '5Z7ShN7ivzK', '5Z7z7FvV9B7', '5Z83jUn3bqy', '5Z87VSJ2dFt', '5ZCkPPPnrJR', '5ZCm6JCUGBq', '5ZDsqneexNS', '5ZEhjuCD4BX', '5ZEwd9CGZtj', '5ZEyMrzScA8', '5ZF2tBFws4G', '5ZFMjKSV3rH', '5ZFQs7kLyxV', '5ZFWFmHvki3', '5ZFb2MEVMAU', '5ZFdQJPsGNe', '5ZFiE2KjtE8', '5ZG8JGVFj9s', '5ZKk5gQkUsM', '5ZLVBwuPqb3', '5ZLVH6Q8mba', '5ZLcECKaz6i', '5ZMY9STUXNK', '5ZNekJ8CqEL', '5ZNmz6py2vX', '5ZNpsPNHVMX', '5ZNrrHNddZu', '5ZP3apQJ8WV', '5ZP6ARR6bTf', '5ZP77EWFauG', '5ZTtsGAd8m4', '5ZUHppYJrmx', '5ZUNNg55Psb', '5ZUQ5ukchn8', '5ZUyGbB4C5m', '5ZVx3hhmWgH', '5ZWJCYAsfsS', '5ZbneiyBwVY', '5Zc5JV9sSbj', '5ZcAwYmVsrn', '5Zd2h56JdfF', '5ZdBT4ic8Q9', '5ZdFC25CwYG', '5ZdHtQhyXwe', '5ZdPd6dqmpk', '5ZdVU3T5BXR', '5ZdVXPx9dgh', '5ZdjEpt2PMc', '5ZdwK37X78k', '5Ze5duxMx9N', '5Ze6fHGdm3K', '5ZrVgPb8Wnr', '5Zze9fzmTCW', '5a3XaYfnrUg', '5a3mHQwaDJA', '5a46YK6tBaZ', '5a8Q6fhnTh4', '5aBVRUwSriH', '5aBdDCHcqPi', '5aC64eNbf8r', '5aGa6zZhCgq', '5aGmEUDZiit', '5aGycSaBMPy', '5aHUk3yzr8x', '5aHcZdW7RhN', '5aJCFMzLVUy', '5aJdY56YPkN', '5aK9XYGKLrd', '5aKG8PJJSEH', '5aKSVpEHmSa', '5aL6hwCRwXk', '5aQVvaerfP3', '5aQYybLtGGG', '5aRPyFi2wH5', '5aRyZGifQ6P', '5aSCS3u5DzJ', '5aX7rxzzTH5', '5aXkZzruZw2', '5aYBy7Kj6pp', '5aYUiNvaFNn', '5aZED98rsHp', '5afVBBR4dYJ', '5ahBXF397n4', '5ahJeDChcey', '5ahc6WPwEjM', '5ahmLRhVBKu', '5ahwvJpWSKm', '5anCFGUwBXS', '5anNyWaHuGM', '5apHYSE2yC5', '5apRqHGdqiP', '5apYM2kC9nR', '5aqWbFkQk3i', '5ara5Wr2W3r', '5avTiAk3QnD', '5avu3egB2Wp', '5awMcXSMnbs', '5awTuHygxZ9', '5awuW2j8wHC', '5axi7BWfhUu', '5axqK4FEaWn', '5ay4hsdRCad', '5ay8wWRHmJX', '5ayUbH5F9Nx', '5ayp4aQwju4', '5ayrmRTWh9D', '5aythAipwnU', '5ayvdSkiR9B', '5az4eXyjYVJ', '5b4u8SfHRju', '5b6L3URJ52a', '5b6cvauKX4R', '5b6p2zJPPYu', '5b6w9EqRYBt', '5b77DAYAp7T', '5b7ASXpFPpw', '5b7kacnkfPY', '5b7xtcVdiZa', '5b84XV5BEzi', '5b84mSrXv92', '5b86Lh6DZM4', '5b8CTxjEHGx', '5b8DmNUcKeu', '5b8Ke2VBeS2', '5b8S6JBcREH', '5b8V36Tghui', '5b8XVD3HPYf', '5b8j5vXrdfW', '5b8rwXeX77r', '5bCvg8udjpq', '5bDGEfF2MYp', '5bDSkygiWYS', '5bDyvcTrTsU', '5bE7DB6Lgqi', '5bEK6zUEqD8', '5bEPWAZMTfC', '5bEvEEpyCtM', '5bEvcdghmZq', '5bFfpQ9jBQL')

学员ID反查学员信息
SELECT b.user_id,b.telephone_num,a.province,a.city,b.province,b.city
from crm_form_record a right join user_online b 
on a.telephone_number=b.telephone_num
where user_id in (276449887, 276641008, 280368960, 280368960, 213117434, 284218265, 182568170, 284274676, 286964411, 134559388, 287515829, 213117434, 286951339, 287920472, 288833650)
  group by b.user_id




# 定金拆分

select b.student_user_id,b.pid as '订单ID',from_unixtime(b.create_time) as '订单创建时间',from_unixtime(b.update_time) as '支付时间',from_unixtime(a.end_time) as '付款时间',b.amount/100 as '成单金额',
CASE
    WHEN a.charge_type=1 then '微信'
    WHEN a.charge_type=2 then '支付宝'
    WHEN a.charge_type=3 then '银联'
    WHEN a.charge_type=4 then 'wpay'
    WHEN a.charge_type=5 then '充值卡'
    WHEN a.charge_type=6 then '系统赠送'
    WHEN a.charge_type=7 then 'App store'
    WHEN a.charge_type=8 then '招行掌中宝'
    WHEN a.charge_type=11 then '支付宝'
    WHEN a.charge_type=14 then '微信'
    WHEN a.charge_type=15 then '百度支付'
    END as '支付渠道',
CASE
    WHEN b.payment="DEPOSIT" then '定金尾款'
    WHEN b.payment="FULL" then '全款'
    WHEN b.payment="INSTALL" then '分期付款'
    END as '支付方式',
CASE
          WHEN b.grade=1 then '一年级'
          WHEN b.grade=2 then '二年级'
          WHEN b.grade=3 then '三年级'
          WHEN b.grade=4 then '四年级'
          WHEN b.grade=5 then '五年级'
          WHEN b.grade=6 then '六年级'  
          WHEN b.grade=7 then '七年级'
          WHEN b.grade=8 then '八年级'  
          WHEN b.grade=9 then '九年级'
          WHEN b.grade=10 then '小学'  
          WHEN b.grade=11 then '高一'
          WHEN b.grade=12 then '高二'   
          WHEN b.grade=13 then '高三' 
          Else '其他'      
      END as '年级',
 CASE
          WHEN b.subject=1 then '语文'
          WHEN b.subject=2 then '数学'
          WHEN b.subject=3 then '英语'
          WHEN b.subject=4 then '科学'
          WHEN b.subject=5 then '物理'
          WHEN b.subject=6 then '化学'
          WHEN b.subject=7 then '地理'
          WHEN b.subject=8 then '历史'
          WHEN b.subject=9 then '生物'
          WHEN b.subject=10 then '政治'
          WHEN b.subject=11 then '知心导师'
       END as  '学科',
       b.status as '状态',
       b.deposit_out_trade_no as '定金订单号',
       b.deposit_amount/100 as '定金金额',
       from_unixtime(b.deposit_update_time) as '支付时间',
CASE
    WHEN c.charge_type=1 then '微信'
    WHEN c.charge_type=2 then '支付宝'
    WHEN c.charge_type=3 then '银联'
    WHEN c.charge_type=4 then 'wpay'
    WHEN c.charge_type=5 then '充值卡'
    WHEN c.charge_type=6 then '系统赠送'
    WHEN c.charge_type=7 then 'App store'
    WHEN c.charge_type=8 then '招行掌中宝'
    WHEN c.charge_type=11 then '支付宝'
    WHEN c.charge_type=14 then '微信'
    WHEN c.charge_type=15 then '百度支付'
    END as '定金支付渠道'
from series_order b left join charge_record a 
on a.charge_no = b.out_trade_no 
left join charge_record c on b.deposit_out_trade_no = c.charge_no
where (b.note NOT LIKE '%zyb%')
  AND (b.name NOT LIKE '%测试%')
  AND (b.name NOT LIKE '%test%')
  
  AND b.amount/100>100
  #AND a.charge_type in ('1','14')
  AND b.student_user_id NOT IN (148811250,
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
                              247444506,
                              247673969)



select 