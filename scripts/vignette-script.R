library(tidyverse)

# loading data
df <- read_csv('data/raw/heart_disease_uci.csv')

# check 
glimpse(df)
summary(df)

# missing values
colSums(is.na(df))

# distribution of target var
## num is the diagnosis --- num == 0 (no heart disease), num > 0 (heart disease)
df <- df %>% 
  mutate(target = ifelse(num == 0,0,1)) %>% 
  select(-num)

table(df$target)

# lots of missing values -- dropping columns with many missing
df_clean <- df %>% 
  select(-ca, -thal, -slope) %>% drop_na()

# prepare for model fitting
df_clean <- df_clean %>% 
  mutate(
    sex = factor(sex),
    cp = factor(cp),
    restecg = factor(restecg),
    fbs = factor(fbs),
    exang = factor(exang),
    dataset = factor(dataset),
    target = factor(target)
  )

glimpse(df_clean)
table(df_clean$target)
write_csv(df_clean, 'data/processed/heart_clean.csv')

library(tidymodels)
set.seed(123)
data_split <- initial_split(df_clean, prop = 0.8)

train <- training(data_split)
test <- testing(data_split)

# fitting logistic regression model
heart_recipe <- recipe(target ~ ., data= train) %>% 
  update_role(id, new_role= 'ID') %>% # removing ID from predictors
  step_dummy(all_nominal_predictors())

log_reg_spec <- logistic_reg() %>% 
  set_engine('glm')

heart_wf <- workflow() %>% 
  add_model(log_reg_spec) %>% 
  add_recipe(heart_recipe)

log_reg_fit <- heart_wf %>% fit(data= train)
log_reg_fit

# generating predictions on test data
test_pred <- predict(log_reg_fit, new_data= test, type = 'prob') %>% 
  bind_cols(test %>%  select(target))
colnames(test_pred)

test_pred <- test_pred %>% 
  mutate(.pred_class = ifelse(.pred_1 > 0.5, '1', '0') %>% factor(
    levels = levels(target)
  ))

# accuracy and confusion matrix
log_reg_accuracy <- mean(test_pred$.pred_class == test_pred$target)
log_reg_accuracy # 0.7635

table(
  Predicted = test_pred$.pred_class,
  Actual = test_pred$target
)

## true negatives: 61, true positives: 52
## false positives: 9, false negatives: 26

# AUC
library(pROC)
roc_obj <- roc(test_pred$target, test_pred$.pred_1)
auc(roc_obj)

## 0.8533 -- model can correctly rank a random positive example higher
## than a random negative example 85% of the time

# plots
library(ggplot2)

# predicted probabilities on the test set:
test_pred_df <- test_pred %>% 
  mutate(prob = .pred_1)

logistic_plot <- ggplot(test_pred_df, aes(x = prob, fill = target)) +
  geom_histogram(alpha = 0.6, position = "identity", bins = 30) +
  scale_fill_manual(values = c("blue", "red")) +
  labs(
    title= "predicted probabilities from logistic regression",
    x = "predicted probability of heart disease",
    y = "count",
    fill ="actual target"
  ) +
  theme_minimal(base_size = 14)
logistic_plot

# save to img folder
ggsave(
  filename = "img/logistic_probabilities.png",
  plot = logistic_plot,
  width = 7, height = 5, dpi = 300
)

# ROC curve plot and save
roc_plot <- ggroc(roc_obj, color = "green", size = 1.2) +
  labs(
    title = "ROC Curve for Logistic Regression Model",
    x = "False Positive Rate",
    y = "True Positive Rate"
  ) +
  theme_minimal(base_size = 14)

roc_plot

ggsave(
  filename = "img/roc_curve.png",
  plot = roc_plot,
  width = 7,
  height = 5,
  dpi = 300
)
