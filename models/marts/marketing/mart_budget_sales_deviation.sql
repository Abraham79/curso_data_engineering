with cte_budget as (

    select 

        month,
        product_id,
        sum(quantity) as expected_sales

    from {{ ref('fct_budget') }} 
   
    group by 1,2
   
),

cte_sales as (

    select

        month(order_date_utc) as month,
        product_id,
        sum(this_product_quantity) as actual_sales
    from {{ ref('fct_orders_detail') }} o 
    left join {{ ref('dim_time') }} t
    ON cast(o.order_date_utc as date)  = t.date_day
    group by 1,2
),

cte_products as (  

    select * from {{ ref('dim_products') }} 

)

,

renamed as (

    select

        b.month,
        b.product_id, 
        p.product_name,
        expected_sales,
        actual_sales,
        actual_sales-expected_sales AS deviation_from_budget

    from cte_budget b 
    left join cte_sales s on b.product_id = s.product_id and b.month = s.month
    left join cte_products as p
)

select * from renamed order by 1 asc 