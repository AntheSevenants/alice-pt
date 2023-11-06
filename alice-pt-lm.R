# Just checking with a regular mixed model
library(lme4)
library(magrittr)

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
df$Transfer_Type <- df$Transfer_Type %>% as.factor()
df$Person_Recipient <- as.factor(df$Person_Recipient)
df$Animacy <- df$Animacy %>% as.factor()
df$Definiteness_Recipient <- as.factor(df$Definiteness_Recipient)
df$Affectedness_Recipient <- df$Affectedness_Recipient%>% as.factor()
df$Topic <- df$Topic %>% as.factor()
df$Accessibility_Recipient <-
  ifelse(df$Accessibility_Recipient == "Yes", 1, 0) %>% as.logical()
df$Accessibility_Theme <-
  ifelse(df$Accessibility_Theme == "Yes", 1, 0) %>% as.logical()
df$Theme_Form <- df$Theme_Form %>% as.factor()
df$Length_Recipient <- df$Length_Recipient %>% as.double()
df$Length_Theme <- df$Length_Theme %>% as.double()

fit <- glm(Construction ~ Genre + Register + (1 + Lemma) + 
             Syntactic_Integration + Agent_Explicit + Focus + Transfer_Type +
             Person_Recipient + Animacy + Definiteness_Recipient + 
             Affectedness_Recipient + Topic + Accessibility_Recipient +
             Accessibility_Theme + Theme_Form + Length_Recipient + Length_Theme,
           data=df, family="binomial")
summary(fit)
