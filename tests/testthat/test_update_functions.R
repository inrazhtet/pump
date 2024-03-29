
test_that( "update generally works", {

    set.seed( 101010 )
    ss <- pump_sample(    design = "d2.1_m2fc",
                          MTP = "Holm",
                          typesample = "J",
                          nbar = 200,
                          power.definition = "min1",
                          M = 5,
                          MDES = 0.05, target.power = 0.8,
                          tol = 0.05,
                          Tbar = 0.50, alpha = 0.05,
                          numCovar.1 = 5, numCovar.2 = 1,
                          R2.1 = 0.1, R2.2 = 0.7,
                          ICC.2 = 0.05, ICC.3 = 0.4,
                          rho = 0,
                          final.tnum = 1000 )

    up = update(ss, nbar = 10)
    ss$`Sample.size`
    up$`Sample.size`
    expect_true( up$`Sample.type` == ss$`Sample.type` )

    pm = params( up )
    upm = params( up )
    expect_true( length(pm) == length(upm) )
    expect_true( all( pm$MDES == upm$MDES ) )
    expect_true( ss$`Sample.size` < up$`Sample.size`)

    up$`Sample.size`
    topow = update( up, type = "power", J = 40 )
    expect_true( topow$min1[[2]] < up$`min1 power` )


    tomdes = update( topow, type="mdes",
                     target.power = 0.95,
                     power.definition = "min2" )
    expect_true( tomdes$`Adjusted.MDES` > params( topow )$MDES[[1]] )

    bsamp = update( tomdes, type="sample", typesample = "nbar",
                    MDES = 0.10 )
    expect_true( bsamp$`Sample.size` < params(tomdes)$nbar )


    tp2 = update( topow, design = "d3.2_m3ff2rc", K = 10,
                  MDES = 0.02 )
    tp2
    expect_true( design(tp2) == "d3.2_m3ff2rc" )
})



test_that( "update_grid generally works", {

    set.seed( 101010 )
    ss <- pump_mdes(    design = "d2.1_m2fc",
                        MTP = "Holm",
                        nbar = 200, J = 20,
                        power.definition = "complete",
                        M = 3, target.power = 0.5,
                        tol = 0.02,
                        Tbar = 0.50, alpha = 0.05,
                        numCovar.1 = 5, numCovar.2 = 1,
                        R2.1 = 0.1, R2.2 = 0.7,
                        ICC.2 = 0.05, ICC.3 = 0.4,
                        rho = 0,
                        final.tnum = 1000 )
    ss

    gd = update_grid( ss, J = c( 10, 20, 30 ) )
    gd
    expect_true( nrow( gd ) == 3 )

    s2 = update( ss, type="power", MDES = 0.10 )
    gd2 = update_grid( s2, R2.2 = c( 0.3, 0.5 ) )
    expect_true( nrow( gd2 ) == 4 )

    s3 = update( s2, type="sample", typesample="J",
                 power.definition = "D2indiv",
                 target.power = 0.70, tol = 0.03 )
    gd3 = update_grid( s3, power.definition = c( "min1", "min2" )  )
    expect_true( nrow(gd3) == 2 )
} )




