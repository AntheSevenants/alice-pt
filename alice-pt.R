# Read libraries
library(magrittr)

# Load ElasticToolsR
source("ElasticToolsR/Dataset.R")
source("ElasticToolsR/ElasticNet.R")
source("ElasticToolsR/MetaFile.R")

# Read dataset
df <- read.delim("FilterByLemma.tsv")

df$Genre <- df$Genre %>% paste0("_Genre_", .) %>% as.factor()

df$Register <- as.factor(df$Register)

df$Construction <- factor(df$Construction,
                          levels=c("Theme Passives", "Recipient Passives"))

df$Lemma <- as.factor(df$Lemma)

df$Syntactic_Integration <-
  df$Syntactic_Integration %>% paste0("_SI_", .) %>% as.factor()

df$Agent_Explicit <-
  ifelse(df$Agent_Explicit == "Yes", 1, 0) %>% as.logical()

df$Focus <- as.factor(df$Focus)

df$Transfer_Type <- df$Transfer_Type %>% paste0("_TT_", .) %>% as.factor()

df$Person_Recipient <- as.factor(df$Person_Recipient)

df$Animacy <- df$Animacy %>% paste0("_Anim_", .) %>% as.factor()

df$Definiteness_Recipient <- as.factor(df$Definiteness_Recipient)

df$Affectedness_Recipient <- 
  df$Affectedness_Recipient %>% paste0("_AR_", .) %>% as.factor()

df$Topic <- df$Topic %>% paste0("_Topic_", .) %>% as.factor()

df$Accessibility_Recipient <-
  ifelse(df$Accessibility_Recipient == "Yes", 1, 0) %>% as.logical()

df$Accessibility_Theme <-
  ifelse(df$Accessibility_Theme == "Yes", 1, 0) %>% as.logical()

df$Theme_Form <- df$Theme_Form %>% paste0("_Theme_Form_", .) %>% as.factor()

df$Length_Recipient <- df$Length_Recipient %>% as.double()
df$Length_Theme <- df$Length_Theme %>% as.double()

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
              to_binary_columns=c("Lemma", "Genre", "Syntactic_Integration",
                                  "Transfer_Type", "Animacy", "Theme_Form",
                                  "Affectedness_Recipient", "Topic"),
              other_columns=c("Register", "Focus", "Definiteness_Recipient"))

feature_matrix <- ds$as_matrix()

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
