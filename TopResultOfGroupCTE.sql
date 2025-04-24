WITH
    cte AS (
        SELECT
            *,
            rank() OVER (
                PARTITION BY
                    City
                ORDER BY
                    Order_Date DESC
            ) AS ranking -- Assign a rank to each order within each city based on Order_Date
        FROM
            Sales
    )
SELECT
    *
FROM
    cte
WHERE
    ranking = 1 -- Select only the most recent order for each city