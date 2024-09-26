WITH tb_transactions AS (
    
        SELECT *

        FROM transactions

        WHERE dtTransaction < '2024-06-05'
        AND dtTransaction >= DATE('2024-06-05', '-21 day')


),


tb_freq AS (
    SELECT 
        idCustomer,
        COUNT(DISTINCT DATE(dtTransaction)) AS qtdeDiasD21,
        COUNT(DISTINCT CASE WHEN dtTransaction > DATE('2024-06-05', '-14 day') THEN DATE(dtTransaction) END) AS qtdeDiasD14,
        COUNT(DISTINCT CASE WHEN dtTransaction > DATE('2024-06-05', '-7 day') THEN DATE(dtTransaction) END) AS qtdeDiasD7

    FROM tb_transactions

    GROUP BY idCustomer
),

tb_live_minutes AS (
    SELECT  idCustomer,
            DATE(DATETIME(dtTransaction, '-3 hour')) AS dtTransaction,
            MAX(DATETIME(dtTransaction, '-3 hour')) AS dtFim,
            MIN(DATETIME(dtTransaction, '-3 hour')) AS dtInit,
            (julianday(MAX(DATETIME(dtTransaction, '-3 hour'))) - julianday(MIN(DATETIME(dtTransaction, '-3 hour')))) * 24 * 60 AS liveMinutes

    FROM tb_transactions
    GROUP BY 1,2

),
 
 tb_hours AS (
SELECT idCustomer,
        AVG(liveMinutes) AS avgLiveMinutes,
        SUM(liveMinutes) AS sumLiveMinutes,
        MIN(liveMinutes) AS minLiveMinutes,
        MAX(liveMinutes) AS maxLiveMinutes


FROM  tb_live_minutes

GROUP BY idCustomer

),

tb_vida AS (

    SELECT idCustomer,
            COUNT(DISTINCT idTransaction) AS qtdeTransacaoVida,
            COUNT(DISTINCT idTransaction) / (MAX(julianday('2024-06-05')- julianday(dtTransaction))) AS avgTransacaoDia
   
    FROM transactions
    WHERE dtTransaction < '2024-06-05'
    GROUP BY idCustomer

),

tb_join AS (
    SELECT t1.*,
            t2.avgLiveMinutes,
            t2.sumLiveMinutes,
            t2.minLiveMinutes,
            t2.maxLiveMinutes,
            t3.qtdeTransacaoVida,
            t3.avgTransacaoDia
        FROM tb_freq AS t1

        LEFT JOIN tb_hours AS t2
        ON t1.idCustomer = t2.idCustomer
        
        LEFT JOIN  tb_vida AS t3
        ON t3.idCustomer = t1.idCustomer
)

    SELECT 
    '2024-06-05' AS dtRef,
    *
    FROM tb_join

