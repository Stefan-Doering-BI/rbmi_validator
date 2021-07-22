
#' Title
#'
#' Descriptions
#' @return TODO
scalerConstructor <- R6::R6Class(
    classname = "scaler",
    public = list(

        #' @field center TODO
        center = NULL,

        #' @field scales TODO
        scales = NULL,


        #' @description
        #' TODO
        #' @param dat TODO
        #' @return TODO
        initialize = function(dat){

            assert_that(
                is.data.frame(dat) | is.matrix(dat),
                all( vapply(dat, is.numeric, logical(1))),
                msg = "Input must be a numeric dataframe or matrix"
            )

            cat_flag <- vapply(
                X = dat,
                FUN = function(x) all(x %in% c(0,1)),
                FUN.VALUE = logical(1),
                USE.NAMES = FALSE
            )

            center <- vapply(
                X = dat,
                FUN = function(x) mean(x, na.rm = TRUE),
                FUN.VALUE = numeric(1),
                USE.NAMES = FALSE
            )

            scales <- vapply(
                X = dat,
                FUN = function(x) sd(x, na.rm = TRUE),
                FUN.VALUE = numeric(1),
                USE.NAMES = FALSE
            )

            center[cat_flag] <- 0
            scales[cat_flag] <- 1
            self$center <- center
            self$scales <- scales
        },


        #' @description
        #' TODO
        #' @param dat TODO
        #' @return TODO
        scale = function(dat){

            assert_that(
                is.data.frame(dat) | is.matrix(dat),
                all( vapply(dat, is.numeric, logical(1))),
                msg = "Input must be a numeric dataframe or matrix"
            )

            assert_that(
                ncol(dat) == length(self$center),
                msg = sprintf("Input must have %s columns", length(self$center))
            )

            dat <- sweep(
                dat,
                MARGIN = 2,
                STATS = self$center,
                FUN = `-`
            )

            dat <- sweep(
                dat,
                MARGIN = 2,
                STATS = self$scales,
                FUN = `/`
            )

            return(dat)
        },


        #' @description
        #' TODO
        #' @param sigma TODO
        #' @return TODO
        unscale_sigma = function(sigma){
            assert_that(
                is.matrix(sigma),
                msg = "Input must be a matrix"
            )
            return( sigma / self$scales[[1]]^2)
        },


        #' @description
        #' TODO
        #' @param beta TODO
        #' @return TODO
        unscale_beta = function(beta){

            len <- length(self$center) - 1

            assert_that(
                is.numeric(beta),
                length(beta) == len,
                msg = sprintf("`beta` must be a numeric vector of length %s", len)
            )

            b_0 <- beta[1]
            b_i <- beta[-1]

            mu_y <- self$center[1]
            mu_i <- self$center[-c(1,2)]

            sig_y <- self$scales[1]
            sig_i <- self$scales[-c(1,2)]

            unscaled_beta <- c(
                mu_y + sig_y * b_0 - sum(sig_y * b_i * mu_i / sig_i),
                b_i * sig_y / sig_i
            )
            return(unscaled_beta)
        }
    )
)













# ####### Test 1
#
#
# vars <- list(
#     outcome = "Sepal.Length",
#     group = "Sepal.Width",
#     visit = "Petal.Length",
#     covariates = c("Species", "Species*Petal.Length")
# )
#
# model_df <- as_model_df(iris, as_simple_formula(vars))
# scaler <- scalerConstructor$new(model_df)
#
# model_df_scaled <- scaler$scale(model_df)
#
# outcome_scaled <- model_df_scaled[,1]
# design_scaled <- model_df_scaled[,-1]
# mod_scaled <- lm(outcome_scaled ~ . - 1, data = design_scaled )
#
# outcome <- model_df[,1]
# design <- model_df[,-1]
# mod <- lm(outcome ~ . - 1, data = design )
#
# mod$coefficients - scaler$unscale_beta(mod_scaled$coefficients)
#
#
# ####### Test 2
#
#
# vars <- list(
#     outcome = "Sepal.Length",
#     group = "Sepal.Width",
#     visit = "Petal.Length",
#     covariates = c("Species", "Species*Petal.Length", "newvar * Species", "newvar * Sepal.Width")
# )
#
# i2 <- iris
# i2$newvar <- factor(sample(c("A", "B", "C"), size = 150 , replace = TRUE))
#
# model_df <- as_model_df(i2, as_simple_formula(vars))
# scaler <- scalerConstructor$new(model_df)
#
# model_df_scaled <- scaler$scale(model_df)
#
# outcome_scaled <- model_df_scaled[,1]
# design_scaled <- model_df_scaled[,-1]
# mod_scaled <- lm(outcome_scaled ~ . - 1, data = design_scaled )
#
# outcome <- model_df[,1]
# design <- model_df[,-1]
# mod <- lm(outcome ~ . - 1, data = design )
#
# mod$coefficients - scaler$unscale_beta(mod_scaled$coefficients)