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

