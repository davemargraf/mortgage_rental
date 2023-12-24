# Install and load necessary packages
if (!require("data.table")) install.packages("data.table")
if (!require("ggplot2")) install.packages("ggplot2")
library(data.table)
library(ggplot2)

# Function to calculate monthly mortgage payment (PMT)
calculate_mortgage_payment <- function(principal, annual_rate, term_years) {
  monthly_rate <- annual_rate / 12
  n <- term_years * 12
  payment <- principal * monthly_rate / (1 - (1 + monthly_rate)^-n)
  return(payment)
}

# Function to calculate equity and home value over time
calculate_equity_and_value <- function(initial_value, loan_amount, monthly_payment, annual_rate, term_years, appreciation_rate) {
  monthly_rate <- annual_rate / 12
  n <- term_years * 12
  schedule <- data.table(Month = 1:n, Equity = rep(0, n), Home_Value = rep(0, n))
  current_loan_amount <- loan_amount
  
  for (i in 1:n) {
    interest_payment <- current_loan_amount * monthly_rate
    principal_payment <- monthly_payment - interest_payment
    current_loan_amount <- current_loan_amount - principal_payment
    home_value <- initial_value * (1 + appreciation_rate / 12) ^ i
    equity <- home_value - max(current_loan_amount, 0)
    
    schedule[i, `:=`(Equity = equity, Home_Value = home_value)]
  }
  
  return(schedule)
}

# Scenario 1 Parameters: Sell current home and buy a larger one
sell_price <- 408000  # Selling price of current home
outstanding_mortgage <- 184730.64  # Remaining mortgage on current home
sale_costs <- 30000  # Costs associated with selling
net_profit_from_sale <- sell_price - outstanding_mortgage - sale_costs

price_new_home <- 700000  # Price of the larger home
down_payment_new_home <- net_profit_from_sale
loan_amount_new_home <- price_new_home - down_payment_new_home
interest_rate_new_home <- 0.07  # Interest rate for new home
term_new_home <- 30  # Mortgage term for new home in years

monthly_payment_new_home <- calculate_mortgage_payment(loan_amount_new_home, interest_rate_new_home, term_new_home)

# Scenario 2 Parameters: Keep current home for rent and buy another house
monthly_rental_income <- 2500
rental_expenses <- 500
net_rental_income <- monthly_rental_income - rental_expenses

price_another_home <- 600000  # Price of another home to live in
down_payment_another_home <- 100000  # Down payment for another home
loan_amount_another_home <- price_another_home - down_payment_another_home
interest_rate_another_home <- 0.07  # Interest rate for another home
term_another_home <- 30  # Mortgage term for another home in years

monthly_payment_another_home <- calculate_mortgage_payment(loan_amount_another_home, interest_rate_another_home, term_another_home)

# Common Parameters for Both Scenarios
appreciation_rate <- 0.03  # Annual property value appreciation rate
term_years_analysis <- 30  # Number of years for the analysis

# Calculate equity and home value for Scenario 1
equity_value_scenario1 <- calculate_equity_and_value(price_new_home, loan_amount_new_home, monthly_payment_new_home, interest_rate_new_home, term_years_analysis, appreciation_rate)

# Calculate equity and home value for Scenario 2 (Rental)
equity_value_rental <- calculate_equity_and_value(sell_price, outstanding_mortgage, calculate_mortgage_payment(outstanding_mortgage, interest_rate_new_home, term_years_analysis), interest_rate_new_home, term_years_analysis, appreciation_rate)

# Calculate equity and home value for Scenario 2 (New Home)
equity_value_new_home_scenario2 <- calculate_equity_and_value(price_another_home, loan_amount_another_home, monthly_payment_another_home, interest_rate_another_home, term_years_analysis, appreciation_rate)

# Total Equity and Value for Scenario 2
equity_value_scenario2 <- merge(equity_value_rental, equity_value_new_home_scenario2, by = "Month")
equity_value_scenario2[, Total_Equity := Equity.x + Equity.y]
equity_value_scenario2[, Total_Home_Value := Home_Value.x + Home_Value.y]

# Plotting the results
plot <- ggplot() +
  geom_line(data = equity_value_scenario1, aes(x = Month, y = Equity, color = "Scenario 1: Equity (New Home)")) +
  geom_line(data = equity_value_scenario1, aes(x = Month, y = Home_Value, color = "Scenario 1: Home Value (New Home)")) +
  geom_line(data = equity_value_scenario2, aes(x = Month, y = Total_Equity, color = "Scenario 2: Total Equity (Rental + New Home)")) +
  geom_line(data = equity_value_scenario2, aes(x = Month, y = Total_Home_Value, color = "Scenario 2: Total Home Value (Rental + New Home)")) +
  scale_color_manual("", 
                     values = c("Scenario 1: Equity (New Home)" = "blue", 
                                "Scenario 1: Home Value (New Home)" = "green",
                                "Scenario 2: Total Equity (Rental + New Home)" = "red",
                                "Scenario 2: Total Home Value (Rental + New Home)" = "purple")) +
  ggtitle("Equity and Home Value Comparison Over Time") +
  xlab("Month") +
  ylab("Amount")

# Saving the plot to a file
ggsave("equity_home_value_comparison_plot.png", plot, width = 12, height = 8)