with cte_distribute as ( SELECT 0 n UNION ALL SELECT 1  UNION ALL SELECT 2  UNION ALL 
   SELECT 3   UNION ALL SELECT 4  UNION ALL SELECT 5  UNION ALL
   SELECT 6   UNION ALL SELECT 7  UNION ALL SELECT 8  UNION ALL
   SELECT 9   UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL
   SELECT 12  UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL 
   SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL 
   SELECT 18 UNION ALL SELECT 19

),

cte_orders_detail as (
select *
from {{ ref('fct_orders_detail') }}), 

cte_products as (
    select

        product_name,
        product_id,
        product_price_usd
    
    from {{ ref('dim_products') }}
),

cte_users as (
select *
from {{ ref('dim_users') }}), 

cte_promos as (
select *
from {{ ref('dim_promos') }}), 


renamed as (

    select 
            u.first_name,
            u.last_name,
            p.product_name, 
            o.product_id,
            nullif(d.promo_name, 'no_promo') as promo_name,
            d.promo_id,
            p.product_price_usd,
            p.product_price_usd/o.order_total_before_shipping_usd as value_ratio,
            d.discount_usd*value_ratio as product_discount_usd
            
    from cte_orders_detail o
    join cte_products p 
    on o.product_id=p.product_id
    join cte_users u 
    on o.user_id = u.user_id
    join cte_promos d 
    on o.promo_id = d.promo_id
    JOIN cte_distribute i 
    ON i.n between 1 and o.this_product_quantity
    order by o.promo_id, i.n)

select * from renamed

