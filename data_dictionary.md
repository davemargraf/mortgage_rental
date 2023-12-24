
Data dictionary

    loan_amount: The initial or remaining balance of the mortgage loan.

    annual_interest_rate: The annual interest rate of the mortgage.

    monthly_interest_rate: The monthly interest rate, calculated by dividing the annual interest rate by 12.

    loan_term_years: The total duration of the mortgage in years.

    total_payments: The total number of payments for the loan, calculated as the loan term in years multiplied by 12 (for monthly payments).

    current_payment_number: The number of the current payment in the sequence, which is where the calculation for the amortization schedule starts.

    monthly_payment: The fixed monthly payment amount for the mortgage.

    home_value: The current market value of the property.

    annual_increase: The annual rate at which the home value is expected to appreciate.

    initial_rent: The initial monthly rent received from the property.

    rent_increase_interval: The interval, in months, at which the rent is increased.

    rent_increase_rate: The percentage rate at which the rent increases at each specified interval.

    annual_investment_return: The expected annual return rate from an investment, used for calculating returns from investing in the S&P 500.

    remaining_payments: The number of payments remaining in the mortgage, calculated as total payments minus the current payment number.

    cumulative_cash_flow: The accumulated cash flow over time, calculated as the sum of monthly cash flow.

    cumulative_principal: The total principal amount paid over time.

    cumulative_interest: The total interest amount paid over time.

    investment_return_cash_flow: The cumulative returns from investing the monthly cash flow into an investment vehicle like the S&P 500, assuming an 8% annual return, compounded monthly.

    investment_return_principal_interest: The cumulative returns from investing the sum of the monthly principal and interest payments into an investment vehicle like the S&P 500, with the same assumed annual return.