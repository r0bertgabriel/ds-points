WITH tb_transactions_products AS (
    SELECT t1.*,
        t2.NameProduct,
        t2.QuantityProduct
    FROM transactions AS t1
    LEFT JOIN transactions_product AS t2
    ON t1.idTransaction = t2.idTransaction
    WHERE t1.dtTransaction < '2024-06-05'
    AND dtTransaction >= DATE('2024-06-05', '-21 day')
    )

SELECT 
        idCustomer,
        SUM(CASE WHEN NameProduct ='ChatMessage' THEN QuantityProduct ELSE 0 END) AS qtdChatMessage,
        SUM(CASE WHEN NameProduct ='Lista de presença' THEN QuantityProduct ELSE 0 END) AS qtdListaPresença,
        SUM(CASE WHEN NameProduct ='Resgatar Ponei' THEN QuantityProduct ELSE 0 END) AS qtdResgatarPonei,
        SUM(CASE WHEN NameProduct ='Troca de Pontos StreamElements' THEN QuantityProduct ELSE 0 END) AS qtdTrocaPontos,
        SUM(CASE WHEN NameProduct ='Presença Streak' THEN QuantityProduct ELSE 0 END) AS qtdPresençaStreak,
        SUM(CASE WHEN NameProduct ='Airflow Lover' THEN QuantityProduct ELSE 0 END) AS qtdAirflowLover,
        SUM(CASE WHEN NameProduct ='R Lover' THEN QuantityProduct ELSE 0 END) AS qtdRLover,

        SUM(CASE WHEN  NameProduct = 'ChatMessage' THEN pointsTransaction ELSE 0 END) AS pointsChatMessage,
        SUM(CASE WHEN  NameProduct = 'Lista de presença' THEN pointsTransaction ELSE 0 END) AS pointsListaPresença,
        SUM(CASE WHEN  NameProduct = 'Resgatar Ponei' THEN pointsTransaction ELSE 0 END) AS pointsResgatarPonei,
        SUM(CASE WHEN  NameProduct = 'Troca de Pontos StreamElements' THEN pointsTransaction ELSE 0 END) AS pointsTrocaPontos,
        SUM(CASE WHEN  NameProduct = 'Presença Streak' THEN pointsTransaction ELSE 0 END) AS pointsPresençaStreak,
        SUM(CASE WHEN  NameProduct = 'Airflow Lover' THEN pointsTransaction ELSE 0 END) AS pointsAirflowLover,
        SUM(CASE WHEN  NameProduct = 'R Lover' THEN pointsTransaction ELSE 0 END) AS  pointsRlover,

        1.0 * SUM(CASE WHEN NameProduct ='ChatMessage' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctChatMessage,
        1.0 * SUM(CASE WHEN NameProduct ='Lista de presença' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctListaPresença,
        1.0 * SUM(CASE WHEN NameProduct ='Resgatar Ponei' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctResgatarPonei,
        1.0 * SUM(CASE WHEN NameProduct ='Troca de Pontos StreamElements' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctTrocaPontos,
        1.0 * SUM(CASE WHEN NameProduct ='Presença Streak' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctPresençaStreak,
        1.0 * SUM(CASE WHEN NameProduct ='Airflow Lover' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctAirflowLover,
        1.0 * SUM(CASE WHEN NameProduct ='R Lover' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctRLover
FROM tb_transactions_products
GROUP BY idCustomer

