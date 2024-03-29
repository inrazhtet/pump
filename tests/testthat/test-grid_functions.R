# library( pum )
# library( testthat )

test_that("pump_power_grid works", {

  pp <- pump_power_grid(    design = "d3.2_m3ff2rc",
                            MTP = "Holm",
                            MDES = c( 0.05, 0.2 ),
                            M = 5,
                            J = c( 3, 5, 9), # number of schools/block
                            K = 7, # number RA blocks
                            nbar = 58,
                            Tbar = 0.50, # prop Tx
                            alpha = 0.15, # significance level
                            numCovar.1 = 1, numCovar.2 = 1,
                            R2.1 = 0.1, R2.2 = 0.7,
                            ICC.2 = 0.05, ICC.3 = 0.9,
                            rho = 0.4, # how correlated outcomes are
                            tnum = 200,
                            verbose = FALSE
  )
  pp
  expect_equal( nrow(pp), 3 * 2 * 2 )



  pp <- pump_power_grid(    design = "d3.2_m3ff2rc",
                            MTP = "Holm",
                            MDES = c( 0.05, 0.2 ),
                            M = 5,
                            J = 4, # number of schools/block
                            K = 7, # number RA blocks
                            nbar = 58,
                            Tbar = 0.50, # prop Tx
                            alpha = 0.15, # significance level
                            numCovar.1 = 1, numCovar.2 = 1,
                            R2.1 = 0.1, R2.2 = 0.7,
                            ICC.2 = 0.05, ICC.3 = 0.9,
                            rho = 0.4, # how correlated outcomes are
                            tnum = 200,
                            verbose = FALSE
  )
  pp
  expect_equal( nrow(pp), 2 * 2 )








  pp <- pump_power_grid(    design = "d3.2_m3ff2rc",
                            MTP = "Holm",
                            MDES = c( 0.05, 0.2 ),
                            numZero = c(1,2,3),
                            M = 5,
                            J = 4, # number of schools/block
                            K = 7, # number RA blocks
                            nbar = 58,
                            Tbar = 0.50, # prop Tx
                            alpha = 0.15, # significance level
                            numCovar.1 = 1, numCovar.2 = 1,
                            R2.1 = 0.1, R2.2 = 0.7,
                            ICC.2 = 0.05, ICC.3 = 0.9,
                            rho = 0.4, # how correlated outcomes are
                            tnum = 200,
                            verbose = FALSE
  )
  pp
  expect_equal( nrow(pp), 2 * 3 * 2)



  grid <- pump_power_grid( design="d3.2_m3ff2rc",
                           MTP = "Bonferroni",
                           MDES = 0.1,
                           M = 3,
                           J = 3, # number of schools/block
                           K = 21, # number RA blocks
                           nbar = 258,
                           Tbar = 0.50, # prop Tx
                           alpha = 0.05, # significance level
                           numCovar.1 = 5, numCovar.2 = 3,
                           R2.1 = 0.1, R2.2 = 0.7,
                           ICC.2 = seq( 0, 0.3, 0.05 ),
                           ICC.3 = seq( 0, 0.45, 0.15 ),
                           rho = 0.4,
                           tnum = 100 )
  a = length( unique( grid$ICC.2 ) )
  b = length( unique( grid$ICC.3 ) )
  expect_equal( nrow( grid ), a * b * 2 )
  expect_true( "MDES" %in% names(grid) )


  grid2 <- pump_power_grid( design="d3.2_m3ff2rc", drop_unique_columns = FALSE,
                            MTP = "Bonferroni",
                            MDES = 0.1,
                            M = 3,
                            J = c( 3, 4 ), # number of schools/block
                            K = 21, # number RA blocks
                            nbar = 258,
                            Tbar = 0.50, # prop Tx
                            alpha = 0.05, # significance level
                            numCovar.1 = 5, numCovar.2 = 3,
                            R2.1 = 0.1, R2.2 = 0.7,
                            ICC.2 = 0,
                            ICC.3 = 0,
                            rho = 0.4,
                            tnum = 100 )
  grid2
  expect_true( "rho" %in% names( grid2 ) )

  grid3 <- pump_power_grid( design=c( "d3.2_m3ff2rc", "d3.2_m3rr2rc" ), drop_unique_columns = FALSE,
                            MTP = "Bonferroni",
                            MDES = 0.1,
                            M = 3,
                            J = 3, # number of schools/block
                            K = 21, # number RA blocks
                            nbar = 258,
                            Tbar = 0.50, # prop Tx
                            alpha = 0.05, # significance level
                            numCovar.1 = 5, numCovar.2 = 3,
                            R2.1 = c( 0.1, 0.2 ), R2.2 = 0.7,
                            ICC.2 = 0,
                            ICC.3 = 0,
                            rho = c( 0, 0.4 ),
                            tnum = 100 )
  grid3
  expect_true( length( unique( grid3$design ) ) == 2 )



})


test_that("pump_mdes_grid works", {

  pp <- pump_mdes_grid(    design = "d3.2_m3ff2rc",
                           MTP = "Holm",
                           target.power = c( 0.50, 0.80 ),
                           power.definition = "D1indiv",
                           tol = 0.05,
                           M = 5,
                           J = c( 3, 9), # number of schools/block
                           K = 7, # number RA blocks
                           nbar = 58,
                           Tbar = 0.50, # prop Tx
                           alpha = 0.15, # significance level
                           numCovar.1 = 1, numCovar.2 = 1,
                           R2.1 = 0.1, R2.2 = 0.7,
                           ICC.2 = 0.05, ICC.3 = 0.9,
                           rho = 0.4, # how correlated outcomes are
                           verbose = FALSE, max.tnum = 1000,
  )
  pp
  expect_equal( nrow(pp), 2 * 2)

})


test_that("pump_sample_grid works", {

  pp <- pump_sample_grid(    design = "d3.2_m3ff2rc",
                             typesample = "J",
                             MTP = "Holm",
                             MDES = 0.10,
                             target.power = c( 0.50, 0.80 ),
                             power.definition = "min1",
                             tol = 0.03,
                             M = 5,
                             K = 7, # number RA blocks
                             nbar = 58,
                             Tbar = 0.50, # prop Tx
                             alpha = 0.15, # significance level
                             numCovar.1 = 1, numCovar.2 = 1,
                             R2.1 = 0.1, R2.2 = 0.7,
                             ICC.2 = 0.25, ICC.3 = 0.25,
                             rho = 0.4, # how correlated outcomes are
                             verbose = FALSE, max.tnum = 400

  )
  pp
  expect_equal( nrow(pp), 2 )

})


test_that( "grid allows multiple MTP and power definitions", {

  pp <- pump_mdes_grid(    design = "d3.2_m3ff2rc",
                           MTP = c( "Bonferroni", "Holm" ),
                           target.power = 0.5,
                           power.definition = c( "min1", "D1indiv" ),
                           tol = 0.05,
                           M = 5,
                           J = 5,
                           K = 7, # number RA blocks
                           nbar = 58,
                           Tbar = 0.50, # prop Tx
                           alpha = 0.15, # significance level
                           numCovar.1 = 1, numCovar.2 = 1,
                           R2.1 = 0.1, R2.2 = 0.7,
                           ICC.2 = 0.05, ICC.3 = 0.9,
                           rho = 0.4, # how correlated outcomes are
                           verbose = FALSE, max.tnum = 500,
  )
  pp
  expect_equal( nrow( pp ), 4 )



  pp <- pump_sample_grid(    design = "d3.2_m3ff2rc",
                             MTP = c( "Bonferroni", "Holm" ),
                             target.power = 0.9,
                             typesample = "J",
                             MDES = 0.05,
                             power.definition = c( "min1", "D1indiv" ),
                             tol = 0.05,
                             M = 5,
                             nbar = 10,
                             K = 12, # number RA blocks
                             Tbar = 0.50, # prop Tx
                             alpha = 0.15, # significance level
                             numCovar.1 = 1, numCovar.2 = 1,
                             R2.1 = 0.1, R2.2 = 0.7,
                             ICC.2 = 0.05, ICC.3 = 0.9,
                             rho = 0.4, # how correlated outcomes are
                             verbose = FALSE, max.tnum = 500,
  )
  pp
  expect_true( nrow( pp ) == 4 )
})




test_that( "grid works for long tables", {
  pp <- pump_power_grid(    design = "d3.2_m3ff2rc",
                            MTP = c( "Holm", "Bonferroni" ),
                            MDES = 0.10,
                            J = c( 4, 8 ),
                            M = 5,
                            K = 7, # number RA blocks
                            nbar = 58,
                            Tbar = 0.50, # prop Tx
                            alpha = 0.15, # significance level
                            numCovar.1 = 1, numCovar.2 = 1,
                            R2.1 = 0.1, R2.2 = 0.7,
                            ICC.2 = 0.25, ICC.3 = 0.25,
                            rho = 0.4, # how correlated outcomes are
                            tnum = 200, verbose = FALSE,
                            long.table = TRUE )

  expect_true( sum( is.na( pp$None ) ) > 0 )
  expect_true( ncol( pp ) == 7 )
})


test_that( "grid breaks with invalid inputs", {
  expect_error(pp <- pump_sample_grid(
    design = "d2.2_m2rc",
    MTP = c("Holm"),
    typesample = c("J"),
    MDES = 0.125,
    J = 10,
    M = 5,
    nbar = 50,
    target.power = 0.8,
    power.definition = "indiv.mean",
    alpha = 0.5,
    Tbar = 0.8,
    numCovar.1 = 2,
    rho = 0.2))

  expect_error(pp <- pump_mdes_grid(
    design = "d2.2_m2rc",
    MTP = c("Holm"),
    MDES = c(0.125),
    J = 10,
    M = 5,
    nbar = 50,
    target.power = 0.8,
    power.definition = "indiv.mean",
    alpha = 0.5,
    Tbar = 0.8,
    numCovar.1 = 2,
    rho = 0.2))
})
