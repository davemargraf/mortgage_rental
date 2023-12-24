# Install and load necessary package
#if (!require("data.table")) install.packages("data.table")
library(data.table)

# Mortgage details
loan_amount <- 184730.64
annual_interest_rate <- 0.0225
monthly_interest_rate <- annual_interest_rate / 12
loan_term_years <- 15
total_payments <- loan_term_years * 12
current_payment_number <- 38
monthly_payment <- 1473.94
home_value <- 408000.00
annual_increase <- 0.015
initial_rent <- 2500
rent_increase_interval <- 24  # Every two years
rent_increase_rate <- 0.03  # 3%
annual_investment_return <- 0.08  # 8%

# Function to create amortization schedule
amortization_schedule <- function(loan_amount, monthly_payment, monthly_interest_rate, current_payment_number, total_payments, home_value, annual_increase, initial_rent, rent_increase_interval, rent_increase_rate, annual_investment_return) {
  remaining_payments <- total_payments - current_payment_number + 1
  schedule <- data.table(Payment_Number = current_payment_number:total_payments,
                         Principal = rep(0, remaining_payments),
                         Interest = rep(0, remaining_payments),
                         Cumulative_Principal = rep(0, remaining_payments),
                         Cumulative_Interest = rep(0, remaining_payments),
                         Total_Paid = rep(0, remaining_payments),
                         Remaining_Balance = rep(0, remaining_payments),
                         Home_Value = rep(0, remaining_payments),
                         Home_Equity = rep(0, remaining_payments),
                         Rent = rep(0, remaining_payments),
                         Upkeep = rep(0, remaining_payments),
                         Cash_Flow = rep(0, remaining_payments),
                         Cumulative_Cash_Flow = rep(0, remaining_payments),
                         Investment_Return_Cash_Flow = rep(0, remaining_payments),
                         Investment_Return_Principal_Interest = rep(0, remaining_payments)
  )
  rent <- initial_rent
  cumulative_cash_flow <- 0
  cumulative_principal <- 0
  cumulative_interest <- 0
  investment_return_cash_flow <- 0
  investment_return_principal_interest <- 0
  
  for (i in current_payment_number:total_payments) {
    # Increase rent every two years
    if ((i - current_payment_number + 1) %% rent_increase_interval == 0) {
      rent <- rent * (1 + rent_increase_rate)
    }
    
    interest_payment <- loan_amount * monthly_interest_rate
    principal_payment <- monthly_payment - interest_payment
    loan_amount <- loan_amount - principal_payment
    home_value <- home_value * (1 + annual_increase / 12)
    equity <- home_value - loan_amount
    upkeep <- home_value * 0.01 / 12
    cash_flow <- rent - upkeep - monthly_payment
    cumulative_cash_flow <- cumulative_cash_flow + cash_flow
    cumulative_principal <- cumulative_principal + principal_payment
    cumulative_interest <- cumulative_interest + interest_payment
    investment_return_cash_flow <- (investment_return_cash_flow + cash_flow) * (1 + annual_investment_return / 12)
    investment_return_principal_interest <- (investment_return_principal_interest + principal_payment + interest_payment) * (1 + annual_investment_return / 12)
    
    # Correcting for the last payment
    if (loan_amount < 0) {
      principal_payment <- principal_payment + loan_amount
      loan_amount <- 0
    }
    
    schedule[i - current_payment_number + 1, `:=`(Principal = principal_payment,
                                                  Interest = interest_payment,
                                                  Cumulative_Principal = cumulative_principal,
                                                  Cumulative_Interest = cumulative_interest,
                                                  Total_Paid = cumulative_principal + cumulative_interest,
                                                  Remaining_Balance = loan_amount,
                                                  Home_Value = home_value,
                                                  Home_Equity = equity,
                                                  Rent = rent,
                                                  Upkeep = upkeep,
                                                  Cash_Flow = cash_flow,
                                                  Cumulative_Cash_Flow = cumulative_cash_flow,
                                                  Investment_Return_Cash_Flow = investment_return_cash_flow,
                                                  Investment_Return_Principal_Interest = investment_return_principal_interest)]
  }
  
  return(schedule)
}

# Generate the amortization schedule
schedule <- amortization_schedule(loan_amount, monthly_payment, monthly_interest_rate, current_payment_number, total_payments, home_value, annual_increase, initial_rent, rent_increase_interval, rent_increase_rate, annual_investment_return)

# Print and view the schedule
print(schedule)
View(schedule)
