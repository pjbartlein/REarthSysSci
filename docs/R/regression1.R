# read regrex1.csv
# modify the following path to reflect local files
csv_path <- "/Users/bartlein/projects/RESS/data/csv_files/"
csv_name <- "regrex1.csv"
csv_file <- paste(csv_path, csv_name, sep="")
regrex1 <- read.csv(csv_file) 

plot(y ~ x, data=regrex1)

# fit the model
ex1_lm <- lm(y ~ x, data=regrex1)

# examine the model object
print(ex1_lm)
summary(ex1_lm)
attributes(ex1_lm)

# plot the regression line
plot(y ~ x, data=regrex1)
abline(ex1_lm, col="red", lwd=2)

plot (y ~ x, data=regrex1)
abline(ex1_lm, col="red", lwd=2)
# plot deviations
segments(regrex1$x, fitted(ex1_lm), regrex1$x, regrex1$y, col="red")

# examine the model object
ex1_lm
summary(ex1_lm)

# get and plot prediction intervals and confidence intervals
pred_data <- data.frame(x=seq(1:25))
pred_int <- predict(ex1_lm, int="p", newdata=pred_data)
conf_int <- predict(ex1_lm, int="c", newdata=pred_data)
# plot the data
ylim=range(regrex1$y, pred_int, na.rm=T, lwd=2)
plot(regrex1$x, regrex1$y, ylim=ylim)
pred_ex1 <- pred_data$x
matlines(pred_ex1, pred_int, lty=c(1,2,2), col="black")
matlines(pred_ex1, conf_int, lty=c(1,2,2), col="red")

# read regrex2.csv
# modify the following path to reflect local files
csv_path <- "/Users/bartlein/projects/RESS/data/csv_files/"
csv_name <- "regrex2.csv"
csv_file <- paste(csv_path, csv_name, sep="")
regrex2 <- read.csv(csv_file) 

summary(regrex2)

opar <- par(mfcol = c(1,2))
plot(y1 ~ x, data=regrex2, main="Example 1")
plot(y2 ~ x, data=regrex2, main="Example 2")

ex2_lm <- lm(y2 ~ x, data=regrex2)
summary(ex2_lm)

summary(ex1_lm)

opar <- par(mfcol = c(1,2))
plot(y1 ~ x, data=regrex2, main="Example 1")
abline(ex1_lm, col="red", lwd=2)
segments(regrex2$x, fitted(ex1_lm), regrex2$x, regrex2$y1, col="red")
plot(y2 ~ x, data=regrex2, main="Example 2")
abline(ex2_lm, col="blue", lwd=2)
segments(regrex2$x, fitted(ex2_lm), regrex2$x, regrex2$y2, col="blue")

# standard regression diagnostics (4-up)
oldpar <- par(mfrow = c(2, 2))
plot(ex1_lm, which=c(1,2,4,5))
par(oldpar)

# fit a linear regression equation by
# minimizing the sum of squared residuals
# uses regrex1.csv

# set some constant values
n <- length(regrex2$y1)
K <- 1

# intercept values range
n_b0 <- 11
b0_min <- 1.0 # 2.00 # 2.24
b0_max <- 3.0 # 2.40 # 2.25
# slope values range
n_b1 <- 11
b1_min <- 0.0 # 0.4 # 0.46
b1_max <- 1.0 # 0.5 # 0.47
# coefficents
b0 <- seq(b0_min, b0_max, len=n_b0)
b1 <- seq(b1_min, b1_max, len=n_b1)
 
# space for residual standard-error values
rse <- matrix(nrow=n_b0*n_b1, ncol=3)
colnames(rse) <- c("b0", "b1", "rse")

# matrix for residual sum of squares
rss <- matrix(NA, nrow=n_b0, ncol=n_b1)

plot(y1 ~ x, data=regrex2)
m <- 0
for (j in 1:n_b0) {
    for (k in 1:n_b1) {
        m <- m + 1
        sse <- 0.0
        for (i in 1:n) {
            sse <- sse + (regrex2$y1[i] - b0[j] - b1[k]*regrex2$x[i])^2
        }
        rss[j, k] <- sse
        rse[m,1] <- b0[j]
        rse[m,2] <- b1[k]
        rse[m,3] <- sqrt(sse/(n-K-1))
        abline(b0[j], b1[k], col="gray")
    }
}

# find the coefficients that minimize the rse
m_min <- which.min(rse[,3])
print(m_min)
print(c(rse[m_min,1],rse[m_min,2],rse[m_min,3]))

# plot the line for the optimal coefficients
abline(rse[m_min,1],rse[m_min,2], col="purple", lwd=2)
# plot the OLS regression line
abline(ex1_lm, col="red", lwd=2)

image(b0, b1, rss, col  = gray((9:64)/64))
