with 

cte_orders as (

    select * from {{ ref('fct_orders_detail') }}

), 

cte_promos as (

    select * from {{ ref('dim_promos') }}

),

cte_shipping as (

    select * from {{ ref('dim_shipping') }}

),

cte_products as (

    select * from {{ ref('dim_products') }}

),


renamed as (


    select

        {{ dbt_utils.generate_surrogate_key(['o.order_id', 'o.order_date_utc', 'o.order_total_income_usd']) }} as header_line_hash,
        o.order_id,
        o.user_id,
        o.promo_id,
        d.promo_name,
        d.discount_usd,
        /*{{ single_row('s.shipping_cost_usd','shipping_cost_usd', 'o.order_id' )}} */
        o.order_total_before_shipping_usd,
        o.order_total_income_usd,
        p.product_price_usd*o.this_product_quantity as total_per_product_usd

    from cte_orders o
    left join cte_promos d
    on o.promo_id = d.promo_id 
    left join cte_shipping s
    on o.order_id = s.order_id
    left join cte_products p
    on o.product_id = p.product_id


)

select * from renamed
