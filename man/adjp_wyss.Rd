% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pump_wy.R
\name{adjp_wyss}
\alias{adjp_wyss}
\title{Westfall-Young Single Step Adjustment Function}
\usage{
adjp_wyss(rawt.mat, B, Sigma, t.df)
}
\arguments{
\item{rawt.mat}{a matrix of test statistics under H1. dimension: nrow = tnum, ncol = M}

\item{B}{the number of samples for which test statistics under the alternative hypothesis
are compared with the distribution (matrix) of test statistics under the complete null (this distribution
is obtained through drawing test values under H0 with a default of 10,000)}

\item{Sigma}{correlation matrix of null test statistics}

\item{t.df}{degrees of freedom of null test statistics}
}
\value{
a matrix of adjusted p-values
}
\description{
This adjustment function utilizes the comp.rawt.ss helper function to compare
each row of the matrix sample test statistics under
alternative hypothesis to all the rows in the matrix of the test statistics
under the complete null.
}
