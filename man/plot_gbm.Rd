% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_gbm.R
\name{plot_gbm}
\alias{plot_gbm}
\title{Plot output from gbm model}
\usage{
plot_gbm(model_list, feature = "gbm.pred")
}
\arguments{
\item{model_list}{Model list output from the \code{gbm_fit} function}

\item{feature}{Predictor feature to be plotted. Should be the name of a single feature to be plotted. If you
wish to plot all of the predictor features as a faceted plot, you may also specify \code{feature = 'distance'} or
\code{feature = 'density'}.}
}
\description{
Plots model output from a \code{gbm_fit} object. This function is primarily used to facilitate the plotting of
predicted probabilities on a grid-based map of a spatial region. By default, \code{gbm_fit} will create a basic
raster-based map using ggplot. Because the output is a ggplot object, is is easy to adjust or change the
plot manually as well. You may also provide the name of a variable you wish to plot - such as a predictor.
You can also plot all of your predictor variables (either distance or density) at the same time by specifying
\code{feature = 'density'} or \code{feature = 'distance'}.
}
