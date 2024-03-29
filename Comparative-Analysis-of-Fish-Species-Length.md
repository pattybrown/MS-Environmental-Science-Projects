Comparative Analysis of Fish Length by Species
================

Is there a significant difference in average fish length by species
between pike, whitefish and smelt at this sampling location?

``` r
require(ggplot2)
```

    ## Loading required package: ggplot2

``` r
require(gridExtra)
```

    ## Loading required package: gridExtra

Import data:

``` r
Fish <- structure(list(Species = c("Whitefish", "Whitefish", "Whitefish", 
                           "Whitefish", "Whitefish", "Whitefish", "Pike", "Pike", "Pike", 
                           "Pike", "Pike", "Pike", "Pike", "Pike", "Pike", "Pike", "Pike", 
                           "Pike", "Pike", "Pike", "Pike", "Pike", "Pike", "Smelt", "Smelt", 
                           "Smelt", "Smelt", "Smelt", "Smelt", "Smelt", "Smelt", "Smelt", 
                           "Smelt", "Smelt", "Smelt", "Smelt", "Smelt"), Weight = c(270, 
                                                                                    270, 306, 540, 800, 1000, 200, 300, 300, 300, 430, 345, 456, 
                                                                                    510, 540, 500, 567, 770, 950, 1250, 1600, 1550, 1650, 6.7, 7.5, 
                                                                                    7, 9.7, 9.8, 8.7, 10, 9.9, 9.8, 12.2, 13.4, 12.2, 19.7, 19.9), 
               Length = c(26, 26.5, 28, 31, 36.4, 40, 32.3, 34, 35, 37.3, 
                          38, 38.5, 42.5, 42.5, 43, 45, 46, 48, 51.7, 56, 60, 60, 63.4, 
                          9.8, 10.5, 10.6, 11, 11.2, 11.3, 11.8, 11.8, 12, 12.2, 12.4, 
                          13, 14.3, 15), Height = c(8.3804, 8.1454, 8.778, 10.744, 
                                                    11.7612, 12.354, 5.568, 5.7078, 5.9364, 6.2884, 7.29, 6.396, 
                                                    7.28, 6.825, 7.786, 6.96, 7.792, 7.68, 8.9262, 10.6863, 9.6, 
                                                    9.6, 10.812, 1.7388, 1.972, 1.7284, 2.196, 2.0832, 1.9782, 
                                                    2.2139, 2.2139, 2.2044, 2.0904, 2.43, 2.277, 2.8728, 2.9322
                          ), Width = c(4.2476, 4.2485, 4.6816, 6.562, 6.5736, 6.525, 
                                       3.3756, 4.158, 4.3844, 4.0198, 4.5765, 3.977, 4.3225, 4.459, 
                                       5.1296, 4.896, 4.87, 5.376, 6.1712, 6.9849, 6.144, 6.144, 
                                       7.48, 1.0476, 1.16, 1.1484, 1.38, 1.2772, 1.2852, 1.2838, 
                                       1.1659, 1.1484, 1.3936, 1.269, 1.2558, 2.0672, 1.8792)), class = "data.frame", row.names = c(NA, 
                                                                                                                                    -37L))
```

Format species as factor:

``` r
Fish$Species <- factor(Fish$Species)
```

View distributions plot:

``` r
ggplot(Fish, aes(x = Length, color = Species)) +
  geom_density(size = 1) +
  labs(x = "Length", y = "Density") +
  theme(text = element_text(size = 20))
```

    ## Warning: Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
    ## ℹ Please use `linewidth` instead.
    ## This warning is displayed once every 8 hours.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    ## generated.

![](https://github.com/pattybrown/MS-Environmental-Science-Projects/blob/main/Figures/unnamed-chunk-3-1.png)<!-- -->

View boxplot:

``` r
ggplot(Fish, aes(x = Species, y =  Length, color = Species)) +
  geom_boxplot(size = 1) +
  labs(y = "Length", x = "Species") +
  theme(text = element_text(size = 20))
```

![](https://github.com/pattybrown/MS-Environmental-Science-Projects/blob/main/Figures/unnamed-chunk-5-1.png)<!-- -->

Run ANOVA:

``` r
model <- aov(Length ~ Species, data = Fish)
summary(model)
```

    ##             Df Sum Sq Mean Sq F value  Pr(>F)    
    ## Species      2   8652    4326   86.51 4.6e-14 ***
    ## Residuals   34   1700      50                    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
TukeyHSD(model)
```

    ##   Tukey multiple comparisons of means
    ##     95% family-wise confidence level
    ## 
    ## Fit: aov(formula = Length ~ Species, data = Fish)
    ## 
    ## $Species
    ##                      diff       lwr        upr     p adj
    ## Smelt-Pike      -33.56092 -39.81493 -27.306915 0.0000000
    ## Whitefish-Pike  -14.16569 -22.39436  -5.937009 0.0004946
    ## Whitefish-Smelt  19.39524  10.93969  27.850782 0.0000079

With a p-value of 4.6e-14, ANOVA results indicate a statistically
significant difference in fish length based on species. The posthoc
analysis returned adjusted p-values of \<0.05 for each pairwise
comparison, indicating statistically significant differences between all
three species in the group.
