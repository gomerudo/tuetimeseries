# Exercise 2.3: Univariate Time Series - Exponential Smoothing Models


## a) For the time series in Exercise 1.1 and 1.2 select an adequate Exponential Smoothing Model to predict future values. Fit the model by estimating its parameters. Verify the model on the basis of the residuals, their (partial) autocorrelations and Goodness-of-Fit measures such as RMSE, MAE and MAPE.

For this exercise, the dataset `laborforce.RData` has been selected (as per professor's suggestion). First we show how to prepare the data in the cell below.

```
# Make the time sequence plot
tsdisplay(data.ts)
```
Initial time sequence plot                            |
:----------------------------------------------------:|
![](img/1_1_initial.png "Initial time sequence plot") |

**Analysis**

Since we have corrected the seasonality, we may like trying to fit a Holt model, i.e. only `gamma` parameter set to false (no seasonality). This model contain a equation for trend.

### Fit the model by estimating its parameters and give an interpretation for the parametervalues obtained. 

```
data.ses <- HoltWinters(data.corrected, gamma = FALSE)

Holt-Winters exponential smoothing without trend and without seasonal component.

Call:
HoltWinters(x = data.corrected4, seasonal = "additive")

Smoothing parameters:
 alpha: 0.2479595
 beta : 0.03453373
 gamma: 1

Coefficients:
          [,1]
a   477.827781
b     3.127627
s1  -27.457685
s2  -54.692464
s3  -20.174608
s4   12.919120
s5   18.873607
s6   75.294426
s7  152.888368
s8  134.613464
s9   33.778349
s10 -18.379060
s11 -87.772408
s12 -45.827781
```

Exponential Smoothing fitted                            |
:----------------------------------------------------:|
![](img/2_3_a_0.png "Corrected") |


**Analysis**

The parameters in this case are telling that the importance in the level for the recen past is somehow low. The beta value tells me that the recent trend is taking more importance in the forecasting, but still not really dominant. 

With respect to the coefficients, My last level is negative since, as we can see in the plot, my predication at the last point in time is going down. The trend coefficient is, on the other hand, positive, moving the value a bit to the top with respect with old predictions. This model seems more accurate, but is still showing errors that can be confirmed next.

### Verify the model on the basis of the residuals, their (partial) autocorrelations and Goodness-of-Fit measures such as RMSE, MAE and MAPE. 

We start with the metrics evaluation:

```
with(data.ses, accuracy(fitted, x))

               ME     RMSE      MAE       MPE     MAPE     ACF1 Theil's U
Test set 1.753445 12.86886 9.774438 0.3992849 3.400129 0.424139 0.4211919
```

In contrast to the previous model, the error seems higher since the model is not completely aligning the series though it behaves more "random".

This is not a clear indicator of the performance of the model. So we proceed to forecast and evaluate normality of the residuals and partial autocorrelations.

To verify normality of the residuals, we first forecast 10 values:

```
data.ses.fore <- forecast(data.ses, h = 10)
```

Forecast                            |
:----------------------------------------------------:|
![](img/2_3_a_1.png "Forecast") |


After that, we evaluate normality:

```
> shapiro.test(data.ses.fore$residuals)

    Shapiro-Wilk normality test

data:  data.ses.fore$residuals
W = 0.98834, p-value = 0.3297
```

We reject normality since p-value < 0.05 (we assume significance of 5%). We need to be careful since this test is sensitive to ties which was not verified for our dataset. By looking at the residuals we can observe this in detail.

```
qqnorm(unclass(data.ses.fore$residuals))
qqline(unclass(data.ses.fore$residuals))
```

Normality                            |
:----------------------------------------------------:|
![](img/2_3_a_2.png "Forecast") |

Finally, remember we look for random residuals, we verify if indeed there is randomness in their ACF and PACF.

```
tsdisplay(data.ses.fore$residuals)
```

Autocorrelations                            |
:----------------------------------------------------:|
![](img/2_3_a_3.png "Forecast") |

It can be observed that there is significance in some of the autocorrelations, then we perform a formal test:

```
Box.test(data.ses.fore$residuals, lag = 12, type = "Ljung-Box")

    Box-Ljung test

data:  data.ses.fore$residuals
X-squared = 63.975, df = 12, p-value = 4.215e-09

```

Clearly, this rejects independence due to the p-value < 0.05 and can be observed from the plots that seasonality is present. This is expected since even after the correction, we still observe some residuals of seasonality.

This model is not really accurate and maybe a HoltWinters with seasonality enabled must be tried, even if theoretically we removed it.

## b) Use the `ets` function to get an automatically selected Exponential Smoothing Model. Verify the model obtained and compare results with those from the previous part of the exercise.

**Analysis**

Since we have corrected the seasonality, we may like trying to fit a Holt model, i.e. only `gamma` parameter set to false (no seasonality). This model contain a equation for trend.

### Fit the model by estimating its parameters and give an interpretation for the parametervalues obtained. 

```
data.ses <- ets(data.ts)

ETS(A,A,A) 

Call:
 ets(y = data.ts) 

  Smoothing parameters:
    alpha = 0.8692 
    beta  = 0.0082 
    gamma = 0.0561 

  Initial states:
    l = 58418.2312 
    b = 56.3773 
    s=-138.6809 322.8137 642.3314 329.7243 1262.642 1586.804
           1084.2 26.0848 -573.7779 -1092.229 -1593.28 -1856.632

  sigma:  383.9738

     AIC     AICc      BIC 
11692.43 11693.42 11768.17 
```

Exponential Smoothing fitted                            |
:----------------------------------------------------:|
![](img/2_3_b_0.png "Corrected") |


**Analysis**

The parameters in this case are telling that the importance in the level for the recen past is somehow low. The beta value tells me that the recent trend is taking more importance in the forecasting, but still not really dominant. 

With respect to the coefficients, My last level is negative since, as we can see in the plot, my predication at the last point in time is going down. The trend coefficient is, on the other hand, positive, moving the value a bit to the top with respect with old predictions. This model seems more accurate, but is still showing errors that can be confirmed next.

### Verify the model on the basis of the residuals, their (partial) autocorrelations and Goodness-of-Fit measures such as RMSE, MAE and MAPE. 

We start with the metrics evaluation:

```
with(data.ses, accuracy(fitted, x))

               ME     RMSE      MAE        MPE      MAPE       ACF1 Theil's U
Test set 18.89562 379.1131 299.7397 0.02145974 0.3703408 0.07168324 0.4942543
```

In contrast to the previous model, the error seems higher since the model is not completely aligning the series though it behaves more "random".

This is not a clear indicator of the performance of the model. So we proceed to forecast and evaluate normality of the residuals and partial autocorrelations.

To verify normality of the residuals, we first forecast 10 values:

```
data.ses.fore <- forecast(data.ses, h = 10)
```

Forecast                            |
:----------------------------------------------------:|
![](img/2_3_b_1.png "Forecast") |


After that, we evaluate normality:

```
> shapiro.test(data.ses.fore$residuals)

    Shapiro-Wilk normality test

data:  data.ses.fore$residuals
W = 0.99707, p-value = 0.3118
```

We reject normality since p-value < 0.05 (we assume significance of 5%). We need to be careful since this test is sensitive to ties which was not verified for our dataset. By looking at the residuals we can observe this in detail.

```
qqnorm(unclass(data.ses.fore$residuals))
qqline(unclass(data.ses.fore$residuals))
```

Normality                            |
:----------------------------------------------------:|
![](img/2_3_b_2.png "Forecast") |

Finally, remember we look for random residuals, we verify if indeed there is randomness in their ACF and PACF.

```
tsdisplay(data.ses.fore$residuals)
```

Autocorrelations                            |
:----------------------------------------------------:|
![](img/2_3_b_3.png "Forecast") |

It can be observed that there is significance in some of the autocorrelations, then we perform a formal test:

```
Box.test(data.ses.fore$residuals, lag = 12, type = "Ljung-Box")

    Box-Ljung test

data:  data.ses.fore$residuals
X-squared = 87.776, df = 12, p-value = 1.328e-13
```

Clearly, this rejects independence due to the p-value < 0.05 and can be observed from the plots that seasonality is present. This is expected since even after the correction, we still observe some residuals of seasonality.

This model is not really accurate and maybe a HoltWinters with seasonality enabled must be tried, even if theoretically we removed it.

## Use the Exponential Smoothing Model fitted to forecast the next 12 values of the time series. Also calculate the 95% confidence intervals of the forecasts.

```
data.ses.fore <- forecast(data.ses, h = 12

         Point Forecast    Lo 80    Hi 80    Lo 95    Hi 95
Jan 2001       134353.3 133861.2 134845.3 133600.7 135105.8
Feb 2001       134749.4 134094.7 135404.0 133748.2 135750.5
Mar 2001       135383.8 134597.4 136170.2 134181.1 136586.5
Apr 2001       135965.5 135064.4 136866.5 134587.5 137343.5
May 2001       136715.7 135711.3 137720.1 135179.6 138251.8
Jun 2001       138034.0 136934.3 139133.7 136352.1 139715.8
Jul 2001       138750.8 137561.9 139939.7 136932.5 140569.1
Aug 2001       138365.3 137092.0 139638.6 136417.9 140312.7
Sep 2001       137493.0 136139.2 138846.8 135422.5 139563.5
Oct 2001       138171.8 136740.7 139602.9 135983.2 140360.5
Nov 2001       138120.5 136614.8 139626.1 135817.8 140423.2
Dec 2001       137899.9 136322.0 139477.8 135486.8 140313.1

# CI is y_pred +- 1.9600 * sigma
```
