library(dplyr)
library(tidyverse)

#Read data from all three .csv files

white <- read.csv("/Users/hritikasingh/Desktop/white.csv")
black <- read.csv("/Users/hritikasingh/Desktop/black.csv")
latino <- read.csv("/Users/hritikasingh/Desktop/latino.csv")

#Filter the data in each dataset to ONLY include the 'Both Sexes' row and first 7 columns.

white_filtered <- white%>%
  select(Table.with.row.headers.in.columns.A.and.B..and.column.headers.in.rows.5.through.7.and.rows.39.to.41., X, X.1, X.2, X.3, X.4, X.5, X.6)%>%
  filter(Table.with.row.headers.in.columns.A.and.B..and.column.headers.in.rows.5.through.7.and.rows.39.to.41. == 'BOTH SEXES')

white_filtered <- white_filtered%>%
  rename(Sex = Table.with.row.headers.in.columns.A.and.B..and.column.headers.in.rows.5.through.7.and.rows.39.to.41.,
         Demographic = X,
         W_Total_Population = X.1,
         W_Total_Citizen_Population = X.2,
         W_Reported_Registered_Number = X.3,
         W_Reported_Registered_Percent = X.4,
         W_Reported_Not_Registered_Number = X.5,
         W_Reported_Not_Registered_Percent = X.6)

black_filtered <- black%>%
  select(Table.with.row.headers.in.columns.A.and.B..and.column.headers.in.rows.5.through.7.and.rows.39.to.41., X, X.1, X.2, X.3, X.4, X.5, X.6)%>%
  filter(Table.with.row.headers.in.columns.A.and.B..and.column.headers.in.rows.5.through.7.and.rows.39.to.41. == 'BOTH SEXES')

black_filtered <- black_filtered%>%
  rename(Sex = Table.with.row.headers.in.columns.A.and.B..and.column.headers.in.rows.5.through.7.and.rows.39.to.41.,
         Demographic = X,
         B_Total_Population = X.1,
         B_Total_Citizen_Population = X.2,
         B_Reported_Registered_Number = X.3,
         B_Reported_Registered_Percent = X.4,
         B_Reported_Not_Registered_Number = X.5,
         B_Reported_Not_Registered_Percent = X.6)

latino_filtered <- latino%>%
  select(Table.with.row.headers.in.columns.A.and.B..and.column.headers.in.rows.5.through.7.and.rows.39.to.41., X, X.1, X.2, X.3, X.4, X.5, X.6)%>%
  filter(Table.with.row.headers.in.columns.A.and.B..and.column.headers.in.rows.5.through.7.and.rows.39.to.41. == 'BOTH SEXES')

latino_filtered <- latino_filtered%>%
  rename(Sex = Table.with.row.headers.in.columns.A.and.B..and.column.headers.in.rows.5.through.7.and.rows.39.to.41.,
         Demographic = X,
         L_Total_Population = X.1,
         L_Total_Citizen_Population = X.2,
         L_Reported_Registered_Number = X.3,
         L_Reported_Registered_Percent = X.4,
         L_Reported_Not_Registered_Number = X.5,
         L_Reported_Not_Registered_Percent = X.6)

#Join all three tables into one master table, comparing all three tables side by side

tab <- merge(x=white_filtered, y=black_filtered, by="Demographic")
all_data <- merge(x=tab,y=latino_filtered, by="Demographic")
view(all_data)
