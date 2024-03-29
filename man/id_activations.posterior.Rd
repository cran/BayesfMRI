% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/id_activations.R
\name{id_activations.posterior}
\alias{id_activations.posterior}
\title{Identify activations using joint posterior probabilities}
\usage{
id_activations.posterior(model_obj, tasks, session, alpha = 0.05, gamma)
}
\arguments{
\item{model_obj}{Result of \code{BayesGLM}, of class \code{"BayesGLM"}.}

\item{tasks, session, alpha, gamma}{See \code{\link{id_activations}}.}
}
\value{
A list with two elements: \code{active}, which gives a matrix of zeros
and ones of the same dimension as \code{model_obj$task_estimates${session}},
and \code{excur_result}, an object of class \code{"excurobj"} (see \code{\link{excursions.inla}} for
more information).
}
\description{
Identifies areas of activation given an activation threshold and significance
level using joint posterior probabilities
}
\details{
For a given latent field, identifies locations that exceed a certain activation
threshold (e.g. 1 percent signal change) at a given significance level, based on the joint
posterior distribution of the latent field.
}
\keyword{internal}
