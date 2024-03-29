% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.R
\name{plot.act_BayesGLM_cifti}
\alias{plot.act_BayesGLM_cifti}
\title{S3 method: use \code{\link[ciftiTools]{view_xifti_surface}} to plot a \code{"act_BayesGLM_cifti"} object}
\usage{
\method{plot}{act_BayesGLM_cifti}(x, idx = NULL, session = NULL, ...)
}
\arguments{
\item{x}{An object of class "act_BayesGLM_cifti"}

\item{idx}{Which task should be plotted? Give the numeric indices or the
names. \code{NULL} (default) will show all tasks. This argument overrides
the \code{idx} argument to \code{\link[ciftiTools]{view_xifti_surface}}.}

\item{session}{Which session should be plotted? \code{NULL} (default) will
use the first.}

\item{...}{Additional arguments to \code{\link[ciftiTools]{view_xifti_surface}}}
}
\value{
Result of the call to \code{ciftiTools::view_cifti_surface}.
}
\description{
S3 method: use \code{\link[ciftiTools]{view_xifti_surface}} to plot a \code{"act_BayesGLM_cifti"} object
}
