

# TODO - More meaningful error messages

validate_datalong <- function(data, vars){
    validate_datalong_varIsChar(vars)
    validate_datalong_varExists(data, vars)
    validate_datalong_types(data,vars)
    validate_datalong_notMissing(data, vars)
    validate_datalong_complete(data, vars)
    validate_datalong_unifromStrata(data,vars)
    return(invisible(TRUE))
}



#' Validate inputs for `vars`
#'
#' Checks that the required variable names are defined within `vars` and
#' are of appropriate datatypes
#'
#' @param vars named list indicating the names of key variables in the source dataset
validate_datalong_varIsChar <- function(vars){
    covars <- extract_covariates(vars$covariates)

    assert_that(
        is_char_one(vars$outcome),
        msg = "`vars$outcome` should be a length 1 character"
    )

    assert_that(
        is_char_one(vars$group),
        msg = "`vars$group` should be a length 1 character"
    )

    assert_that(
        is_char_one(vars$visit),
        msg = "`vars$visit` should be a length 1 character"
    )

    assert_that(
        is_char_one(vars$subjid),
        msg = "`vars$subjid` should be a length 1 character"
    )

    assert_that(
        is_char_one(vars$method),
        msg = "`vars$method` should be a length 1 character"
    )

    assert_that(
        is.character(vars$covars) | is.null(vars$covars),
        msg = "`vars$covars` should be a character vector or NULL"
    )

    assert_that(
        is.character(vars$strata) | is.null(vars$strata),
        msg = "`vars$strata` should be a character vector or NULL"
    )
    return(invisible(TRUE))
}


validate_datalong_varExists <- function(data, vars){


    assert_that(
        vars$outcome %in% names(data),
        msg = sprintf("Cannot find %s in `data`", vars$outcome )
    )

    assert_that(
        vars$group %in% names(data),
        msg = sprintf("Cannot find %s in `data`", vars$group )
    )

    assert_that(
        vars$visit %in% names(data),
        msg = sprintf("Cannot find %s in `data`", vars$visit )
    )

    assert_that(
        vars$subjid %in% names(data),
        msg = sprintf("Cannot find %s in `data`", vars$subjid )
    )

    assert_that(
        all(vars$strata %in% names(data)) | is.null(vars$strata),
        msg = "One of more variables listed in `vars$strata` do not exist in `data`"
    )

    covars <- extract_covariates(vars$covariates)
    assert_that(
        all(covars %in% names(data)) | is.null(covars),
        msg = "One of more variables listed in `vars$covariates` do not exist in `data`"
    )

    return(invisible(TRUE))
}


validate_datalong_types <- function(data, vars){
    covars <- extract_covariates(vars$covariates)

    assert_that(
        is_char_fact(data[[vars$subjid]]),
        msg = sprintf("Variable `%s` should be of type character or factor", vars$subjid)
    )

    assert_that(
        is_char_fact(data[[vars$group]]),
        msg = sprintf("Variable `%s` should be of type character or factor", vars$group)
    )

    assert_that(
        is.factor(data[[vars$visit]]),
        msg = sprintf("Variable `%s` should be of type factor", vars$visit)
    )

    assert_that(
        is.numeric(data[[vars$outcome]]),
        msg = sprintf("Variable `%s` should be of type numeric", vars$outcome)
    )

    additional_vars <- c(covars, vars$strata)

    if(!is.null(additional_vars)){
        for( var in additional_vars){
            assert_that(
                is_num_char_fact(data[[var]]),
                msg = sprintf("Variable `%s` should be of type numeric, factor or character", var)
            )
        }
    }
    return(invisible(TRUE))
}


validate_datalong_notMissing <- function(data, vars){
    non_missing_variables <- c(
        vars$group,
        vars$visit,
        vars$subjid,
        vars$strata,
        extract_covariates(vars$covariates)
    )
    for( var in non_missing_variables){
        if( any(is.na(data[[var]]))){
            stop(paste0("Variable ", var, " contains missing data"))
        }
    }
    return(invisible(TRUE))
}


validate_datalong_complete <- function(data, vars){
    unique_subjects <- unique(data[[vars$subjid]])
    unique_visits <- levels(data[[vars$visit]])
    is_complete_list <- tapply(
        data[[vars$visit]],
        data[[vars$subjid]],
        function(x) {
            all(unique_visits %in% x) & length(unique_visits) == length(x)
        },
        simplify = FALSE
    )
    is_complete <- unlist(is_complete_list, use.names = FALSE)
    if( ! all(is_complete)){
        stop("At least one subject has incomplete data")
    }
    return(invisible(TRUE))
}


validate_datalong_unifromStrata <- function(data, vars){
    for( var in vars$strata){
        x <- tapply(
            data[[var]],
            data[[vars$subjid]],
            function(x) length(unique(x))
        )
        if(!all(x ==1)){
            stop(
                "Stratification variable '", var,
                "' is not constant within at least one subject"
            )
        }
    }
    return(invisible(TRUE))
}


extract_covariates <- function(x){
    if(is.null(x)) return(x)
    x_split <- strsplit(x, ":|\\*")
    unique(unlist(x_split, use.names = FALSE))
}


is_char_one <- function(x){
    is.character(x) & (length(x) == 1)
}


is_char_fact <- function(x){
    is.character(x) | is.factor(x)
}


is_num_char_fact <- function(x){
    is.numeric(x) | is.character(x) | is.factor(x)
}





validate_dataice <- function(data, data_ice, vars, update = FALSE){

    validate_datalong_varIsChar(vars)

    method <- vars$method
    visit <- vars$visit
    subjid <- vars$subjid

    assert_that(
        is.character(data_ice[[method]]),
        all(!is.na(data_ice[[method]])),
        msg = "`data_ice[[vars$method]]` must be a non-missing character vector"
    )

    assert_that(
        is_char_fact(data_ice[[subjid]]),
        all(!is.na(data_ice[[subjid]])),
        msg = "`data_ice[[vars$subjid]]` must be a non-missing character or factor vector"
    )

    assert_that(
        all( as.character(data_ice[[subjid]]) %in% as.character(data[[subjid]])),
        msg = "`data_ice[[vars$subjid]]` contains values that aren't in `data[[vars$subjid]]`"
    )

    if(!update){
        valid_visits <- unique(as.character(data[[visit]]))

        assert_that(
            is.character(data_ice[[visit]]) | is.factor(data_ice[[visit]]),
            all(!is.na(data_ice[[visit]])),
            msg = "`data_ice[[vars$visit]]` must be a non-missing character or factor vector"
        )

        assert_that(
            all(as.character(data_ice[[visit]]) %in% valid_visits),
            msg = "`data_ice[[vars$visit]]` contains values that are not in `data[[vars$visit]]`"
        )
    }

    assert_that(
        length(data_ice[[subjid]]) == length(unique(data_ice[[subjid]])),
        msg = "`data_ice` must contain at most 1 row per subjects. If you have multiple ICEs please use the first Non-MAR ICE"
    )

    return(TRUE)
}
