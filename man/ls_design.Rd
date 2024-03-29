% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lsmeans.R
\name{ls_design}
\alias{ls_design}
\alias{ls_design_equal}
\alias{ls_design_proportional}
\title{Calculate design vector for the lsmeans}
\usage{
ls_design_equal(data, frm, covars, fix)

ls_design_proportional(data, frm, covars, fix)
}
\arguments{
\item{data}{A data.frame}

\item{frm}{Formula used to fit the original model}

\item{covars}{a character vector of variables names that exist in
\code{data} which should be extracted (\code{ls_design_equal} only)}

\item{fix}{A named list of variables with fixed values}
}
\description{
Calculates the design vector as required to generate the lsmean
and standard error. \code{ls_design_equal} calculates it by
applying an equal weight per covariate combination whilst
\code{ls_design_proportional} applies weighting proportional
to the frequency in which the covariate combination occurred
in the actual dataset.
}
