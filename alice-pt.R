# Read libraries
library(magrittr)

# Load ElasticToolsR
source("ElasticToolsR/Dataset.R")
source("ElasticToolsR/ElasticNet.R")

# Read dataset
df <- read.delim("FilterByLemma.tsv")
df$Genre <- as.factor(df$Genre)
df$Register <- as.factor(df$Register)
df$Construction <- as.factor(df$Construction)
df$Lemma <- as.factor(df$Lemma)
df$Syntactic_Integration <- as.factor(df$Syntactic_Integration)
df$Agent_Explicit <-
  ifelse(df$Agent_Explicit == "Yes", 1, 0) %>% as.logical()
df$Focus <- as.factor(df$Focus)
df$Transfer_Type <- as.factor(df$Transfer_Type)
df$Person_Recipient <- as.factor(df$Person_Recipient)
df$Animacy <- as.factor(df$Animacy)
df$Definiteness_Recipient <- as.factor(df$Definiteness_Recipient)
df$Affectedness_Recipient <- as.factor(df$Affectedness_Recipient)
df$Topic <- as.factor(df$Topic)
df$Accessibility_Recipient <-
  ifelse(df$Accessibility_Recipient == "Yes", 1, 0) %>% as.logical()
df$Accessibility_Theme <-
  ifelse(df$Accessibility_Theme == "Yes", 1, 0) %>% as.logical()
df$Theme_Form <- as.factor(df$Theme_Form)

# Inspect levels
levels(df$Genre)
levels(df$Register)
levels(df$Construction)
levels(df$Lemma)
levels(df$Syntactic_Integration)
levels(df$Focus)
levels(df$Transfer_Type)
levels(df$Person_Recipient)
levels(df$Animacy)
levels(df$Definiteness_Recipient)
levels(df$Affectedness_Recipient)
levels(df$Topic)
levels(df$Theme_Form)

# Define the dataset
ds <- dataset(df=df,
              response_variable_column="Construction",
              to_binary_columns=c("Lemma", "Genre"),
              other_columns=c("Register", "Focus"))

# Define Elastic Net object
net <- elastic_net(ds=ds,
                   nfolds=20,
                   type.measure="class")

# Compute Elastic Net
output <- net$do_elastic_net_regression_auto_alpha(k=20)

# Find the model with the lowest loss
lowest_loss_row <- output$results[which.min(output$results$loss),]
lowest_loss_row

coefficients_with_labels <- net$attach_coefficients(
  output$fits[[lowest_loss_row[["X_id"]]]])

# Export
write.csv(coefficients_with_labels, "output/alice-pt.csv",
          row.names=FALSE)

#
# Export model information
#

model_meta <- meta.file()

for (attribute in colnames(lowest_loss_row)) {
  if (attribute == "X_id") {
    next
  }
  
  model_meta$add_model_information(attribute, lowest_loss_row[[attribute]])
}

write.csv(model_meta$as.data.frame(), "output/model_meta.csv", row.names=FALSE)