% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util.R
\name{s2m_B}
\alias{s2m_B}
\title{Sequential 2-means on array B}
\usage{
s2m_B(B, sigma)
}
\arguments{
\item{B}{An array of posterior samples (typically a matrix), in which the last margin corresponds to a single posterior sample}

\item{sigma}{A scale parameter used to determine at what distance cluster centers are considered to be the same.}
}
\value{
An array of dimension \code{head(dim(B),-1)} with a point estimate of B based on the sequential 2-means method
}
\description{
Sequential 2-means on array B
}
\keyword{internal}
