capture program drop _eq_lpoly
program define _eq_lpoly, rclass
    version 15.1
    syntax varlist(min=2 max=2 numeric)

    tokenize `varlist'
    local y `1'
    local x `2'

    preserve
        keep if !missing(`y', `x')

        quietly summarize `x', meanonly
        local xmin = r(min)
        local xmax = r(max)

        tempvar xgrid yhat diff cross obs

        if _N < 200 {
            quietly set obs 200
        }

        gen double `xgrid' = .
        replace `xgrid' = `xmin' + (`xmax' - `xmin') * (_n - 1) / 199 in 1/200

        quietly lpoly `y' `x', ///
            at(`xgrid') ///
            gen(`yhat') ///
            kernel(epanechnikov) ///
            degree(4) ///
            nograph

        keep if !missing(`xgrid', `yhat')

        gen double `diff' = `yhat' - `xgrid'
        sort `xgrid'

        gen byte `cross' = (`diff' * `diff'[_n-1] < 0) if _n > 1
        gen long `obs' = _n

        quietly levelsof `obs' if `cross' == 1, local(crossings)
        local k : word 1 of `crossings'

        if "`k'" == "" {
            return scalar eq = .
            restore
            exit
        }

        local k1 = `k' - 1

        scalar x1 = `xgrid'[`k1']
        scalar x2 = `xgrid'[`k']
        scalar d1 = `diff'[`k1']
        scalar d2 = `diff'[`k']

        scalar eq = x1 - d1 * (x2 - x1) / (d2 - d1)

        return scalar eq = eq
    restore
end
