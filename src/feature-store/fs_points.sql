WITH tb_pontos_d AS (
    SELECT idCustomer,
           SUM(pointsTransaction) AS saldoPoints,
           SUM(CASE WHEN pointsTransaction > 0 THEN pointsTransaction ELSE 0 END) AS pointsAcumulados,
           SUM(CASE WHEN pointsTransaction < 0 THEN pointsTransaction ELSE 0 END) AS pointsResgatados,
           SUM(CASE WHEN pointsTransaction > 0 
                    AND dtTransaction >= DATE('2024-06-04', '-14 day')
                    THEN pointsTransaction 
                    ELSE 0 
               END) AS pointsAcumuladosD14,
           SUM(CASE WHEN pointsTransaction < 0
                    AND dtTransaction >= DATE('2024-06-04', '-14 day')
                    THEN pointsTransaction 
                    ELSE 0 
               END) AS pointsResgatadosD14,
           SUM(CASE WHEN pointsTransaction > 0 
                    AND dtTransaction >= DATE('2024-06-04', '-7 day')
                    THEN pointsTransaction 
                    ELSE 0 
               END) AS pointsAcumuladosD7,
           SUM(CASE WHEN pointsTransaction < 0
                    AND dtTransaction >= DATE('2024-06-04', '-7 day')
                    THEN pointsTransaction 
                    ELSE 0 
               END) AS pointsResgatadosD7
    FROM transactions
    WHERE dtTransaction < '2024-06-04'
      AND dtTransaction >= DATE('2024-06-04', '-21 day')
    GROUP BY idCustomer
),
tb_vida AS (
    SELECT t1.idCustomer,
           SUM(t2.pointsTransaction) AS saldoPoints,
           SUM(CASE
                   WHEN t2.pointsTransaction > 0 
                   THEN t2.pointsTransaction
                   ELSE 0 
               END) AS pointsAcumuladosVida,
           SUM(CASE
                   WHEN t2.pointsTransaction < 0 
                   THEN t2.pointsTransaction
                   ELSE 0 
               END) AS pointsResgatadosVida
    FROM tb_pontos_d AS t1
    LEFT JOIN transactions AS t2
    ON t1.idCustomer = t2.idCustomer
    WHERE t2.dtTransaction < '2024-06-04'
    GROUP BY t1.idCustomer
)
SELECT t1.*,
       t2.saldoPoints,
       t2.pointsAcumuladosVida,
       t2.pointsResgatadosVida
FROM tb_pontos_d AS t1
LEFT JOIN tb_vida AS t2
ON t1.idCustomer = t2.idCustomer;