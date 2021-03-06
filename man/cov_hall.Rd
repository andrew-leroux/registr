% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gfpca_covHall.R
\name{cov_hall}
\alias{cov_hall}
\title{Covariance estimation after Hall et al. (2008)}
\usage{
cov_hall(
  Y,
  index_evalGrid,
  Kt = 8,
  Kc = 8,
  family = "gaussian",
  diag_epsilon = 0.01
)
}
\arguments{
\item{Y}{Dataframe. Should have values id, value, index.}

\item{index_evalGrid}{Grid for the evaluation of the covariance structure.}

\item{Kt}{Number of P-spline basis functions for the estimation of the
marginal mean. Defaults to 8.}

\item{Kc}{Number of marginal P-spline basis functions for smoothing the
covariance surface. Defaults to 8.}

\item{family}{One of \code{c("gaussian","binomial","gamma","poisson")}.
Poisson data are rounded before performing
the GFPCA to ensure integer data, see Details section below.
Defaults to \code{"gaussian"}.}

\item{diag_epsilon}{Small constant to which diagonal elements of the
covariance matrix are set if they are smaller. Defaults to 0.01.}
}
\value{
Covariance matrix with dimension \code{time_evalGrid x time_evalGrid}.
}
\description{
Internal function for the estimation of the covariance matrix of the latent
process using the approach of Hall et al. (2008). Used in the
two-step GFPCA approach implemented in \code{\link{gfpca_twoStep}}. \cr \cr
This function is an adaptation of the implementation of Jan
Gertheiss and Ana-Maria Staicu for Gertheiss et al. (2017), with focus on
higher (RAM) efficiency for large data settings.
}
\examples{
data(growth_incomplete)

index_grid = c(1.25, seq(from = 2, to = 18, by = 1))
cov_matrix = registr:::cov_hall(growth_incomplete, index_evalGrid = index_grid)

}
\references{
Hall, P., Müller, H. G., & Yao, F. (2008). Modelling sparse
generalized longitudinal observations with latent Gaussian processes.
\emph{Journal of the Royal Statistical Society: Series B (Statistical Methodology)},
70(4), 703--723.

Gertheiss, J., Goldsmith, J., & Staicu, A. M. (2017). A note on
modeling sparse exponential-family functional response curves.
\emph{Computational statistics & data analysis}, 105, 46--52.
}
\author{
Alexander Bauer \email{alexander.bauer@stat.uni-muenchen.de},
based on work of Jan Gertheiss and Ana-Maria Staicu
}
