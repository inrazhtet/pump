#' Helper function for Westfall Young Single Step
#'
#' The  function  comp.rawt.SS is  needed  to  implement  the  Westfall-Young single-step multiple
#' testing procedure (MTP). It operates on one row of null test statistics.
#' It compares whether any of the null values across outcomes
#' exceeds each raw value for each outcome
#'
#' @param nullt a vector of permuted test statistic values under H0
#' @param rawt a vector of raw test statistic values under H1
#'
#' @return returns a vector of 1s and 0s with length of M outcomes
#' @export
#'
comp_rawt_ss <- function(nullt, rawt) {
  M <- length(nullt)
  maxt <- rep(NA, M)
  for (h in 1:M) {
    maxt[h] <- max(abs(nullt)) > abs(rawt)[h]
  }
  return(as.integer(maxt))
}

#' Helper function for Westfall Young Step Down
#'
#' @param nullt a vector of permuted test statistic values under H0
#' @param rawt a vector of raw test statistic values under H1
#' @param rawt.order order of raw test statistics in descending order
#'
#' @return returns a vector of 1s and 0s with lengths of M outcomes
#' @export
#'
comp_rawt_sd <- function(nullt, rawt, rawt.order) {

  M <- length(nullt)

  # ordered version of raw and null values
  rawt.ordered <- rawt[rawt.order]
  nullt.ordered <- nullt[rawt.order]

  # compute successive maxima
  qstar <- rep(NA, M)
  qstar[M] <- abs(nullt.ordered[M])
  for (h in (M-1):1)
  {
    qstar[h] <- max(qstar[h + 1], abs(nullt.ordered[h]))
  }

  # calculate adjusted p-value
  maxt <- rep(NA, M)
  for (h in 1:M) {
    maxt[h] <- qstar[h] > abs(rawt.ordered)[h]
  }

  return(as.integer(maxt))
}

#' Helper function for Westfall Young
#'
#' enforces monotonicity in p-values.
#'
#' @param ind.B matrix of indicator variables for if each raw test statistic exceeds
#'              the null test statistics. dimensions: nrow = tnum, ncol = M.
#' @param rawt.order order of raw test statistics in descending order
#'
#' @return returns adjusted p-value matrix
#' @export
#'
get_adjp_minp <- function(ind.B, rawt.order)
{
  # take means of dummies, these are already ordered but still need to enforce monotonicity
  pi.p.m <- colMeans(ind.B)

  # enforce monotonicity (keep everything in same order as sorted RAW pvalues from original data)
  adjp.minp <- rep(NA, length(pi.p.m))
  adjp.minp[1] <- pi.p.m[1]
  for (h in 2:length(pi.p.m)) {
    adjp.minp[h] <- max(pi.p.m[h], adjp.minp[h-1])
  }

  # return back in original, non-ordered form
  out <- data.frame(adjp = adjp.minp, rawt.order = rawt.order)
  out.oo <- out$adjp[order(out$rawt.order)]

  return(out.oo)
}

#' Westfall-Young Single Step Adjustment Function
#'
#' This adjustment function utilizes the comp.rawt.ss helper function to compare
#' each row of the matrix sample test statistics under
#' alternative hypothesis to all the rows in the matrix of the test statistics
#' under the complete null.
#'
#' @param rawt.mat a matrix of test statistics under H1. dimension: nrow = tnum, ncol = M
#' @param B the number of samples for which test statistics under the alternative hypothesis
#' are compared with the distribution (matrix) of test statistics under the complete null (this distribution
#' is obtained through drawing test values under H0 with a default of 10,000)
#' @param Sigma correlation matrix of null test statistics
#' @param t.df degrees of freedom of null test statistics
#'
#' @return a matrix of adjusted p-values
#' @export

adjp_wyss <- function(rawt.mat, B, Sigma, t.df) {

  # creating the matrix to store the adjusted test values
  M <- ncol(rawt.mat)
  tnum <- nrow(rawt.mat)
  adjp <- matrix(NA, nrow = tnum, ncol = M)

  # looping through all the samples of raw test statistics
  for (t in 1:tnum) {

    if(t == 1){ start.time = Sys.time() }

    # generate a bunch of null p values
    nullt <- mvtnorm::rmvt(B, sigma = Sigma, df = t.df)

    # compare the distribution of test statistics
    # under H0 with 1 sample of the raw statistics under H1
    ind.B <- t(apply(nullt, 1, comp_rawt_ss, rawt = rawt.mat[t,]))

    # calculating the p-value for each sample
    adjp[t,] <- colMeans(ind.B)

    if(t == 10)
    {
      end.time = Sys.time()
      iter.time = difftime(end.time, start.time, 'secs')[[1]]/10
      finish.time = round((iter.time * tnum)/60)
      message(paste('Estimated time to finish ', tnum, ' WY iterations:', finish.time, 'minutes'))
    }
  }
  return(adjp)
}

#' Westfall Young Step Down Function
#'
#' This adjustment function utilizes the comp.rawt.ss helper function to compare
#' each row of the matrix sample test statistics under
#' alternative hypothesis to all the rows in the matrix of the test statistics
#' under the complete null.
#'
#' @param B the number of samples for which test statistics under the alternative hypothesis
#' are compared with the distribution (matrix) of test statistics under the complete null (this distribution
#' is obtained through drawing test values under H0 with a default of 10,000)
#' @param rawt.mat a matrix of test statistics under H1. dimension: nrow = tnum, ncol = M
#' @param B the number of samples for which test statistics under the alternative hypothesis
#' are compared with the distribution (matrix) of test statistics under the complete null (this distribution
#' is obtained through drawing test values under H0 with a default of 10,000)
#' @param Sigma correlation matrix of null test statistics
#' @param t.df degrees of freedom of null test statistics
#' @param cl cluster
#'
#' @return a matrix of adjusted p-values
#' @export

adjp_wysd <- function(rawt.mat, B, Sigma, t.df, cl = NULL) {

  # creating the matrix to store the adjusted test values
  M <- ncol(rawt.mat)
  tnum <- nrow(rawt.mat)
  adjp <- matrix(NA, nrow = tnum, ncol = M)

  if(!is.null(cl))
  {
    parallel::clusterExport(
      cl,
      list("rawt.mat"),
      envir = environment()
    )
    rawt.order.matrix <- t(parallel::parApply(cl, abs(rawt.mat), 1, order, decreasing = TRUE))
  } else
  {
    rawt.order.matrix <- t(apply(abs(rawt.mat), 1, order, decreasing = TRUE))
  }

  # looping through all the samples of raw test statistics
  for (t in 1:tnum) {
    if(t == 1){ start.time = Sys.time() }

    # generate null t statistics
    nullt <- mvtnorm::rmvt(B, sigma = Sigma, df = t.df)

    # compare to raw statistics
    ind.B <- t(apply(nullt, 1, comp_rawt_sd, rawt = rawt.mat[t,], rawt.order = rawt.order.matrix[t,]))

    # calculate adjusted p value
    adjp[t,] <- get_adjp_minp(ind.B, rawt.order.matrix[t,])

    if(t == 10)
    {
      end.time = Sys.time()
      iter.time = difftime(end.time, start.time, 'secs')[[1]]/10
      finish.time = round((iter.time * tnum)/60)
      message(paste('Estimated time to finish WY iterations:', finish.time, 'minutes'))
    }
  }
  return(adjp)
}
