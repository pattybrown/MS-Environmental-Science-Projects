Spatial Linear Modeling
================

``` r
require(ggplot2)
require(dplyr)
require(nlme)
```

Import data, extract moms, add spatial coordinates, and remove replicate
flowers sampled from the same mother.

``` r
Moms <- read.csv(system.file("extdata","pulsatilla_momVariables.csv", package = "LandGenCourse"))
Pulsatilla <- read.csv(system.file("extdata","pulsatilla_genotypes.csv", package = "LandGenCourse"))
Adults <- Pulsatilla %>% filter(OffID == 0)
```

Combine dataframes

``` r
Moms <- left_join(Moms, Adults[,1:5])
```

Remove replicate flowers sampled from the same mother

``` r
Moms <- Moms %>% filter(OffID == 0)
```

Create scatterplot of flower.density against mom.isolation

``` r
ggplot(Moms, aes(log(mom.isolation), log(flower.density))) + geom_point() + geom_smooth()
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](Week-7-R-Notebook_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

Fit non-spatial models using nlme and add a random effect for Population

``` r
mod1 <- nlme::gls(log(flower.density) ~ log(mom.isolation), data=Moms)

mod2 <- lme(log(flower.density) ~ log(mom.isolation), random = ~ 1| Population, data=Moms)
```

Plot residual variograms for the two models.

``` r
vgmod1 <- nlme::Variogram(mod1, form = ~X  + Y, resType = "normalized")
vgmod1plot <- ggplot(vgmod1, aes(x=dist, y=variog)) + geom_point() + geom_smooth(se=FALSE) + geom_hline(yintercept=1) + ylim(c(0,1.3)) + xlab("Distance") + ylab("Semivariance")
```

``` r
vgmod2 <- nlme::Variogram(mod2, form = ~X  + Y, resType = "normalized")
vgmod2plot <- ggplot(vgmod2, aes(x=dist, y=variog)) + geom_point() + geom_smooth(se=FALSE) + geom_hline(yintercept=1) + ylim(c(0,1.3)) + xlab("Distance") + ylab("Semivariance")
```

``` r
gridExtra::grid.arrange(vgmod1plot, vgmod2plot)
```

![](Week-7-R-Notebook_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

Add correlation structure and choose the best-fitting variogram model

``` r
mod.corExp <- update(mod2, correlation = nlme::corExp(form = ~ X + Y, nugget=T))
mod.corGaus <- update(mod2, correlation = nlme::corGaus(form = ~ X + Y, nugget=T))
mod.corSpher <- update(mod2, correlation = nlme::corSpher(form = ~ X + Y, nugget=T))
mod.corRatio <- update(mod2, correlation = nlme::corRatio(form = ~ X + Y, nugget=T))
```

``` r
MuMIn::model.sel(mod2, mod.corExp, mod.corGaus, mod.corSpher, mod.corRatio)  
```

    ## Model selection table 
    ##              (Int) log(mom.isl)  correlation df  logLik  AICc delta weight
    ## mod.corGaus  4.696       -1.423 n::cG(X+Y,T)  6 -41.575  97.5  0.00  0.589
    ## mod.corRatio 4.725       -1.441 n::cR(X+Y,T)  6 -42.116  98.6  1.08  0.343
    ## mod.corSpher 4.766       -1.461 n::cS(X+Y,T)  6 -44.224 102.8  5.30  0.042
    ## mod.corExp   4.882       -1.504 n::cE(X+Y,T)  6 -44.715 103.8  6.28  0.025
    ## mod2         4.887       -1.479               4 -50.768 110.6 13.11  0.001
    ## Abbreviations:
    ##  correlation: n::cE(X+Y,T) = 'nlme::corExp(~X+Y,T)', 
    ##               n::cG(X+Y,T) = 'nlme::corGaus(~X+Y,T)', 
    ##               n::cR(X+Y,T) = 'nlme::corRatio(~X+Y,T)', 
    ##               n::cS(X+Y,T) = 'nlme::corSpher(~X+Y,T)'
    ## Models ranked by AICc(x) 
    ## Random terms (all models): 
    ##   1 | Population

Best Model: mod.corGaus

Check residual plots for the best model and check the residuals. Plot a
variogram of the residuals, and the fitted variogram.

``` r
predictmeans::residplot(mod.corGaus)
```

    ## Warning in checkDepPackageVersion(dep_pkg = "TMB"): Package version inconsistency detected.
    ## glmmTMB was built with TMB version 1.9.6
    ## Current TMB version is 1.9.10
    ## Please re-install glmmTMB from source or restore original 'TMB' package (see '?reinstalling' for more information)

``` r
semivario <- nlme::Variogram(mod.corGaus, form = ~ X + Y, resType = "normalized")
plot(semivario, smooth = TRUE)
```

``` r
Fitted.variog <- nlme::Variogram(mod.corGaus)
plot(Fitted.variog)
```

![](Week-7-R-Notebook_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

Test fixed effect: Refit the best model with maximum likelihood to test
the fixed effect

``` r
anova.corGaus <- car::Anova(mod.corGaus)
```

Determine the marginal R-squared for the best model

``` r
MuMIn::r.squaredGLMM(mod.corGaus)
```

    ## Warning: 'r.squaredGLMM' now calculates a revised statistic. See the help page.

    ##            R2m       R2c
    ## [1,] 0.4489446 0.7056391
