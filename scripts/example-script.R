# Load packages
library(readr)
library(caret)
library(randomForest)
library(ggplot2)

# Check the input and output directories
input_dir <- "./../data"
output_dir <- "./../output"
# Create output folder if not exists
if (!dir.exists(output_dir)) dir.create(output_dir)

# 1. Read the dataset
data <- read_csv(file.path(input_dir, "fashion-mnist.csv"), show_col_types = FALSE)

# 2. Split into features and labels
labels <- as.factor(data$label)         # RF expects factors for classification
features <- as.data.frame(data[ , -1]) # keep as dataframe

# 3. Train/test split
set.seed(123)
train_idx <- sample(1:nrow(data), 0.8 * nrow(data))
x_train <- features[train_idx, ]
y_train <- labels[train_idx]
x_test  <- features[-train_idx, ]
y_test  <- labels[-train_idx]

# 4. Define training control
ctrl <- trainControl(
  method = "cv",        # cross-validation
  number = 3,           # 3-fold
  verboseIter = TRUE
)

# 5. Train a random forest model
set.seed(123)
model <- train(
  x = x_train, 
  y = y_train,
  method = "rf", 
  trControl = ctrl,
  tuneLength = 3,       # try a few mtry values
  ntree = 100           # number of trees
)

# 6. Evaluate
preds <- predict(model, x_test)
conf_mat <- confusionMatrix(preds, y_test)
print(conf_mat)

# 7. Save results

# Save accuracy history (caret keeps resampling results)
history_df <- model$results
history_df$index <- 1:nrow(history_df)

# Plot Accuracy vs mtry
acc_plot <- ggplot(history_df, aes(x = mtry, y = Accuracy)) +
  geom_line(color = "blue", size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Random Forest Accuracy by mtry",
    x = "mtry (features tried per split)",
    y = "Accuracy"
  ) +
  theme_minimal()

# Save the plot as PNG
ggsave(filename = file.path(output_dir, "rf_accuracy_plot.png"),
       plot = acc_plot, width = 6, height = 4)

# Save the trained model
saveRDS(model, file = file.path(output_dir, "rf_model.rds"))
