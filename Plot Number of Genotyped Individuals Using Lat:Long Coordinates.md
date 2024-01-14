Plot Number of Genotyped Individuals Using Lat/Long Coordinates
================

``` r
require(gstudio)
```

    ## Loading required package: gstudio

    ## Warning: replacing previous import 'dplyr::union' by 'raster::union' when
    ## loading 'gstudio'

    ## Warning: replacing previous import 'dplyr::intersect' by 'raster::intersect'
    ## when loading 'gstudio'

    ## Warning: replacing previous import 'dplyr::select' by 'raster::select' when
    ## loading 'gstudio'

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
require(tibble)
```

    ## Loading required package: tibble

``` r
require(sp)
```

    ## Loading required package: sp

Import data

``` r
PV.gstudio <- read_population(path=system.file("extdata", "pulsatilla_genotypes.csv", package = "LandGenCourse"), type="column", locus.columns=c(6:19), phased=FALSE, sep=",", header=TRUE)
```

Summarize by site and count the number of genotyped individuals per
population (i.e., sampling site)

``` r
Pulsatilla <- PV.gstudio %>% group_by(Population) %>% summarize(nIndiv = n())
```

Add mean coordinates. Modify code to calculate number of genotyped
individuals for each site and their mean X and Y coordinates.

``` r
Pulsatilla <- PV.gstudio %>% group_by(Population) %>% summarize(nIndiv = n(), MeanX = mean(X), MeanY = mean(Y))
as_tibble(Pulsatilla)
```

    ## # A tibble: 7 × 4
    ##   Population nIndiv    MeanX    MeanY
    ##   <chr>       <int>    <dbl>    <dbl>
    ## 1 A03            55 4431316. 5429358.
    ## 2 A21            69 4426927. 5427171.
    ## 3 A25           128 4422659. 5425365.
    ## 4 A26            78 4422710. 5425139.
    ## 5 A41            71 4426037. 5423339.
    ## 6 A45            75 4423091. 5427002.
    ## 7 G05a           60 4429202. 5434947.

Convert to spatial object

``` r
coordinates(Pulsatilla) <- ~MeanX+MeanY
```

Transform projection to the “longlat” coordinate system

``` r
proj4string(Pulsatilla) <- CRS("+init=epsg:31468")
```

    ## Warning in CPL_crs_from_input(x): GDAL Message 1: +init=epsg:XXXX syntax is
    ## deprecated. It might return a CRS with a non-EPSG compliant axis order.

``` r
Pulsatilla.longlat <- sp::spTransform(Pulsatilla, CRSobj = sp::CRS(SRS_string = "EPSG:4326"))
```

Display the coords slot of Pulsatilla.longlat

``` r
Pulsatilla.longlat@coords
```

    ##      coords.x1 coords.x2
    ## [1,]  11.05991  48.99773
    ## [2,]  11.00033  48.97755
    ## [3,]  10.94239  48.96080
    ## [4,]  10.94312  48.95877
    ## [5,]  10.98887  48.94300
    ## [6,]  10.94797  48.97558
    ## [7,]  11.03004  49.04774

Create bubble plot:

``` r
 bubble(Pulsatilla.longlat, "nIndiv", fill = FALSE,)
```

![](Week-3-R-Notebook_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->
