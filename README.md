
<!-- README.md is generated from README.Rmd. Please edit that file -->

# poweRof10

<!-- badges: start -->

![](https://img.shields.io/badge/just-for%20fun-blue.svg) [![R build
status](https://github.com/hfshr/poweRof10/workflows/R-CMD-check/badge.svg)](https://github.com/hfshr/poweRof10/actions)
![stability-wip](https://img.shields.io/badge/stability-work_in_progress-lightgrey.svg)
<!-- badges: end -->

`poweRof10` is a small package that scrapes data from athletics rankings
website www.thepowerof10.info. I’m a big athletics fan and created
`poweRof10` for a bit of fun to analyse my own performances, but thought
it might be worth sharing here. The package is still a little rough
around the edges, but the basic functionality should work well enough!

Check out [this blog
post](https://hfshr.xyz/posts/2020-10-22-introducing-powerof10/) for
some more examples.

## Installation

Install from github with:

``` r
# install.packages("remotes")
remotes::install_github("hfshr/poweRof10")
```

## Basic usage

You can get the rankings for a specific event/year/gender/age group
using the `get_event()` function:

``` r
get_event(event = "100", agegroup = "ALL", gender = "M", year = 2016, top_n = 10) %>% 
  select(rank, perf, name, venue)
#>    rank  perf                   name               venue
#> 1     1  9.96            Joel Fearon             Bedford
#> 2     2 10.01          Richard Kilty              Hexham
#> 3        9.92                               Gavardo, ITA
#> 4     2 10.01          Chijindu Ujah Rio de Janeiro, BRA
#> 5        9.97                                 Birmingham
#> 6     4 10.04        James Ellington      Amsterdam, NED
#> 7        9.96                                 Birmingham
#> 8     4 10.04          Reece Prescod             Bedford
#> 9     6 10.08 Harry Aikines-Aryeetey        Loughborough
#> 10      10.02                                 Birmingham
```

Alternatively, you can search for an individual athlete and get their
performance history with `get_athlete()`:

``` r
get_athlete(fn = "Harry", sn = "Fisher", club = "Cardiff/Cardiff Met Uni") %>% 
  select(event, perf, pos, venue, date) %>% 
  head(10)
#>      event  perf pos         venue      date
#> 1   8.6KXC 31:56  40      Chepstow  8 Feb 20
#> 2  parkrun 17:33  16       Cardiff  5 Oct 19
#> 3   9.3KXC 35:28  69 Blaise Castle  7 Dec 19
#> 4      400 49.00   1     Sheffield 18 Feb 18
#> 5      400 49.16   1       Bedford  5 May 18
#> 6      400 49.32   5     Sheffield 18 Feb 18
#> 7      400 49.43   5       Bedford  6 May 18
#> 8      400 49.66   1     Sheffield 17 Feb 18
#> 9      400 49.86   1       Cardiff 27 Jan 18
#> 10     400 50.18   1       Cardiff 27 Jan 18
```

## Acknowledgements

Thanks to the team that keep www.thepowerof10.info up and running, it’s
an invaluable resource for many!
