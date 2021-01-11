---
title: Scatter Plot
author: Heather Johnston
date: '2021-01-10'
slug: scatter-plot
categories: []
tags: []
---

# Hello world

The first step is to generate some random data.


```r
data = data.frame(x = rnorm(100),
                  y = rnorm(100))
```

The second step is to make a scatter plot.


```r
plot(y ~ x, data = data)
```

![plot of chunk plot](/assets/images/scatter-plot/figure/plot-1.png)
