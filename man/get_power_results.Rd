% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pump_power.R
\name{get_power_results}
\alias{get_power_results}
\title{Calculates different definitions of power}
\usage{
get_power_results(
  adj.pval.mat,
  unadj.pval.mat,
  ind.nonzero,
  alpha,
  two.tailed,
  adj = TRUE
)
}
\arguments{
\item{adj.pval.mat}{matrix of adjusted p-values, columns are outcomes}

\item{unadj.pval.mat}{matrix of unadjusted p-values, columns are outcomes}

\item{ind.nonzero}{vector indicating which outcomes are nonzero}

\item{alpha}{scalar; the family wise error rate (FWER)}

\item{two.tailed}{scalar; TRUE/FALSE for two-tailed or one-tailed power calculation.}

\item{adj}{whether p-values are unadjusted or not}
}
\value{
power results for individual, minimum, complete power
}
\description{
This function takes in a matrix of adjusted p-values and outputs different types of power
}
