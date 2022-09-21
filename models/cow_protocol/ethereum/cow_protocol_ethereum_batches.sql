{{  config(
        alias='batches',
        materialized='incremental',
        unique_key = ['tx_hash'],
        on_schema_change='sync_all_columns',
        file_format ='delta',
        incremental_strategy='merge'
    )
}}

WITH
-- Find the PoC Query here: https://dune.com/queries/1290518
batch_counts as (
    select s.evt_block_time,
           s.evt_tx_hash,
           solver,
           name,
           sum(
               case
                   when selector != '0x2e1a7d4d' -- unwrap
                    and selector != '0x095ea7b3' -- approval
                       then 1
                   else 0
                end)                                                as dex_swaps,
           sum(case when selector = '0x2e1a7d4d' then 1 else 0 end) as unwraps,
           sum(case when selector = '0x095ea7b3' then 1 else 0 end) as token_approvals
    from {{ source('gnosis_protocol_v2_ethereum', 'GPv2Settlement_evt_Settlement') }} s
        left outer join {{ source('gnosis_protocol_v2_ethereum', 'GPv2Settlement_evt_Interaction') }} i
            on i.evt_tx_hash = s.evt_tx_hash
        join cow_protocol_ethereum.solvers
            on solver = address
    {% if is_incremental() %}
    WHERE s.evt_block_time >= date_trunc("day", now() - interval '1 week')
    AND i.evt_block_time >= date_trunc("day", now() - interval '1 week')
    {% endif %}
    group by s.evt_tx_hash, solver, s.evt_block_time, name
),

batch_values as (
    select
        tx_hash,
        count(*)        as num_trades,
        sum(usd_value)  as batch_value,
        sum(fee_usd)    as fee_value,
        price           as eth_price
    from {{ ref('cow_protocol_ethereum_trades') }}
        join {{ source('prices', 'usd') }} as p
            on p.contract_address = '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
            and p.minute = date_trunc('minute', block_time)
            and blockchain = 'ethereum'
    {% if is_incremental() %}
    WHERE block_time >= date_trunc("day", now() - interval '1 week')
    {% endif %}
    group by tx_hash, price
),

combined_batch_info as (
    select
        evt_block_time                                 as block_time,
        num_trades,
        CASE
            WHEN name ilike '%1inch'
               OR name = '%ParaSwap'
               OR name = '%0x'
               OR name = 'Legacy'
               THEN NULL
            -- TODO: We can't rely on dex.trades table here yet,
            -- thus we cannot know how many dex swaps are happening in settlements via aggregators
            -- V1: (select count(*) from dex.trades where tx_hash = evt_tx_hash and category = 'DEX')
            ELSE dex_swaps
        END                                              as dex_swaps,
        batch_value,
        solver                                           as solver_address,
        evt_tx_hash                                      as tx_hash,
        gas_price,
        gas_used,
        (gas_price * gas_used * eth_price) / pow(10, 18) as tx_cost_usd,
        fee_value,
        length(data)::decimal / 1024                     as call_data_size,
        unwraps,
        token_approvals
    from batch_counts b
        join batch_values t
            on b.evt_tx_hash = t.tx_hash
        inner join {{ source('ethereum', 'transactions') }} tx
            on evt_tx_hash = hash
            {% if is_incremental() %}
            AND block_time >= date_trunc("day", now() - interval '1 week')
            {% endif %}
    where num_trades > 0 --! Exclude Withdraw Batches
)

select * from combined_batch_info