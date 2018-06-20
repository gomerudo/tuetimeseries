# Exercise 2.1: Univariate Time Series - Exponential Smoothing Models

**Data set needed: GoldenGate.RData**

In this exercise we study data from the traffic volume at the Golden gate bridge, as contained in the data set `GoldenGate.RData`. Check that this time series contains both trend and an additive seasonal pattern.

```
# Make the time sequence plot

tsdisplay(data.ts)
```

Initial time sequence plot                            |
:----------------------------------------------------:|
![](img/2_1.png "Initial time sequence plot") |

## a) For the time series selected generate time series which are corrected for trend, for seasonality and for both trend and seasonality. Perform an Exploratory Data Analysis (including fingerprinting!) for the results!

### Correction for trend

```
# Perform correction

data.corrected = diff(data.ts, differences = 2)
tsdisplay(data.corrected)
```

Corrected series                            |
:----------------------------------------------------:|
![](img/2_1_a_1.png "Corrected") |

**Analysis**

I have corrected trend 2 times, since 1-time differencing was still keeping son trendy behaviour close to the seasonality. Actually, when removing 1-time differencing is still not clear in the PACF whether seasonality is present or not. This is solved with 2-times differencing.

### Correction for seasonality

```
# Perform correction

data.corrected <- diff(data.ts, lag = 12, differences = 1)
tsdisplay(data.corrected)
```

Corrected series                            |
:----------------------------------------------------:|
![](img/2_1_a_2.png "Corrected") |

**Analysis**

For seasonality, only one correction was performed, since no clear change was noticed with a higher order. This seasonality is at lags 12-13 and 24-25, as can be appreciated in the PACF. 

### Correction for both trend and seasonality

```
# Perform correction

data.corrected = diff(data.ts, differences = 2)
data.corrected <- diff(data.corrected, lag = 12, differences = 1)
tsdisplay(data.corrected)
```

Corrected series                            |
:----------------------------------------------------:|
![](img/2_1_a_3.png "Corrected") |

**Analysis**

The original series contain both trend and seasonality, presumably additive. After correcting for both characteristics we observe a series closer to stationary both still showing some marks of seasonality. 

## b) 

### For the generated time series, corrected both for trend and seasonality select an adequate Exponential Smoothing Model to predict future values. 

**Analysis**

Since we have corrected the trend and the seasonality, we may like trying to fit a Simple Exponential Smoothing model, which does not contain equations for trend nor seasonality but only for the level.

### Fit the model by estimating its parameters and give an interpretation for the parameter values obtained. 

```
data.ses <- HoltWinters(data.corrected, beta = FALSE, gamma = FALSE) # Output is next

Holt-Winters exponential smoothing without trend and without seasonal component.

Call:
HoltWinters(x = data.corrected, beta = FALSE, gamma = FALSE)

Smoothing parameters:
 alpha: 6.610696e-05
 beta : FALSE
 gamma: FALSE

Coefficients:
       [,1]
a 0.3524644
```

Exponential Smoothing fitted                            |
:----------------------------------------------------:|
![](img/2_1_b_0.png "Corrected") |


**Analysis**

The `alpha` parameter indicates that we are not giving too much importance to the recent past, but giving a similar importance to all the series (since at each step we only decrease the value by less than 1%). The coefficient on the other hand is bigger but still not that significant if we consider that the range of y-axis is `[-20, 20]`. I would expect a really bad prediction, close to 0.


### Verify the model on the basis of the residuals, their (partial) autocorrelations and Goodness-of-Fit measures such as RMSE, MAE and MAPE.

**Analysis**

The first thing to evaluate is the goodness-of-fit, since it does not deppend on predictions. I decide to evaluate based on RMSE since it is unsensitive to changes in sign for the fitted and original values. 


```
with(data.ses, accuracy(fitted, x))

                 ME     RMSE      MAE      MPE     MAPE       ACF1 Theil's U
Test set -0.3495645 4.722208 3.067691 104.4842 108.4282 -0.5792749  1.065748
```

With this, we observe that the RMSE is somehow low, since we are working in the range `[-20, 20]` and this measure is averaged and squared. Indeed, this means that our average error is more or less one side of the range. 

This is not a clear indicator of the performance of the model. So we proceed to forecast and evaluate normality of the residuals and partial autocorrelations.

To verify normality of the residuals, we first forecast 10 values:

```
data.ses.fore <- forecast(data.ses, h = 10)
```

Forecast                            |
:----------------------------------------------------:|
![](img/2_1_b_1.png "Forecast") |


After that, we evaluate normality:

```
> shapiro.test(data.ses.fore$residuals)

    Shapiro-Wilk normality test

data:  data.ses.fore$residuals
W = 0.89087, p-value = 3.197e-09
```

We reject normality since p-value < 0.05 (we assume significance of 5%). We need to be careful since this test is sensitive to ties which was not verified for our dataset. By looking at the residuals we can observe this in detail.

```
qqnorm(unclass(data.ses.fore$residuals))
qqline(unclass(data.ses.fore$residuals))
```

Normality                            |
:----------------------------------------------------:|
![](img/2_1_b_2.png "Forecast") |

Finally, remember we look for random residuals, we verify if indeed there is randomness in their ACF and PACF.

```
tsdisplay(data.ses.fore$residuals)
```

Autocorrelations                            |
:----------------------------------------------------:|
![](img/2_1_b_3.png "Forecast") |

It can be observed that there is significance in some of the autocorrelations, then we perform a formal test:

```
Box.test(data.ses.fore$residuals, lag = 12, type = "Ljung-Box")

    Box-Ljung test

data:  data.ses.fore$residuals
X-squared = 115.88, df = 12, p-value < 2.2e-16

```

The p-value is lower than 0.5, rejecting the null that autocorrelations are 0. Hence, they are significant and this is not an adequate model.

## c) 

### For the generated time series, corrected only for seasonality select an adequate Exponential Smoothing Model to predict future values. 

**Analysis**

Since we have corrected the seasonality, we may like trying to fit a Holt model, i.e. only `gamma` parameter set to false (no seasonality). This model contain a equation for trend.

### Fit the model by estimating its parameters and give an interpretation for the parametervalues obtained. 

```
data.ses <- HoltWinters(data.corrected, gamma = FALSE)

Holt-Winters exponential smoothing without trend and without seasonal component.

Call:
HoltWinters(x = data.corrected2, gamma = FALSE)

Smoothing parameters:
 alpha: 0.7035657
 beta : 0.02155898
 gamma: FALSE

Coefficients:
         [,1]
a -1.00692932
b -0.01875195
```

Exponential Smoothing fitted                            |
:----------------------------------------------------:|
![](img/2_1_c_0.png "Corrected") |


**Analysis**

The parameters in this case are telling that the importance in the level for the recen past is somehow low. The beta value tells me that the recent trend is taking more importance in the forecasting, but still not really dominant. 

With respect to the coefficients, My last level is negative since, as we can see in the plot, my predication at the last point in time is going down. The trend coefficient is, on the other hand, positive, moving the value a bit to the top with respect with old predictions. This model seems more accurate, but is still showing errors that can be confirmed next.

### Verify the model on the basis of the residuals, their (partial) autocorrelations and Goodness-of-Fit measures such as RMSE, MAE and MAPE. 

We start with the metrics evaluation:

```
with(data.ses, accuracy(fitted, x))

                 ME     RMSE      MAE       MPE     MAPE       ACF1 Theil's U
Test set -0.3051299 2.900247 1.936155 -52.58149 152.4652 0.01168202  1.039962
```

In contrast to the previous model, the error seems higher since the model is not completely aligning the series though it behaves more "random".

This is not a clear indicator of the performance of the model. So we proceed to forecast and evaluate normality of the residuals and partial autocorrelations.

To verify normality of the residuals, we first forecast 10 values:

```
data.ses.fore <- forecast(data.ses, h = 10)
```

Forecast                            |
:----------------------------------------------------:|
![](img/2_1_c_1.png "Forecast") |


After that, we evaluate normality:

```
> shapiro.test(data.ses.fore$residuals)

    Shapiro-Wilk normality test

data:  data.ses.fore$residuals
W = 0.88348, p-value = 1.19e-09
```

We reject normality since p-value < 0.05 (we assume significance of 5%). We need to be careful since this test is sensitive to ties which was not verified for our dataset. By looking at the residuals we can observe this in detail.

```
qqnorm(unclass(data.ses.fore$residuals))
qqline(unclass(data.ses.fore$residuals))
```

Normality                            |
:----------------------------------------------------:|
![](img/2_1_c_2.png "Forecast") |

Finally, remember we look for random residuals, we verify if indeed there is randomness in their ACF and PACF.

```
tsdisplay(data.ses.fore$residuals)
```

Autocorrelations                            |
:----------------------------------------------------:|
![](img/2_1_c_3.png "Forecast") |

It can be observed that there is significance in some of the autocorrelations, then we perform a formal test:

```
Box.test(data.ses.fore$residuals, lag = 12, type = "Ljung-Box")

    Box-Ljung test

data:  data.ses.fore$residuals
X-squared = 45.042, df = 12, p-value = 1.013e-05

```

Clearly, this rejects independence due to the p-value < 0.05 and can be observed from the plots that seasonality is present. This is expected since even after the correction, we still observe some residuals of seasonality.

This model is not really accurate and maybe a HoltWinters with seasonality enabled must be tried, even if theoretically we removed it.

## d) 

### For the generated time series, corrected only for trend select an adequate Exponential Smoothing Model to predict future values. 

**Analysis**

Since we removed trend, we still have seasonality. we would like to model the series with a HoltWinters model with parameter `beta = false`, meaning no trend. 

### Fit the model by estimating its parameters and give an interpretation for the parametervalues obtained. 

```
data.ses <- HoltWinters(data.corrected, beta = FALSE)

Holt-Winters exponential smoothing without trend and without seasonal component.

Call:
HoltWinters(x = data.corrected1, beta = FALSE)

Smoothing parameters:
 alpha: 0
 beta : FALSE
 gamma: 0.1128161

Coefficients:
           [,1]
a    0.01279419
s1  -0.81197879
s2   6.10930402
s3   0.34708510
s4  -1.33313858
s5  -1.41342768
s6   4.61021878
s7  -3.33626260
s8   0.72900749
s9  -8.61260092
s10  1.39475602
s11  1.51356666
s12  0.98666669
```

Exponential Smoothing fitted                            |
:----------------------------------------------------:|
![](img/2_1_d_0.png "Corrected") |

**Analysis**

This time we obtained an alpha parameter of 0, meaning we give equal weight to each level, regardless the time. On the other hand, the gamma parameter seems to be low meaning that the seasonality will be close to a simple average since all the lags will be similarly important.

### Verify the model on the basis of the residuals, their (partial) autocorrelations and Goodness-of-Fit measures such as RMSE, MAE and MAPE. 


```
with(data.ses, accuracy(fitted, x))

                 ME    RMSE      MAE      MPE     MAPE       ACF1 Theil's U
Test set 0.01054447 3.43316 2.120443 241.7872 311.8757 -0.5295721 0.7939439
```

The RMSE behaves similarly to the previous example.Indeed, the fitted values look pretty close to the last model. 

This is not a clear indicator of the performance of the model. So we proceed to forecast and evaluate normality of the residuals and partial autocorrelations.

To verify normality of the residuals, we first forecast 10 values:

```
data.ses.fore <- forecast(data.ses, h = 10)
```

Forecast                            |
:----------------------------------------------------:|
![](img/2_1_d_1.png "Forecast") |


After that, we evaluate normality:

```
> shapiro.test(data.ses.fore$residuals)

    Shapiro-Wilk normality test

data:  data.ses.fore$residuals
W = 0.81821, p-value = 1.484e-12
```

We reject normality since p-value < 0.05 (we assume significance of 5%). We need to be careful since this test is sensitive to ties which was not verified for our dataset. By looking at the residuals we can observe this in detail.

```
qqnorm(unclass(data.ses.fore$residuals))
qqline(unclass(data.ses.fore$residuals))
```

Normality                            |
:----------------------------------------------------:|
![](img/2_1_d_2.png "Forecast") |

Finally, remember we look for random residuals, we verify if indeed there is randomness in their ACF and PACF.

```
tsdisplay(data.ses.fore$residuals)
```

Autocorrelations                            |
:----------------------------------------------------:|
![](img/2_1_d_3.png "Forecast") |

It can be observed that there is significance in some of the autocorrelations, then we perform a formal test:

```
Box.test(data.ses.fore$residuals, lag = 12, type = "Ljung-Box")

    Box-Ljung test

data:  data.ses.fore$residuals
X-squared = 49.374, df = 12, p-value = 1.799e-06
```

The independence of the residuals is rejected. This is clear in the ACF and PACF where we can still observe some seasonality and residuals of trendy behaviour.

## e) 

### For the original time series, not corrected for trend and seasonality, select an adequate Exponential Smoothing Model to predict future values. 

**Analysis**

Now we want to use a model considering both, trend and seasonality, this is, a full HoltWinters model.

Now we fit a model with all the 
### Fit the model by estimating its parameters and give an interpretation for the parametervalues obtained. 

```
data.ses <- HoltWinters(data.corrected, beta = FALSE, gamma = FALSE)

Holt-Winters exponential smoothing without trend and without seasonal component.

Call:
HoltWinters(x = data.corrected)

Smoothing parameters:
 alpha: 0.6699554
 beta : 0
 gamma: 0.4046366

Coefficients:
           [,1]
a    99.8660930
b     0.2248157
s1  -10.1958671
s2   -7.4019912
s3   -4.0145763
s4   -1.2108923
s5   -0.3771842
s6    5.3704471
s7    7.6934609
s8   10.8084160
s9    4.9529045
s10   0.1485313
s11  -3.6956813
s12  -5.9473162
```

Exponential Smoothing fitted                            |
:----------------------------------------------------:|
![](img/2_1_e_0.png "Corrected") |

**Analysis**

The level is not getting higher importance (above 50%), meaning that recent past is more important. The trend is not getting importance at all and can be deprecated. The seasonality seems to play an important role (relatively speaking). It seems that seasonality and level are the key elements of the series since the trend grows really slow.

### Verify the model on the basis of the residuals, their (partial) autocorrelations and Goodness-of-Fit measures such as RMSE, MAE and MAPE. 


```
with(data.ses, accuracy(fitted, x))

                 ME     RMSE      MAE        MPE     MAPE       ACF1 Theil's U
Test set -0.1857464 2.220312 1.452351 -0.2171376 1.581329 0.09497596 0.5871218
```

This time we obtain a lower error in general. We can observe this in the plot of the fitted values.

This is not a clear indicator of the performance of the model. So we proceed to forecast and evaluate normality of the residuals and partial autocorrelations.

To verify normality of the residuals, we first forecast 10 values:

```
data.ses.fore <- forecast(data.ses, h = 10)
```

Forecast                            |
:----------------------------------------------------:|
![](img/2_1_e_1.png "Forecast") |


After that, we evaluate normality:

```
> shapiro.test(data.ses.fore$residuals)

    Shapiro-Wilk normality test

data:  data.ses.fore$residuals
W = 0.83673, p-value = 6.667e-12
```

We formally reject normality, but the values at the center of the line seems close to normal. Outliers can be affecting the normality but this forecasting needs to be treated carefully.

```
qqnorm(unclass(data.ses.fore$residuals))
qqline(unclass(data.ses.fore$residuals))
```

Normality                            |
:----------------------------------------------------:|
![](img/2_1_e_2.png "Forecast") |

Finally, remember we look for random residuals, we verify if indeed there is randomness in their ACF and PACF.

```
tsdisplay(data.ses.fore$residuals)
```

Autocorrelations                            |
:----------------------------------------------------:|
![](img/2_1_e_3.png "Forecast") |

We do not observe any significant correlation, but we perform a formal test:

```
Box.test(data.ses.fore$residuals, lag = 12, type = "Ljung-Box")

    Box-Ljung test

data:  data.ses.fore$residuals
X-squared = 10.39, df = 12, p-value = 0.5818
```

We can not reject independence and the p-value is high. We can consider this model reliable since the residuals can be considered random.

## Conclusions

For this series, considering all the factors work much better, since the series was very dependant on the seasonality. We can still try a model, removing trend and applying only seasonal exponential smoothing.
