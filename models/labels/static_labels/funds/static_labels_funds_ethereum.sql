{{config(alias='funds_ethereum',
    materialized = 'table',
    file_format = 'delta')}}

SELECT blockchain, address, name, category, contributor, source, created_at, updated_at
FROM (VALUES
     (array('ethereum'),'0x2B1Ad6184a6B0fac06bD225ed37C2AbC04415fF4', 'a16z', 'funds', 'soispoke', 'static', timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x05e793ce0c6027323ac150f6d45c2344d28b6019', 'a16z', 'funds', 'soispoke', 'static', timestamp('2022-10-03'), now())
    , (array('ethereum'), '0xa294cca691e4c83b1fc0c8d63d9a3eef0a196de1', 'Alameda', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0xc5ed2333f8a2c351fca35e5ebadb2a82f5d254c3', 'Alameda Research', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x84d34f4f83a87596cd3fb6887cff8f17bf5a7b83', 'Alameda Research', 'funds', 'soispoke', 'static', timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x4c8cfe078a5b989cea4b330197246ced82764c63', 'Alameda Research', 'funds', 'soispoke', 'static', timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x712d0f306956a6a4b4f9319ad9b9de48c5345996', 'Alameda Research', 'funds', 'soispoke', 'static', timestamp('2022-10-03'), now())
    , (array('ethereum'), '0xafa64cca337efee0ad827f6c2684e69275226e90', 'CMS Holdings', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x9b5ea8c719e29a5bd0959faf79c9e5c8206d0499', 'DeFiance Capital', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0xf584f8728b874a6a5c7a8d4d387c9aae9172d621', 'Jump Capital', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x112b69178d416cd03222de9e6dd6b3adf36412aa', 'Kirin Fund', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0xc8d328b21f476a4b6e0681f6e4e41693a220347d', 'Multicoin Capital', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x66b870ddf78c975af5cd8edc6de25eca81791de1', 'Oapital', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0xd9b012a168fb6c1b71c24db8cee1a256b3caa2a2', 'ParaFi Capital', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x4655b7ad0b5f5bacb9cf960bbffceb3f0e51f363', 'Scary Chain Capital', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x80c2c1ceb335e39b7021c646fd3ec159faf9109d', 'Signum Capital', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x4862733b5fddfd35f35ea8ccf08f5045e57388b3', 'Three Arrows Capital', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x085af684acdb1220d111fee971b733c5e5ae6ccd', 'Three Arrows Capital', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x8e04af7f7c76daa9ab429b1340e0327b5b835748', 'Three Arrows Capital', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    , (array('ethereum'), '0x0000006daea1723962647b7e189d311d757fb793', 'Wintermute Trading', 'funds', 'soispoke', 'static',  timestamp('2022-10-03'), now())
    ) AS x (blockchain, address, name, category, contributor, source, created_at, updated_at)