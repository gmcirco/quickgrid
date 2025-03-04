% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_eval.R
\name{plot_eval}
\alias{plot_eval}
\title{Plot one or more prediction evaluations}
\usage{
plot_eval(
  model_fit,
  test_data,
  eval = "pai",
  cutoff_lower = 0.001,
  cutoff_upper = 0.01,
  cutoff_range = 100,
  penal = 1
)
}
\arguments{
\item{model_fit}{Fitted model object from the \code{gbm_fit}}

\item{test_data}{Out-of-sample observations to be used as evaluation data}

\item{eval}{Type of evaluation to be performed. Should be one of: 'pai', 'pei', 'rri'. Defaults to 'pai'.}

\item{cutoff_lower}{Lower limit of cutoff value to determine a hotspot. Defaults to 0.001.}

\item{cutoff_upper}{Upper limit of cutoff value to determine a hotspot. Defaults to 0.01.}

\item{cutoff_range}{Range of values to evaluate against. Defaults to 100.}
}
\description{
Plot one or more prediction evaluations
}
