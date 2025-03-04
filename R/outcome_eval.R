#----------------------------------------------------#
# OUTCOME_EVAL
#----------------------------------------------------#
#' Evaluate predictions from a gbm_fit model
#'
#' Evaluate predictions from a fitted gbm_fit model. Provides a variety of functions to estimate the out-of-sample
#' effectiveness of a prediction model, including the predictive accuracy index (PAI), the predictive efficiency index
#' (PEI), and the recapture rate index (RRI). At a minimum users must provide a fitted model object from the
#' `gbm_fit` function and a set of out-of-sample observations as 'test' data. These out-of-sample values should be
#' crimes or observations that were not used in the fitting the model. 
#' 
#' Supplying a value for the parameter `penal` allows models to consider the penalized predictive accuracy index (pPAI)
#' as described in Joshi, Curtis-Ham, D'Ath, and Searle (2021).
#'
#' @param model_fit Fitted model object from the `gbm_fit`
#' @param test_data Out-of-sample observations to be used as evaluation data
#' @param eval Type of evaluation to be performed. Should be one of: 'pai', 'ppai', 'pei', 'rri'. Defaults to 'pai'.
#' @param cutoff Cutoff value to determine a hotspot, in proportion of the area. Defaults to 0.01, which is the top 1%
#' of predicted locations.
#' @param penal Penalization factor p where 0 ≤ p ≤ 1. Defaults to 1, which is equivalent to the PAI.
#'
#'
#'@export

outcome_eval <-
  function(model_fit,
           test_data,
           eval = "pai",
           cutoff = 0.01,
           penal = 1) {
    
    # Get model data from model fit
    # Needs to have the prediction column gbm.pred
    model_dataframe <- model_fit$model_dataframe
    
    # Get necessary values for PAI, PEI, and RRI
    # Get the cutoff for a hotspot
    hotspot <-
      quantile(model_dataframe$gbm.pred, probs = 1 - cutoff)
    
    # Global Variables for sub-functions
    # a = number of hotspot regions
    # n = number of crimes in hotspot regions
    # n_sum = total number of predicted crimes in hotspots
    # max_a = number of areas in hotspot regions
    a <- dplyr::filter(model_dataframe, gbm.pred >= hotspot)
    n <- nrow(test_data[a,])
    n_sum <- sum(a$gbm.pred)
    max_a <- round(nrow(model_dataframe) * cutoff)
    
    
    # Initialize list to hold results
    # pai, pei,pai
    eval_list <- list()
    
    if (any(eval %in% 'pai'))
      eval_list[[1]] <- .pai(a, n, test_data, cutoff, penal)
    
    if (any(eval %in% 'pei'))
      eval_list[[2]] <- .pei(a, max_a, n, test_data, model_dataframe, cutoff, penal)
    
    if (any(eval %in% 'rri'))
      eval_list[[3]] <- .rri(a, n, n_sum, test_data, cutoff)
    
    # Filter empty sections in list
    eval_list <- unlist(eval_list[lengths(eval_list) != 0])
    
    return(eval_list)
  }

#----------------------------------------------------#
# EVAL FUNCTIONS
#----------------------------------------------------#

# .PAI
# Calculate the predictive accuracy index (PAI)

.pai <-
  function(a = a,
           n = n,
           test_data = test_data,
           cutoff = cutoff,
           penal = penal) {
    
    if(penal < 0 | penal > 1)
      stop("Penal must lie between 0 and 1")
    
    # Calculate PAI
    out <- c("PAI" = round((n / nrow(test_data)) / (cutoff^penal), 2))
    
    # Export PAI
    return(out)
  }

# .PEI
# Calculate predictive efficiency index
.pei <-
  function(a = a,
           max_a = max_a,
           n = n,
           test_data = test_data,
           model_dataframe = model_dataframe,
           cutoff = cutoff,
           penal = penal) {
    
    # Join test data to model grid and obtain counts
    n_per <- sf::st_join(test_data, model_dataframe) %>%
      data.frame() %>%
      dplyr::count(grid_id) %>%
      dplyr::arrange(desc(n)) %>%
      dplyr::slice(1:max_a)
    
    # Optimal PAI for given cutoff
    pai_per <- sum(n_per$n) / nrow(test_data) / cutoff
    pai_obs <- as.numeric(.pai(a, n, test_data, cutoff, penal))
    
    # Calculate ratio of observed to perfect
    out <- c("PEI" = round(pai_obs / pai_per, 2))
    
    # Export PEI
    return(out)
  }

# .RRI
# Calculate recapture rate index
.rri <-
  function(a = a,
           n = n,
           n_sum = n_sum,
           test_data = test_data,
           cutoff = cutoff) {
    
    # Calculate RRI
    out <- c("RRI" = round(n_sum / n, 2))
    
    # Export PAI
    return(out)
  }
