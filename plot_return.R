# Install and load necessary packages
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)
library(data.table)

# Assuming 'schedule' is your amortization schedule data table from the previous script

# Combined plot for cumulative cash flow and investment returns with legend
combined_plot <- ggplot() +
  geom_line(data = schedule, aes(x = Payment_Number, y = Cumulative_Cash_Flow, color = "Cumulative Cash Flow")) +
  geom_line(data = schedule, aes(x = Payment_Number, y = Investment_Return_Cash_Flow, color = "Investment Return (Cash Flow)")) +
  geom_line(data = schedule, aes(x = Payment_Number, y = Investment_Return_Principal_Interest, color = "Investment Return (Principal & Interest)")) +
  ggtitle("Cumulative Cash Flow and Investment Returns Over Time") +
  xlab("Payment Number") +
  ylab("Amount") +
  scale_color_manual("", 
                     values = c("Cumulative Cash Flow" = "blue", 
                                "Investment Return (Cash Flow)" = "green", 
                                "Investment Return (Principal & Interest)" = "red"))

# Saving the combined plot to a file
ggsave("combined_plot.png", combined_plot, width = 12, height = 8)
