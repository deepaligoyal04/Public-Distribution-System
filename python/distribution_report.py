"""Print a district-wise ration distribution report."""
import pandas as pd
from db_connection import get_connection


def main():
    query = """
        SELECT
            d.district_name,
            c.commodity_name,
            SUM(t.quantity_kg) AS total_distributed_kg,
            COUNT(t.transaction_id) AS successful_transactions
        FROM Distribution_Transactions t
        JOIN Ration_Shops s ON s.shop_id = t.shop_id
        JOIN Districts d ON d.district_id = s.district_id
        JOIN Commodities c ON c.commodity_id = t.commodity_id
        WHERE t.transaction_status = 'Successful'
        GROUP BY d.district_name, c.commodity_name
        ORDER BY d.district_name, total_distributed_kg DESC;
    """
    connection = get_connection()
    try:
        report = pd.read_sql(query, connection)
        print("\\nDISTRICT-WISE RATION DISTRIBUTION\\n")
        print(report.to_string(index=False))
    finally:
        connection.close()


if __name__ == "__main__":
    main()
