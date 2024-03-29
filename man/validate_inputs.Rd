% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/designs_and_models.R
\name{validate_inputs}
\alias{validate_inputs}
\title{Validates user inputs}
\usage{
validate_inputs(
  design,
  params.list,
  power.call = FALSE,
  mdes.call = FALSE,
  ss.call = FALSE,
  verbose = TRUE,
  multi.MTP.ok = FALSE
)
}
\arguments{
\item{design}{a single RCT design (see list/naming convention)}

\item{params.list}{a list of parameters input by a user}

\item{power.call}{flag for power estimation}

\item{mdes.call}{flag for MDES estimation}

\item{ss.call}{flag for sample size estimation}
}
\value{
params.list
}
\description{
This functions takes in a list of user inputs. Depending on the inputs,
it produces errors or warnings, and at times modifies inputs if necessary.
}
