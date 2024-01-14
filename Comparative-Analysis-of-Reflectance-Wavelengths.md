Comparative Analysis of Reflectance Wavelengths
================

``` r
require(dplyr)
```

    ## Loading required package: dplyr

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
require(ggplot2)
```

    ## Loading required package: ggplot2

Import data:

``` r
a11data <- list.files("~/Desktop/ENVS 511/Week 5/Assignment 11 Data", full.names = TRUE)
a11_dim <- data.frame(a11data)
```

Use a for-loop to read in each of the reflectance files and calculate
the maximum reflectance value within the wavelength range between 400 to
500 nm and 501 to 600 nm for each of the 6 plants.

``` r
output <- c() 

for(i in 1:6){
  
  ufc <- read.delim(a11data[i])
  
  ufc$id <- i
  
  ufc1 <- ufc %>% filter(wavelength >= 400, wavelength <= 500)
  ufc2 <- ufc %>% filter(wavelength >= 501, wavelength <= 600)
  
  out1 = ufc1 %>% filter(spectrum == max(spectrum))
  out2 = ufc2 %>% filter(spectrum == max(spectrum))
  
  output <- (rbind(output, out1, out2))

}
```

Use the output from the for-loop to create a boxplot that allows to
visually compare the distribution of the maximum reflectance values
between 400 to 500 nm and 501 to 600 nm.

``` r
output$wavelength <- as.factor(output$wavelength)

ggplot(output, aes(x = wavelength, y =  spectrum, group = wavelength, color = wavelength)) +
  geom_boxplot(size = 1) +
  labs(y = "Max Reflectance", x = "Group") +
  theme(text = element_text(size = 15))
```

![](https://github.com/pattybrown/MS-Environmental-Science-Projects/blob/main/Figures/unnamed-chunk-1-1.png)<!-- -->

Conduct statistical analysis to compare the groups against each other.

``` r
group1 <- output %>% filter(wavelength == 500)
group2 <- output %>% filter(wavelength == 600)

t.test(group1$spectrum, group2$spectrum, paired = FALSE)
```

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  group1$spectrum and group2$spectrum
    ## t = -3.0665, df = 8.1861, p-value = 0.01501
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.09023008 -0.01294644
    ## sample estimates:
    ## mean of x mean of y 
    ## 0.1043912 0.1559795

With a p-value of 0.01501, t-test results indicate a statistically
significant difference between the groups.
