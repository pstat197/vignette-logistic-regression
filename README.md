## vignette-logistic-regression
A simple vignette demonstrating binary logistic regression in R using the UCI Heart Disease dataset.

Vignette on implementing logistic regression in R using the UCI Heart Disease dataset; 
created for final assignment for PSTAT197A in Fall 2025.

**Completed independently + remotely by Angie Sethi**

This vignette introduces logistic regression for binary classification using 
the Heart Disease dataset from the UCI Machine Learning Repository. The goal is
to illustrate how to fit a logistic regression model in R, interpret its 
coefficients, visualize results, and evaluate model performance using accuracy 
and ROC curves. The example is intentionally simple and designed for students 
encountering logistic regression for the first time.

# Repository contents is as follows: 

-data/
 --raw/ # original heart.csv
  ---heart_disease_uci.csv
 --processed/ # cleaned dataset used in the example
  ---heart_clean.csv

-scripts/
 --vignette-script.R # fully annotated script that reproduces the vignette

-img/
 --roc_curve.png
 --logistic_probabilities.png
 
-vignette.qmd # main teaching document
-vignette.html # rendered vignette
-README.md

# References:
1. UCI Machine Learning Repository – Heart Disease dataset: 
https://www.kaggle.com/datasets/redwankarimsony/heart-disease-data?resource=download 
2. A Systematic Review of Major Cardiovascular Risk Factors: A Growing Global Health Concern
https://pmc.ncbi.nlm.nih.gov/articles/PMC9644238/
3. Big data is helping to solve the mysteries of heart disease
https://www.nature.com/articles/d42473-024-00287-w 
