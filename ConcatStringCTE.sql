WITH
    data AS (
        SELECT
            *
        FROM
            (
                VALUES
                    ('A', '1'),
                    ('A', '2'),
                    ('B', '3'),
                    ('B', '4'),
                    ('B', '5')
            ) AS data (str, num)
    )
SELECT
    1 as id,
    str,
    string_agg (num, ' - ') WITHIN group (
        ORDER BY
            num ASC
    ) AS aggregated -- Concatenate the num values with ' - ' as the separator
FROM
    data
GROUp BY
    str