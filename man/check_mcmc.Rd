% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mcmc.R
\name{check_mcmc}
\alias{check_mcmc}
\title{Diagnostics of the MCMC}
\usage{
check_mcmc(stan_fit, n_draws, threshold_lowESS = 0.4)
}
\arguments{
\item{stan_fit}{A \code{stanfit} object.}

\item{n_draws}{Number of MCMC draws.}

\item{threshold_lowESS}{A number in \verb{[0,1]} indicating the minimum acceptable
value of the relative ESS. See details.}
}
\value{
A warning message in case of detected problems.
}
\description{
Diagnostics of the MCMC
}
\details{
Performs checks of the quality of the MCMC. See \code{\link[=check_ESS]{check_ESS()}} and \code{\link[=check_hmc_diagn]{check_hmc_diagn()}}
for details.
}
