---
title: Colorful Scatter Plot
author: Heather Johnston
date: '2021-01-11'
slug: colorful-scatter-plot
categories: []
tags: []
---

# Hello World 2

Now to generate a more colorful scatter plot.

First we will load ggplot2. 


```r
library(ggplot2)
```

Now we will generate some data.


```r
data = data.frame(x = rnorm(100),
                  y = rnorm(100),
                  z = rbinom(100, 1, .5))
```

Now a plot.


```r
ggplot(data, aes(x = x, y = y, color = as.factor(z))) +
  geom_point() +
  theme_bw()
```

![plot of chunk colorful plot](/assets/images/colorful-scatter-plot/figure/colorful plot-1.png)
