options(width = 105)
knitr::opts_chunk$set(dev='png', dpi=300, cache=FALSE)
pdf.options(useDingbats = TRUE)
klippy::klippy(position = c('top', 'right'))

# read regrex3.csv
# modify the following path to reflect local files
csv_path <- "/Users/bartlein/projects/RESS/data/csv_files/"
csv_name <- "regrex3.csv"
csv_file <- paste(csv_path, csv_name, sep="")
regrex3 <- read.csv(csv_file) 

# regrex3
attach(regrex3)
summary(regrex3)
head(cbind(y5,x1,x2))

# create the column vector y
n <- length(y5)
y <- matrix(y5, nrow=n, ncol=1)
dim(y)
head(y)

# create the predictor-variable matrix
X <- matrix(cbind(rep(1,n),x1,x2), nrow=n, ncol=3)
dim(X)
head(X)

# calculate the regression coefficients
b <- solve(t(X) %*% X) %*% (t(X) %*% y)
print(b)
dim(b)

# linear model with lm()
lm1 <- lm(y5 ~ x1+x2, data=regrex3)
lm1

# matrix fitted values
yhat <- X %*% b

head(cbind(yhat,lm1$fitted.values))

library(ggplot2)
library(forecast)

# read NOAA monthly temperature, ONI (ENSO), and CO2
# modify the following path to reflect local files
csv_path <- "/Users/bartlein/projects/RESS/data/csv_files/"
csv_name <- "NOAA_Globe_T_ENSO_CO2_1950-2023.csv"
csv_file <- paste(csv_path, csv_name, sep="")
NOAA <- read.csv(csv_file) 
str(NOAA)
summary(NOAA)

# recode ONI_code as a factor
NOAA$ONI_code <- factor(NOAA$ONI_code, levels = c("La Niña", "Neutral", "El Niño"))

# plots
plot(T_LandOcean ~ YrMn, type = "l", col = "gray70", lwd = 1.5, data = NOAA)
points(T_LandOcean ~ YrMn, pch = 16, cex =0.8, data = NOAA)

# ggplot2 version
ggplot(data = NOAA, aes(x=YrMn, y=T_LandOcean)) + 
  geom_line(color = "gray70") +
  geom_point(size = 1) + 
  scale_x_continuous(breaks = seq(1950, 2025, by = 10)) +
  scale_y_continuous(limits = c(-0.75, 1.25), breaks = seq(-1.75, 1.25, by = 0.25),
                     minor_breaks = seq(-0.75, 1.25, by = 0.05)) +
  labs(title = paste("NOAA Global Average Temperature Anomalies (","°","C)", sep = ""), 
       x = "Year", y = "Land + Ocean") + 
  theme_bw()


# remove records with missing CO2
NOAA2 <- NOAA[!is.na(NOAA[, 10]), ]
summary(NOAA2)
str(NOAA2)
head(NOAA2)

# simple linear (OLS) regression line
lm_01 <- lm(T_LandOcean ~ YrMn, data = NOAA)
summary(lm_01)
AIC(lm_01)

# examine the fitted model -- residuals
plot(T_LandOcean ~ YrMn, data = NOAA, type="n")
abline(lm_01)
segments(NOAA$YrMn, fitted(lm_01), NOAA$YrMn, NOAA$T_LandOcean, col = "gray")
points(T_LandOcean ~ YrMn, data = NOAA, pch = 16, cex = 0.5)

# examine the fitted model -- prediction and confidence limits
plot(T_LandOcean ~ YrMn, data = NOAA, type="n")
abline(lm_01)
points(T_LandOcean ~ YrMn, data = NOAA, pch = 16, cex = 0.5)
pred_data <- data.frame(YrMn=NOAA$YrMn)
pred_int <- predict(lm_01, int="p", newdata=pred_data)
conf_int <- predict(lm_01, int="c", newdata=pred_data)
matlines(pred_data$YrMn, pred_int, lty=c(1,2,2), col="black")
matlines(pred_data$YrMn, conf_int, lty=c(1,2,2), col="orange")

# regression diagnostics
oldpar <- par(mfrow = c(2, 2))
plot(lm_01, which=c(1,2,4))
acf(lm_01$residuals)
par(oldpar)

# examine the regression equation again, by ENSO state
pal <- c("blue", "gray", "red")
plot(T_LandOcean ~ YrMn, data = NOAA, type="n")
abline(lm_01)
segments(NOAA$YrMn, fitted(lm_01), NOAA$YrMn, NOAA$T_LandOcean, col = "gray")
points(T_LandOcean ~ YrMn, data = NOAA, pch = 16, cex = 0.8, col = pal[ONI_code])

# points colored by ENSO state
ggplot() + 
  geom_line(data = NOAA, aes(x = YrMn, y = T_LandOcean)) +
  geom_abline(intercept = lm_01$coefficients[1], slope = lm_01$coefficients[2], color = "black") +
  geom_point(data = NOAA, aes(x = YrMn, y = T_LandOcean, color = ONI_code), size = 1.5) + 
  geom_point(data = NOAA, aes(x = YrMn, y = T_LandOcean), color = "black", shape = 1, size = 1.5) +
  scale_color_manual(values = c("blue", "gray", "red"),
                     limits = c("La Niña", "Neutral", "El Niño")) +
  scale_x_continuous(breaks = seq(1950, 2025, by = 10)) +
  scale_y_continuous(limits = c(-0.75, 1.25), breaks = seq(-1.75, 1.25, by = 0.25), 
                     minor_breaks = seq(-0.75, 1.25, by = 0.05)) +
  labs(title = paste("NOAA Global Average Temperature Anomalies (","°","C)", sep = ""), 
       x = "Year", y = "Land + Ocean") + 
  guides(color = guide_legend(override.aes = list(size = 3))) +
  theme_bw()

# residuals
ggplot() + 
  geom_line(data = NOAA, aes(x = YrMn, y = residuals(lm_01))) +
  geom_point(data = NOAA, aes(x = YrMn, y = residuals(lm_01), color = ONI_code), size = 1.5) + 
  geom_point(data = NOAA, aes(x = YrMn, y = residuals(lm_01)), color = "black", shape = 1, size = 1.5) +
  scale_color_manual(values = c("blue", "gray", "red"),
                     limits = c("La Niña", "Neutral", "El Niño")) +
  scale_x_continuous(breaks = seq(1950, 2025, by = 10)) +
  scale_y_continuous(limits = c(-0.75, 1.25), breaks = seq(-1.75, 1.25, by = 0.25)
                     , minor_breaks = seq(-0.75, 1.25, by = 0.05)) +
  labs(title = paste("NOAA Global Average Temperature Anomalies (","°","C)", sep = ""), 
       x = "Year", y = "Land + Ocean (Residuals)") + 
  guides(color = guide_legend(override.aes = list(size = 3))) +
  theme_bw()

# residual grouped boxplot
opar <- par(mfrow=c(1,3))
boxplot(residuals(lm_01) ~ NOAA$ONI_code, ylim=c(-1,1))
par(opar)

# dummy-variable regression
lm_02 <- lm(T_LandOcean ~ YrMn + ONI_code, data = NOAA)
summary(lm_02)

# print AIC values
print(c(AIC(lm_01), AIC(lm_02)))

# compare model by ANOVA
anova(lm_01, lm_02)

# display the fitted lines
plot(T_LandOcean ~ YrMn, data = NOAA, type="n")
points(T_LandOcean ~ YrMn, data = NOAA, pch = 16, cex = 0.5)
legend("bottomright", legend=c("La Niña", "Neutral", "El Niño"), lty=c(1,1,1), lwd=3, cex=1, col=c("blue","gray","red"))

lines(fitted(lm_02)[NOAA$ONI_code == "La Niña"] ~ NOAA$YrMn[NOAA$ONI_code == "La Niña"], lwd=2, col="blue")
lines(fitted(lm_02)[NOAA$ONI_code == "Neutral"] ~ NOAA$YrMn[NOAA$ONI_code == "Neutral"], lwd=2, col="gray")
lines(fitted(lm_02)[NOAA$ONI_code == "El Niño"] ~ NOAA$YrMn[NOAA$ONI_code == "El Niño"], lwd=2, col="red")

# residual grouped boxplot
opar <- par(mfrow=c(1,3))
boxplot(residuals(lm_01) ~ NOAA$ONI_code, ylim=c(-1,1))
boxplot(residuals(lm_02) ~ NOAA$ONI_code, ylim=c(-1,1))
par(opar)

# dummy-variable regression, slope and intercept varying
lm_03 <- lm(T_LandOcean ~ YrMn * ONI_code, data = NOAA)
summary(lm_03)

# print AIC values
print(c(AIC(lm_01), AIC(lm_02), AIC(lm_03)))

# compare via ANOVA
anova(lm_02, lm_03)

# display the fitted lines
plot(T_LandOcean ~ YrMn, data = NOAA, type="n")
points(T_LandOcean ~ YrMn, data = NOAA, pch = 16, cex = 0.5)
legend("bottomright", legend=c("La Niña", "Neutral", "El Niño"), lty=c(1,1,1), lwd=3, cex=1, col=c("blue","gray","red"))

lines(fitted(lm_03)[NOAA$ONI_code == "La Niña"] ~ NOAA$YrMn[NOAA$ONI_code == "La Niña"], lwd=2, col="blue")
lines(fitted(lm_03)[NOAA$ONI_code == "Neutral"] ~ NOAA$YrMn[NOAA$ONI_code == "Neutral"], lwd=2, col="gray")
lines(fitted(lm_03)[NOAA$ONI_code == "El Niño"] ~ NOAA$YrMn[NOAA$ONI_code == "El Niño"], lwd=2, col="red")

# display the fitted lines
plot(T_LandOcean ~ YrMn, data = NOAA, type="n")
points(T_LandOcean ~ YrMn, data = NOAA, pch = 16, cex = 0.5)
legend("bottomright", legend=c("La Niña", "Neutral", "El Niño"), lty=c(1,1,1), lwd=3, cex=1, col=c("blue","gray","red"))

lines(fitted(lm_03)[NOAA$ONI_code == "La Niña"] ~ NOAA$YrMn[NOAA$ONI_code == "La Niña"], lwd=2, col="blue")
lines(fitted(lm_03)[NOAA$ONI_code == "Neutral"] ~ NOAA$YrMn[NOAA$ONI_code == "Neutral"], lwd=2, col="gray")
lines(fitted(lm_03)[NOAA$ONI_code == "El Niño"] ~ NOAA$YrMn[NOAA$ONI_code == "El Niño"], lwd=2, col="red")
lines(fitted(lm_02)[NOAA$ONI_code == "La Niña"] ~ NOAA$YrMn[NOAA$ONI_code == "La Niña"], lwd=1, lty = 2, col="blue")
lines(fitted(lm_02)[NOAA$ONI_code == "Neutral"] ~ NOAA$YrMn[NOAA$ONI_code == "Neutral"], lwd=1, lty = 2,col="black")
lines(fitted(lm_02)[NOAA$ONI_code == "El Niño"] ~ NOAA$YrMn[NOAA$ONI_code == "El Niño"], lwd=1, lty = 2,col="red")

plot(CO2_mean ~ YrMn, data = NOAA2, pch = 16, col = "red", cex = 0.3, ylab = expression("Mauna Loa CO"[2]))
points(CO2_deseas ~ YrMn, data = NOAA2, pch = 16, col = "black", cex = 0.2)

# simple linear (OLS) regression line, only with NOAA2
lm_04 <- lm(T_LandOcean ~ YrMn, data = NOAA2)
summary(lm_04)
AIC(lm_04)

# simple linear (OLS) regression line, CO2 as predictor
lm_05 <- lm(T_LandOcean ~ CO2_deseas, data = NOAA2)
summary(lm_05)
AIC(lm_05)

# regression diagnostics
oldpar <- par(mfrow = c(2, 2))
plot(lm_05, which=c(1,2,4))
acf(residuals(lm_05))
par(oldpar)

print(c(AIC(lm_04), AIC(lm_05)))

# points colored by ENSO state
ggplot() + 
  geom_abline(intercept = lm_05$coeff[1], slope = lm_05$coeff[2], color = "black") +
  geom_point(data = NOAA2, aes(x = CO2_deseas, y = T_LandOcean, color = ONI_code), size = 2) + 
  geom_point(data = NOAA2, aes(x = CO2_deseas, y = T_LandOcean), color = "black", shape = 1, size = 2) +
  scale_color_manual(values = c("blue", "gray", "red"),
                     limits = c("La Niña", "Neutral", "El Niño")) +
  scale_x_continuous(breaks = seq(315, 430, by = 15)) +
  scale_y_continuous(limits = c(-0.75, 1.25), breaks = seq(-1.75, 1.25, by = 0.25),
                     minor_breaks = seq(-0.75, 1.25, by = 0.05)) +
  labs(title = paste("NOAA Global Average Temperature Anomalies (","°","C)", sep = ""), 
       x = expression(CO[2]~" "(ppm)), y = "Land + Ocean") + 
  guides(color = guide_legend(override.aes = list(size = 3))) +
  theme_bw()

# dummy-variable regression
lm_06 <- lm(T_LandOcean ~ CO2_deseas + ONI_code, data = NOAA2)
summary(lm_06)
print(c(AIC(lm_05), AIC(lm_06)))
anova(lm_05, lm_06)

# display the fitted lines
plot(T_LandOcean ~ CO2_deseas, data = NOAA2, type="n")
points(T_LandOcean ~ CO2_deseas, data = NOAA2, pch = 16, cex = 0.5)
legend("bottomright", legend=c("La Niña", "Neutral", "El Niño"), lty=c(1,1,1), lwd=3, cex=1, col=c("blue","gray","red"))

lines(fitted(lm_06)[NOAA2$ONI_code == "La Niña"] ~ NOAA2$CO2_deseas[NOAA2$ONI_code == "La Niña"], lwd=2, col="blue")
lines(fitted(lm_06)[NOAA2$ONI_code == "Neutral"] ~ NOAA2$CO2_deseas[NOAA2$ONI_code == "Neutral"], lwd=2, col="gray")
lines(fitted(lm_06)[NOAA2$ONI_code == "El Niño"] ~ NOAA2$CO2_deseas[NOAA2$ONI_code == "El Niño"], lwd=2, col="red")


# intercepts and slopes lm_06
ln_intercept <- lm_06$coeff[1]
ln_slope <- lm_06$coeff[2]
n_intercept <- lm_06$coeff[1] + lm_06$coeff[3]
n_slope <- lm_06$coeff[2] 
en_intercept <- lm_06$coeff[1] + lm_06$coeff[4]
en_slope <- lm_06$coeff[2] 

# ggplot2 plot with regression line
ggplot(data = NOAA2, aes(x = CO2_deseas, y = T_LandOcean)) + 
  geom_abline(intercept = ln_intercept, slope = ln_slope, color = "blue") +
  geom_abline(intercept = n_intercept, slope = n_slope, color = "gray40") +
  geom_abline(intercept = en_intercept, slope = en_slope, color = "red") +
  geom_point(data = NOAA2, aes(x=CO2_deseas, y=T_LandOcean, color = ONI_code), size = 2) + 
  geom_point(data = NOAA2, aes(x=CO2_deseas, y=T_LandOcean), color = "black",shape = 1, size = 2 ) +
  scale_color_manual(values = c("blue", "gray", "red"),
                     limits = c("La Niña", "Neutral", "El Niño")) + 
  scale_x_continuous(breaks = seq(315, 430, by = 15)) +
  scale_y_continuous(limits = c(-0.75, 1.25), breaks = seq(-1.75, 1.25, by = 0.25), 
                     minor_breaks = seq(-0.75, 1.25, by = 0.05)) +
  labs(title = paste("NOAA Global Average Temperature Anomalies (","°","C)", sep = ""), 
       x = expression(CO[2]~" "(ppm)), y = "Land + Ocean") + 
  theme_bw()

# scatter plot with CO2-fitted values ===============================
ln_fit <- ln_intercept + ln_slope*NOAA2$CO2_deseas
n_fit <- n_intercept + n_slope*NOAA2$CO2_deseas
en_fit <- en_intercept + n_slope*NOAA2$CO2_deseas

# ggplot2 plot with fitted values line
ggplot(data = NOAA2, aes(x = YrMn, y = T_LandOcean)) + 
  geom_point(aes(x = NOAA2$YrMn, y = ln_fit), color = "blue", shape = 4, size = 0.5) +
  geom_point(aes(x = NOAA2$YrMn, y = n_fit), color = "gray", shape = 4, size = 0.5) +
  geom_point(aes(x = NOAA2$YrMn, y = en_fit), color = "red", shape = 4, size = 0.5) +
  geom_point(data = NOAA2, aes(x=YrMn, y=T_LandOcean, color = ONI_code), size = 2) + 
  geom_point(data = NOAA2, aes(x=YrMn, y=T_LandOcean), color = "black",shape = 1, size = 2 ) +
  scale_color_manual(values = c("blue", "gray", "red"),
                     limits = c("La Niña", "Neutral", "El Niño")) + 
  scale_x_continuous(breaks = seq(1960, 2025, by = 10)) +
  scale_y_continuous(limits = c(-0.75, 1.25), breaks = seq(-1.75, 1.25, by = 0.25), 
                     minor_breaks = seq(-0.75, 1.25, by = 0.05)) +
  labs(title = paste("NOAA Global Average Temperature Anomalies (","°","C)", sep = ""), 
       x = "Year", y = "Land + Ocean") + 
  theme_bw()

# second-order polynomial
lm_07 <- lm(T_LandOcean ~ poly(YrMn, 2, raw = TRUE), data = NOAA)
summary(lm_07)
AIC(lm_07)
# regression diagnostics
oldpar <- par(mfrow = c(2, 2))
plot(lm_07, which=c(1,2,4))
acf(lm_07$residuals)
par(oldpar)

# examine the regression equation again, by ENSO state
pal <- c("blue", "gray", "red")
plot(T_LandOcean ~ YrMn, data = NOAA, type="n")
segments(NOAA$YrMn, fitted(lm_07), NOAA$YrMn, NOAA$T_LandOcean, col = "gray")
lines(NOAA$YrMn, fitted(lm_07))
points(T_LandOcean ~ YrMn, data = NOAA, pch = 16, cex = 0.8, col = pal[ONI_code])

# ggplot2 plot with regression line
ggplot(data = NOAA, aes(x = YrMn, y = T_LandOcean)) + 
  geom_line(color = "gray70") +
  geom_point(data = NOAA, aes(x = YrMn, y = T_LandOcean, color = ONI_code), size = 2) + 
  geom_point(data = NOAA, aes(x = YrMn, y = T_LandOcean), color = "black", shape = 1, size = 2) +
  scale_color_manual(values = c("blue", "gray", "red"),
                     limits = c("La Niña", "Neutral", "El Niño")) +
  geom_smooth(method = "lm", se = TRUE, level = 0.95) +
  geom_smooth(method = "loess", se = TRUE, level = 0.95, col = "purple") +
  geom_line(aes(x = YrMn, y = fitted(lm_07)), color = "black", size = 1) +
  scale_x_continuous(breaks = seq(1950, 2025, by = 10)) +
  scale_y_continuous(limits = c(-0.75, 1.25), breaks = seq(-1.75, 1.25, by = 0.25), 
                     minor_breaks = seq(-0.75, 1.25, by = 0.05)) +
  labs(title = paste("NOAA Global Average Temperature Anomalies (","°","C)", sep = ""), 
       x = "Year", y = "Land + Ocean") + 
  theme_bw() 

# residual grouped boxplot
opar <- par(mfrow=c(1,3))
boxplot(residuals(lm_01) ~ NOAA$ONI_code, ylim=c(-1,1))
boxplot(residuals(lm_07) ~ NOAA$ONI_code, ylim=c(-1,1))
par(opar)

# simple linear (OLS) regression line
lm_08 <- lm(T_LandOcean ~ poly(YrMn, 2, raw = TRUE) + ONI_code, data = NOAA)
summary(lm_08)
AIC(lm_08)

# get the fitted values
ln_fit <- lm_08$coeff[1] + lm_08$coeff[2] * NOAA2$YrMn + lm_08$coeff[3] * NOAA2$YrMn^2
n_fit <- (lm_08$coeff[1] + lm_08$coeff[4]) + lm_08$coeff[2] * NOAA2$YrMn + lm_08$coeff[3] * NOAA2$YrMn^2
en_fit <- (lm_08$coeff[1] + lm_08$coeff[5]) + lm_08$coeff[2] * NOAA2$YrMn + lm_08$coeff[3] * NOAA2$YrMn^2

# ggplot2 plot with fitted values line
ggplot(data = NOAA2, aes(x = YrMn, y = T_LandOcean)) + 
  geom_line(aes(x = NOAA2$YrMn, y = ln_fit), color = "blue", linewidth = 1.0) +
  geom_line(aes(x = NOAA2$YrMn, y = n_fit), color = "gray", linewidth = 1.0) +
  geom_line(aes(x = NOAA2$YrMn, y = en_fit), color = "red", linewidth = 1.0) +
  geom_point(data = NOAA2, aes(x=YrMn, y=T_LandOcean, color = ONI_code), size = 2) + 
  geom_point(data = NOAA2, aes(x=YrMn, y=T_LandOcean), color = "black",shape = 1, size = 2 ) +
  scale_color_manual(values = c("blue", "gray", "red"),
                     limits = c("La Niña", "Neutral", "El Niño")) + 
  scale_x_continuous(breaks = seq(1960, 2025, by = 10)) +
  scale_y_continuous(limits = c(-0.75, 1.25), breaks = seq(-1.75, 1.25, by = 0.25), 
                     minor_breaks = seq(-0.75, 1.25, by = 0.05)) +
  labs(title = paste("NOAA Global Average Temperature Anomalies (","°","C)", sep = ""), 
       x = "Year", y = "Land + Ocean") + 
  theme_bw()

# regression diagnostics
oldpar <- par(mfrow = c(2, 2))
plot(lm_08, which=c(1,2,4))
acf(lm_08$residuals)
par(oldpar)

print(c(AIC(lm_01), AIC(lm_03), AIC(lm_08)))

# anova
anova(lm_07, lm_08)
anova(lm_01, lm_08)

# residual grouped boxplot
opar <- par(mfrow=c(1,3))
boxplot(residuals(lm_01) ~ NOAA$ONI_code, ylim=c(-1,1))
boxplot(residuals(lm_02) ~ NOAA$ONI_code, ylim=c(-1,1))
boxplot(residuals(lm_08) ~ NOAA$ONI_code, ylim=c(-1,1))
par(opar)

# make the dummy variables
dum_ln <- rep(0, length(NOAA$YrMn))
dum_n <- rep(0, length(NOAA$YrMn))
dum_en <- rep(0, length(NOAA$YrMn))
dum_ln[NOAA$ONI_code == "La Niña"] <- 1
dum_n[NOAA$ONI_code == "Neutral"] <- 1
dum_en[NOAA$ONI_code == "El Niño"] <- 1
# head(cbind(dum_ln, dum_n, dum_en), 30)

# make regression dataframe
xreg <- data.frame(NOAA$YrMn, NOAA$YrMn^2, dum_n, dum_en) # note: leave dum_ln out
names(xreg) <- c("YrMn", "YrMn^2", "Neutral", "El Niño")
head(xreg)

# time series regression, AR(2) and MA(2)
tsreg_01 <- arima(NOAA$T_LandOcean, order = c(2, 0, 2), xreg = xreg, include.mean = TRUE)
tsreg_01

checkresiduals(tsreg_01, test = "LB", lag = 12)

# list the coefficients of the model
tsreg_01$coef
# the intercept is the 5-th term in the model
c1 <- 5
# fitted values
ln_fit <- tsreg_01$coef[c1] + tsreg_01$coef[c1 + 1] * NOAA2$YrMn + tsreg_01$coef[c1 + 2] * NOAA2$YrMn^2
n_fit <- (tsreg_01$coef[c1] + tsreg_01$coef[c1 + 3]) + tsreg_01$coef[c1 + 1] * NOAA2$YrMn + tsreg_01$coef[c1 + 2] * NOAA2$YrMn^2
en_fit <- (tsreg_01$coef[c1] + tsreg_01$coef[c1 + 4]) + tsreg_01$coef[c1 + 1] * NOAA2$YrMn + tsreg_01$coef[c1 + 2] * NOAA2$YrMn^2
head(cbind(ln_fit, n_fit, en_fit))

# ggplot2 plot with fitted values line
ggplot(data = NOAA2, aes(x = YrMn, y = T_LandOcean)) + 
  geom_line(aes(x = NOAA2$YrMn, y = ln_fit), color = "blue", linewidth = 1.0) +
  geom_line(aes(x = NOAA2$YrMn, y = n_fit), color = "gray", linewidth = 1.0) +
  geom_line(aes(x = NOAA2$YrMn, y = en_fit), color = "red", linewidth = 1.0) +
  geom_point(data = NOAA2, aes(x=YrMn, y=T_LandOcean, color = ONI_code), size = 2) + 
  geom_point(data = NOAA2, aes(x=YrMn, y=T_LandOcean), color = "black",shape = 1, size = 2 ) +
  scale_color_manual(values = c("blue", "gray", "red"),
                     limits = c("La Niña", "Neutral", "El Niño")) + 
  scale_x_continuous(breaks = seq(1960, 2025, by = 10)) +
  scale_y_continuous(limits = c(-0.75, 1.25), breaks = seq(-1.75, 1.25, by = 0.25)
                     , minor_breaks = seq(-0.75, 1.25, by = 0.05)) +
  labs(title = paste("NOAA Global Average Temperature Anomalies (","°","C)", sep = ""), 
       x = "Year", y = "Land + Ocean") + 
  theme_bw()

# residual diagnostics
oldpar <- par(mfrow = c(2, 2))
plot(fitted(tsreg_01), tsreg_01$residuals)
qqnorm(tsreg_01$residuals)
qqline(tsreg_01$residuals)
acf(tsreg_01$residuals)
par(oldpar)

print(c(AIC(lm_01), AIC(lm_08), AIC(tsreg_01)))

# residual grouped boxplot
opar <- par(mfrow=c(1,3))
boxplot(residuals(lm_01) ~ NOAA$ONI_code, ylim=c(-1,1))
boxplot(residuals(lm_08) ~ NOAA$ONI_code, ylim=c(-1,1))
boxplot(residuals(tsreg_01) ~ NOAA$ONI_code, ylim=c(-1,1))
par(opar)

plot(NOAA$YrMn, residuals(lm_08), type = "l", col = "magenta")
lines(NOAA$YrMn, tsreg_01$residuals, type = "l", col = "green")

# slope is first derivative of the polynomial,
# If f(x) = b0 + b1 * x + b2 * x^2, then f'(x) = 2 * b2 * x + b1
c1 <- 5
slope <- 2.0 * tsreg_01$coef[c1 + 2] * NOAA$YrMn + tsreg_01$coef[c1 + 1]
plot(NOAA$YrMn, slope, type = "o", cex = 0.5, col = "red", xlab = "Year", ylab = "slope (degC/Year)")

slope_1960 <- 2.0 * tsreg_01$coef[c1 + 2] * 1960 + tsreg_01$coef[c1 + 1]
slope_2020 <- 2.0 * tsreg_01$coef[c1 + 2] * 2020 + tsreg_01$coef[c1 + 1]
slope_ratio <- (slope_2020 / slope_1960)

slopes <- data.frame(slope_1960, slope_2020, slope_ratio)
colnames(slopes) <- c("slope 1960", "slope_2020", "ratio")
rownames(slopes) <- NULL
slopes
