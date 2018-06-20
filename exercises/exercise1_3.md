# Exercise 1.3: ARMA-models - Fingerprinting

Data set needed: `ARMAsimulations.RData`

Within the framework of Box-Jenkins models we will learn that Auto Regressive Moving Average models play an essential role. An ARMA(p,q)-model is defined according to:

![](img/arma_formula.png "ARMA model")

where the actual value `X_t` is dependent on the actual values for the time series from the past, `X_{t-I}`, and on the actual and past values of the stochastic (or noise-related) influences, `Z_{t-j}`. We will learn how the `ARMA(p,q)` has a characteristic fingerprint in the time domain, that can be calculated from the theoretical model. However, a single realization of the specific ARMA-model, as contained in the data set `ARMAsimulations.RData`, might be used to identify the generating ARMA(p,q)-model, based on their specific characteristics.

## a) Make time sequence plots for the individual ARMA(p,q)-realizations and perform an Exploratory Data Analysis: Try to characterize the main properties of the time series, such as trend, seasonal variation, cyclic variation, irregular variations, sudden changes in the data and/or possible outliers.

Time series                       | Analysis
:--------------------------------:|---------------------------------------------
![](img/1_3_ts_ARMA1.png "ARMA1") | **ARMA1** <br> **Trend**: No. <br> **Seasonality**: Not clear. <br>**Cyclic variation**: Maybe. <br> **Outliers**: Apparently not. 
![](img/1_3_ts_ARMA2.png "ARMA2") | **ARMA2** <br> **Trend**: No. <br> **Seasonality**: No. <br>**Cyclic variation**: Maybe. <br> **Outliers**: Maybe, around 200. 
![](img/1_3_ts_ARMA3.png "ARMA3") | **ARMA3** <br> **Trend**: No. <br> **Seasonality**: No. <br>**Cyclic variation**: Maybe. <br> **Outliers**: Maybe. 
![](img/1_3_ts_ARMA4.png "ARMA4") | **ARMA4** <br> **Trend**: No. <br> **Seasonality**: No. <br>**Cyclic variation**: Apparently not. <br> **Outliers**: Apparently not. 
![](img/1_3_ts_ARMA5.png "ARMA5") | **ARMA5** <br> **Trend**: No. <br> **Seasonality**: No. <br>**Cyclic variation**: Apparently not. <br> **Outliers**: Apparently not. 
![](img/1_3_ts_ARMA6.png "ARMA6") | **ARMA6** <br> **Trend**: No. <br> **Seasonality**: No. <br>**Cyclic variation**: Apparently not. <br> **Outliers**: Apparently not. 
![](img/1_3_ts_ARMA7.png "ARMA7") | **ARMA7** <br> **Trend**: No. <br> **Seasonality**: No. <br>**Cyclic variation**: Apparently not. <br> **Outliers**: Apparently not. 
![](img/1_3_ts_ARMA8.png "ARMA8") | **ARMA8** <br> <br> **Trend**: No. <br> **Seasonality**: No at first glance. <br>**Cyclic variation**: Apparently not. <br> **Outliers**: Maybe, around 350. 
![](img/1_3_ts_ARMA9.png "ARMA9") | **ARMA9** <br> **Trend**: Yes, but decreasing. <br> **Seasonality**: Maybe, but no strong statement can be made. <br>**Cyclic variation**: Maybe. <br> **Outliers**: Apparently not. 
![](img/1_3_ts_ARMA10.png "ARMA10") | **ARMA10** <br> **Trend**: No. <br> **Seasonality**: Not. <br>**Cyclic variation**: Maybe. <br> **Outliers**: A sudden change detected close to 400. 
![](img/1_3_ts_ARMA11.png "ARMA11") | **ARMA11** <br> **Trend**: No. <br> **Seasonality**: No. <br>**Cyclic variation**: No. <br> **Outliers**: A low value is observed around 250. 
![](img/1_3_ts_ARMA12.png "ARMA12") | **ARMA12** <br> **Trend**: No. <br> **Seasonality**: Not. <br>**Cyclic variation**: No. <br> **Outliers**: Apparently not. 


## b) Obtain 'the fingerprint' of these ARMA(p,q)-realizations in the time domain by calculating the sample autocorrelation and partial autocorrelation function. Try to identify specific features from these fingerprints and comment on the results obtained.

Time series                       |  ACF                      | PACF
:--------------------------------:|:-------------------------:|:----------------------------------------------------:
![](img/1_3_ts_ARMA1.png "ARMA1") | ![](img/1_3_acf_ARMA1.png "ACF ARMA1") | ![](img/1_3_pacf_ARMA1.png "PACF ARMA1")
![](img/1_3_ts_ARMA2.png "ARMA2") | ![](img/1_3_acf_ARMA2.png "ACF ARMA2") | ![](img/1_3_pacf_ARMA2.png "PACF ARMA2")
![](img/1_3_ts_ARMA3.png "ARMA3") | ![](img/1_3_acf_ARMA3.png "ACF ARMA3") | ![](img/1_3_pacf_ARMA3.png "PACF ARMA3")
![](img/1_3_ts_ARMA4.png "ARMA4") | ![](img/1_3_acf_ARMA4.png "ACF ARMA4") | ![](img/1_3_pacf_ARMA4.png "PACF ARMA4")
![](img/1_3_ts_ARMA5.png "ARMA5") | ![](img/1_3_acf_ARMA5.png "ACF ARMA5") | ![](img/1_3_pacf_ARMA5.png "PACF ARMA5")
![](img/1_3_ts_ARMA6.png "ARMA6") | ![](img/1_3_acf_ARMA6.png "ACF ARMA6") | ![](img/1_3_pacf_ARMA6.png "PACF ARMA6")
![](img/1_3_ts_ARMA7.png "ARMA7") | ![](img/1_3_acf_ARMA7.png "ACF ARMA7") | ![](img/1_3_pacf_ARMA7.png "PACF ARMA7")
![](img/1_3_ts_ARMA8.png "ARMA8") | ![](img/1_3_acf_ARMA8.png "ACF ARMA8") | ![](img/1_3_pacf_ARMA8.png "PACF ARMA8")
![](img/1_3_ts_ARMA9.png "ARMA9") | ![](img/1_3_acf_ARMA9.png "ACF ARMA9") | ![](img/1_3_pacf_ARMA9.png "PACF ARMA9")
![](img/1_3_ts_ARMA10.png "ARMA10") | ![](img/1_3_acf_ARMA10.png "ACF ARMA10") | ![](img/1_3_pacf_ARMA10.png "PACF ARMA10")
![](img/1_3_ts_ARMA11.png "ARMA11") | ![](img/1_3_acf_ARMA11.png "ACF ARMA11") | ![](img/1_3_pacf_ARMA11.png "PACF ARMA11")
![](img/1_3_ts_ARMA12.png "ARMA12") | ![](img/1_3_acf_ARMA12.png "ACF ARMA12") | ![](img/1_3_pacf_ARMA12.png "PACF ARMA12")


## c) Obtain 'the fingerprint' of these ARMA(p,q)-realizations in the frequency domain by calculating the (smoothed) spectrum, using the `spectrum` program. Comment on the results and try to identify frequency components that are present in the results.

Time series                       |  Spectrum                      | Spectrum span10
:--------------------------------:|:-------------------------:|:----------------------------------------------------:
![](img/1_3_ts_ARMA1.png "ARMA1") | ![](img/1_3_spec_ARMA1.png "SPEC ARMA1") | ![](img/1_3_spec10_ARMA1.png "SPEC10 ARMA1")
![](img/1_3_ts_ARMA2.png "ARMA2") | ![](img/1_3_spec_ARMA2.png "SPEC ARMA2") | ![](img/1_3_spec10_ARMA2.png "SPEC10 ARMA2")
![](img/1_3_ts_ARMA3.png "ARMA3") | ![](img/1_3_spec_ARMA3.png "SPEC ARMA3") | ![](img/1_3_spec10_ARMA3.png "SPEC10 ARMA3")
![](img/1_3_ts_ARMA4.png "ARMA4") | ![](img/1_3_spec_ARMA4.png "SPEC ARMA4") | ![](img/1_3_spec10_ARMA4.png "SPEC10 ARMA4")
![](img/1_3_ts_ARMA5.png "ARMA5") | ![](img/1_3_spec_ARMA5.png "SPEC ARMA5") | ![](img/1_3_spec10_ARMA5.png "SPEC10 ARMA5")
![](img/1_3_ts_ARMA6.png "ARMA6") | ![](img/1_3_spec_ARMA6.png "SPEC ARMA6") | ![](img/1_3_spec10_ARMA6.png "SPEC10 ARMA6")
![](img/1_3_ts_ARMA7.png "ARMA7") | ![](img/1_3_spec_ARMA7.png "SPEC ARMA7") | ![](img/1_3_spec10_ARMA7.png "SPEC10 ARMA7")
![](img/1_3_ts_ARMA8.png "ARMA8") | ![](img/1_3_spec_ARMA8.png "SPEC ARMA8") | ![](img/1_3_spec10_ARMA8.png "SPEC10 ARMA8")
![](img/1_3_ts_ARMA9.png "ARMA9") | ![](img/1_3_spec_ARMA9.png "SPEC ARMA9") | ![](img/1_3_spec10_ARMA9.png "SPEC10 ARMA9")
![](img/1_3_ts_ARMA10.png "ARMA10") | ![](img/1_3_spec_ARMA10.png "SPEC ARMA10") | ![](img/1_3_spec10_ARMA10.png "SPEC10 ARMA10")
![](img/1_3_ts_ARMA11.png "ARMA11") | ![](img/1_3_spec_ARMA11.png "SPEC ARMA11") | ![](img/1_3_spec10_ARMA11.png "SPEC10 ARMA11")
![](img/1_3_ts_ARMA12.png "ARMA12") | ![](img/1_3_spec_ARMA12.png "SPEC ARMA12") | ![](img/1_3_spec10_ARMA12.png "SPEC10 ARMA12")
