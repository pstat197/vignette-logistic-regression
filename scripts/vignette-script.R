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

library(tidymodels)
set.seed(123)
data_split <- initial_split(df_clean, prop = 0.8)

train <- training(data_split)
test <- testing(data_split)

glimpse(df_clean)
table(df_clean$target)


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

