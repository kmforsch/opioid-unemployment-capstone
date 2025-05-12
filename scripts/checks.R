summary(opioid_df$overdose_count)
hist(opioid_df$overdose_count, breaks=20,
     main="Distribution of opioid counts",
     xlab="Hospitalizations per year")

# Province & year combinations
n_op_prov <- length(unique(opioid_df$province))
n_op_year <- length(unique(opioid_df$year))
cat("Provinces in opioid_df:", n_op_prov,
    "Years:", n_op_year, "\n")

# Dimensions should match overlap of opioid & unemployment
dim(final_df)  
# Every row should have no NAs in the key columns
colSums(is.na(final_df))

# Highest overdose rates
arrange(final_df, desc(overdose_rate)) %>% head()

# Lowest unemployment rates
arrange(final_df, unemployment_rate) %>% head()

# Just to be extra sure cor_test is right
cor(final_df$unemployment_rate, final_df$overdose_rate)

#Second round of sanity checks
# Opioid counts
summary(opioid_df$overdose_count)
hist(opioid_df$overdose_count, breaks=20,
     main="Opioid Hospitalizations", xlab="Count")

# Overdose rates
summary(final_df$overdose_rate)
hist(final_df$overdose_rate, breaks=20,
     main="Opioid Overdose Rates", xlab="Per 100,000")

# Merged data integrity
dim(final_df) # should be (#provinces × #years) rows, and 6 columns
colSums(is.na(final_df))  # all zeros for key fields

# Hand‑check the correlation
cor(final_df$unemployment_rate, final_df$overdose_rate)
