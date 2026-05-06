capture program drop eq_lpoly
program define eq_lpoly
    version 15.1
    syntax varlist(min=2 max=2 numeric)
    qui bootstrap eq = r(eq), reps(200) seed(123): _eq_lpoly `varlist'
    estat bootstrap, percentile
end
