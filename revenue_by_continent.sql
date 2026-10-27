-- Calculate total revenue and revenue by device type per continent
with revenue_usd as
(select
    sp.continent,
    sum(p.price) as revenue,
    sum(case when device = 'mobile' then p.price end) as revenue_from_mobile,
    sum(case when device = 'desktop' then p.price end) as revenue_from_desktop
from `data-analytics-mate.DA.order` o
join `data-analytics-mate.DA.product` p
using(item_id)
join `data-analytics-mate.DA.session_params` sp
using(ga_session_id)
group by sp.continent),

-- Calculate each continent's share of total revenue (%)
final_revenue as
(select
    continent,
    revenue,
    revenue_from_mobile,
    revenue_from_desktop,
    revenue / sum(revenue) over() * 100 as revenue_from_total
from revenue_usd),

-- Count created accounts and verified accounts per continent
account_metrics as (select
    sp.continent,
    count(distinct a.id) as account_count,
    count(distinct case when a.is_verified = 1 then a.id end) as verified_count
from `data-analytics-mate.DA.session_params` sp
join `data-analytics-mate.DA.account_session` acs
using(ga_session_id)
join `data-analytics-mate.DA.account` a
on acs.account_id = a.id
group by sp.continent),

-- Count sessions per continent
session_cnt as (select
    continent,
    count(ga_session_id) as session_count
from `data-analytics-mate.DA.session_params`
group by continent)

-- Combine all metrics into one table per continent
select
    session_cnt.continent,
    revenue,
    revenue_from_mobile,
    revenue_from_desktop,
    revenue_from_total,
    account_count,
    verified_count,
    session_count
from session_cnt
left join final_revenue
on final_revenue.continent = session_cnt.continent
left join account_metrics
on account_metrics.continent = session_cnt.continent
