% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parallel.R
\name{encap_get_mmrm_sample}
\alias{encap_get_mmrm_sample}
\title{Encapsulate get_mmrm_sample}
\usage{
encap_get_mmrm_sample(cl, longdata, method)
}
\arguments{
\item{cl}{Either a cluster from \code{\link[=get_cluster]{get_cluster()}} or \code{NULL}}

\item{longdata}{A longdata object from \code{longDataConstructor$new()}}

\item{method}{A method object}
}
\description{
Function creates a new wrapper function around \code{\link[=get_mmrm_sample]{get_mmrm_sample()}}
so that the arguments of \code{\link[=get_mmrm_sample]{get_mmrm_sample()}} are enclosed within
the new function. This makes running parallel and single process
calls to the function smoother. In particular this function takes care
of exporting the arguments if required to parallel process in a cluster
}
\seealso{
\code{\link[=get_cluster]{get_cluster()}} for more documentation on the function inputs
}
