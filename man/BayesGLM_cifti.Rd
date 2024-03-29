% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BayesGLM_cifti.R
\name{BayesGLM_cifti}
\alias{BayesGLM_cifti}
\title{BayesGLM for CIFTI}
\usage{
BayesGLM_cifti(
  cifti_fname,
  surfL_fname = NULL,
  surfR_fname = NULL,
  brainstructures = c("left", "right"),
  design = NULL,
  onsets = NULL,
  TR = NULL,
  nuisance = NULL,
  dHRF = c(0, 1, 2),
  dHRF_as = c("auto", "nuisance", "task"),
  hpf = NULL,
  DCT = if (is.null(hpf)) {
     4
 } else {
     NULL
 },
  resamp_res = 10000,
  task_names = NULL,
  session_names = NULL,
  combine_sessions = TRUE,
  scale_BOLD = c("auto", "mean", "sd", "none"),
  scale_design = TRUE,
  Bayes = TRUE,
  ar_order = 6,
  ar_smooth = 5,
  aic = FALSE,
  num.threads = 4,
  return_INLA = c("trimmed", "full", "minimal"),
  verbose = 1,
  meanTol = 1e-06,
  varTol = 1e-06
)
}
\arguments{
\item{cifti_fname}{fMRI timeseries data in CIFTI format ("*.dtseries.nii").
For single-session analysis this can be a file path to a CIFTI file or a
\code{"xifti"} object from the \code{ciftiTools} package. For multi-session
analysis this can be a vector of file paths or a list of \code{"xifti"}
objects.}

\item{surfL_fname}{Left cortex surface geometry in GIFTI format
("*.surf.gii"). This can be a file path to a GIFTI file or a \code{"surf"}
object from the \code{ciftiTools} package. This argument is only used if
\code{brainstructures} includes \code{"left"} and \code{Bayes==TRUE}. If
it's not provided, the HCP group-average inflated surface included in the
\code{ciftiTools} package will be used.}

\item{surfR_fname}{Right cortex surface geometry in GIFTI format
("*.surf.gii"). This can be a file path to a GIFTI file or a \code{"surf"}
object from the \code{ciftiTools} package. This argument is only used if
\code{brainstructures} includes \code{"right"} and \code{Bayes==TRUE}. If
it's not provided, the HCP group-average inflated surface included in the
\code{ciftiTools} package will be used.}

\item{brainstructures}{Character vector indicating which brain structure(s)
to analyze: \code{"left"} (left cortical surface) and/or \code{"right"}
(right cortical surface). Default: \code{c("left","right")} (both
hemispheres). Note that the subcortical models have not yet been implemented.}

\item{design, onsets, TR}{Either provide \code{design} directly, or provide
both \code{onsets} and \code{TR} from which the design matrix or matrices
will be constructed.

\code{design} is a \eqn{T \times K} task design matrix. Each column
represents the expected BOLD response due to each task, a convolution of
the hemodynamic response function (HRF) and the task stimulus. Note that
the scale of the regressors will affect the scale and interpretation of the
beta coefficients, so imposing a proper scale is recommended; see the
\code{scale_design} argument, which by default is \code{TRUE}. Task names
should be the column names, if not provided by the \code{task_names}
argument. For multi-session modeling, this argument should be a list of
such matrices. To model HRF derivatives, calculate the derivatives of the
task columns beforehand (see the helper function \code{\link{cderiv}} which
computes the discrete central derivative) and either add them to
\code{design} to model them as tasks, or \code{nuisance} to model them as
nuisance signals; it's recommended to then drop the first and last
timepoints because the discrete central derivative doesn't exist at the
time series boundaries. Do note that INLA computation times increase
greatly if the design matrix has more than five columns, so it might be
required to add these derivatives to \code{nuisance} rather than
\code{design}.

\code{onsets} is an \eqn{L}-length list in which the name of each element is
the name of the corresponding task, and the value of each element is a
matrix of onsets (first column) and durations (second column) for each
stimuli (each row) of the corresponding task. The units of both columns
is seconds. For multi-session modeling, this argument should be a list of
such lists. To model HRF derivatives, use the arguments \code{dHRF} and
\code{dHRF_as}. If \code{dHRF==0} or \code{dHRF_as=="nuisance"}, the total
number of columns in the design matrix, \eqn{K}, will equal \eqn{L}.
If \code{dHRF_as=="task"}, \eqn{K} will equal \eqn{L} times \code{dHRF+1}.

\code{TR} is the temporal resolution of the data, in seconds.}

\item{nuisance}{(Optional) A \eqn{T \times J} matrix of nuisance signals.
These are regressed from the fMRI data and the design matrix prior to the
GLM computation. For multi-session modeling, this argument should be a list
of such matrices.}

\item{dHRF, dHRF_as}{Only applicable if \code{onsets} and \code{TR} are
provided. These arguments enable the modeling of HRF derivatives.

Set \code{dHRF} to \code{1} to model the temporal derivatives of each task,
\code{2} to add the second derivatives too, or \code{0} to not model the
derivatives. Default: \code{1}.

If \code{dHRF > 0}, \code{dHRF_as} controls whether the derivatives are
modeled as \code{"nuisance"} signals to regress out, \code{"tasks"}, or
\code{"auto"} (default) to treat them as tasks unless the total number of
columns in the design matrix would exceed five.}

\item{hpf, DCT}{Add DCT bases to \code{nuisance} to apply a temporal
high-pass filter to the data? Only one of these arguments should be provided.
\code{hpf} should be the filter frequency; if it is provided, \code{TR}
must be provided too. The number of DCT bases to include will be computed
to yield a filter with as close a frequency to \code{hpf} as possible.
Alternatively, \code{DCT} can be provided to directly specify the number
of DCT bases to include.

Default: \code{DCT=4}. For typical \code{TR}, four DCT bases amounts to a
lower frequency cutoff than the approximately .01 Hz used in most studies.
We selected this default to err on the side of retaining more low-frequency
information, but we recommend setting these arguments to values most
appropriate for the data analysis at hand.

Using at least two DCT bases is as sufficient as using linear and quadratic
drift terms in the design matrix. So if DCT detrending is being used, there
is no need to add linear and quadratic drift terms to \code{nuisance}.}

\item{resamp_res}{The number of vertices to which each cortical surface
should be resampled, or \code{NULL} to not resample. For computational
feasibility, a value of \code{10000} or lower is recommended.}

\item{task_names}{(Optional) Names of tasks represented in design matrix.}

\item{session_names}{(Optional, and only relevant for multi-session modeling)
Names of each session. Default: \code{NULL}. In \code{\link{BayesGLM}} this
argument will overwrite the names of the list entries in \code{data}, if
both exist.}

\item{combine_sessions}{If multiple sessions are provided, should their data
be combined and analyzed as a single session?

If \code{TRUE} (default), the multiple sessions will be concatenated along
time after scaling and nuisance regression, but before prewhitening. If
\code{FALSE}, each session will be analyzed separately, except that a single
estimate of the AR model coefficients for prewhitening is used, estimated
across all sessions.}

\item{scale_BOLD}{Option for scaling the BOLD response.

\code{"auto"} (default) will use \code{"mean"} scaling except if demeaned
data is detected (if any mean is less than one), in which case \code{"sd"}
scaling will be used instead.

\code{"mean"} scaling will scale the data to percent local signal change.

\code{"sd"} scaling will scale the data by local standard deviation.

\code{"none"} will only center the data, not scale it.}

\item{scale_design}{Scale the design matrix by dividing each column by its
maximum and then subtracting the mean? Default: \code{TRUE}. If
\code{FALSE}, the design matrix is centered but not scaled.}

\item{Bayes}{If \code{TRUE} (default), will fit a spatial Bayesian GLM in
addition to the classical GLM. (The classical GLM is always returned.)}

\item{ar_order}{(numeric) Controls prewhitening. If greater than zero, this
should be a number indicating the order of the autoregressive model to use
for prewhitening. If zero, do not prewhiten. Default: \code{6}. For
multi-session models, note that a single AR model is used; the parameters
are estimated by averaging the estimates from each session.}

\item{ar_smooth}{(numeric) FWHM parameter for smoothing the AR model
coefficient estimates for prewhitening. Remember that
\eqn{\sigma = \frac{FWHM}{2*sqrt(2*log(2)}}. Set to \code{0} or \code{NULL}
to not do any smoothing. Default: \code{5}.}

\item{aic}{Use the AIC to select AR model order between \code{0} and
\code{ar_order}? Default: \code{FALSE}.}

\item{num.threads}{The maximum number of threads to use for parallel
computations: prewhitening parameter estimation, and the inla-program model
estimation. Default: \code{4}. Note that parallel prewhitening requires the
\code{parallel} package.}

\item{return_INLA}{Return the INLA model object? (It can be large.) Use
\code{"trimmed"} (default) to return only the more relevant results, which
is enough for both \code{\link{id_activations}} and \code{BayesGLM2},
\code{"minimal"} to return just enough for \code{\link{BayesGLM2}} but not
\code{id_activations}, or \code{"full"} to return the full output of
\code{inla}.}

\item{verbose}{Should updates be printed? Use \code{1} (default) for
occasional updates, \code{2} for occasional updates as well as running INLA
in verbose mode (if applicable), or \code{0} for no updates.}

\item{meanTol, varTol}{Tolerance for mean and variance of each data location.
Locations which do not meet these thresholds are masked out of the analysis.
Default: \code{1e-6} for both.}
}
\value{
An object of class \code{"BayesGLM_cifti"}: a list with elements
\describe{
\item{betas_Bayesian}{The task coefficients for the Bayesian model.}
\item{betas_classical}{The task coefficients for the classical model.}
\item{GLMs_Bayesian}{The entire list of GLM results, except for parameters estimated for the classical model.}
\item{GLMs_classical}{Parameters estimated for the classical model from the GLM.}
\item{session_names}{The names of the sessions.}
\item{n_sess_orig}{The number of sessions (before averaging, if applicable).}
\item{task_names}{The task part of the design matrix, after centering and scaling, but before any nuisance regression or prewhitening.}
}
}
\description{
Performs spatial Bayesian GLM on the cortical surface for fMRI task activation
}
\section{INLA latent fields limit}{

INLA computation times increase greatly when the number of columns in the
design matrix exceeds five. So if there are more than five tasks, or
three or more tasks each with its temporal derivative being modeled as a
task, \code{BayesGLM} will raise a warning. In cases like the latter, we
recommend modeling the temporal derivatives as nuisance signals using the
\code{nuisance} argument, rather than modeling them as tasks.
}

\section{Connectome Workbench Requirement}{

This function uses a system wrapper for the 'wb_command' executable. The
user must first download and install the Connectome Workbench, available
from https://www.humanconnectome.org/software/get-connectome-workbench .
}

\section{INLA Requirement}{

This function requires the \code{INLA} package, which is not a CRAN package.
See \url{https://www.r-inla.org/download-install} for easy installation instructions.
}

