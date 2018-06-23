# Exercise 5.3

The dataset `catalog.RData` contains information about the monthly sales for three products sold by a catalog company. Furthermore, it contains data for five possible predictors variables. In this exercise we will have a closer look at the data available for:

- Monthly Sales of Men's Clothing
- Montly Sales of Women's Clothing
- Number of Customer Service Representatives

to find out if they are related to each other!

## a. Perform an Exploratory Data Analysis on each of the individual time series indicated. Characterize the main properties of the time series, such as trend, seasonal variation, cyclic variation, irregular variations and sudden changes in the data. Also obtain "fingerprints" in the time domain and the frequency domain and comment on the results. Comment on transformations needed to transform the series to stationary series!

Men's clothing                | Women's clothing | Number of CSR |
|:---------------------------:|:---------------------------:|:----------------:
|![](img/5_3_a_1_1.png "ARMA3") |![](img/5_3_a_2_1.png "ARMA3") |![](img/5_3_a_3_1.png "ARMA3") |
|![](img/5_3_a_1_2.png "ARMA3") |![](img/5_3_a_2_2.png "ARMA3") |![](img/5_3_a_3_2.png "ARMA3") |

1. For men's
    - Remove trend and seasonality
2. For women's
    - No clear trend, remove seasonality
3. For CSR
    - Remove trend... Some seasonality may exist

## b. Obtain a 'fingerprint' of the relation between the (original) time series in the time domain by calculating the sample cross-correlations. Comment on the results!

Men-Women                      | Men-Service                  | Women-Service                |
|:----------------------------:|:----------------------------:|:----------------------------:|
|![](img/5_3_b_MW.png "ARMA3") |![](img/5_3_b_MS.png "ARMA3") |![](img/5_3_b_WS.png "ARMA3") |


## c. Perform adequate "pre-whitening" of the time series considered by correcting for obvious trend and seasonality. Obtain the time-domain "fingerprints" for the relation between these transformed series and comment on the results, especially whether it looks as if one is leading or lagging with respect to the other!

Men's clothing                | Women's clothing            | Number of CSR               |
|:---------------------------:|:---------------------------:|:---------------------------:|
|![](img/5_3_c_1.png "ARMA3") |![](img/5_3_c_2.png "ARMA3") |![](img/5_3_c_3.png "ARMA3") |

Men-Women                      | Men-Service                  | Women-Service                |
|:----------------------------:|:----------------------------:|:----------------------------:|
|![](img/5_3_c_MW.png "ARMA3") |![](img/5_3_c_MS.png "ARMA3") |![](img/5_3_c_WS.png "ARMA3") |
