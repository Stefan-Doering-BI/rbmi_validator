% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities.R
\name{char2fct}
\alias{char2fct}
\title{Convert character variables to factor}
\usage{
char2fct(data, vars = NULL)
}
\arguments{
\item{data}{A data.frame}

\item{vars}{a character vector of variables in \code{data}}
}
\description{
Provided a vector of variable names this function converts any
character variables into factors. Has no affect on numeric or existing
factor variables
}
