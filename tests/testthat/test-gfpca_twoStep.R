context("gfpca_twoStep")

test_that("coarsen_index only accepts positive integer 'significant_digits'",{
	index_values = 1:3
	
	expect_that(coarsen_index(index_values, significant_digits = 0),
							throws_error("'significant_digits' must be a positive integer."))
})

test_that("coarsen_index correctly rounds positive values",{
	index_values1 = c(0.84729, 0.9379, 0.19328)
	index_values2 = c(307, 86938, 13)
	
	expect_equal(coarsen_index(index_values1, significant_digits = 1),
							 expected = c(0.8, 0.9, 0.2))
	expect_equal(coarsen_index(index_values1, significant_digits = 3),
							 expected = c(0.847, 0.938, 0.193))
	expect_equal(coarsen_index(index_values2, significant_digits = 1),
							 expected = c(0, 90000, 0))
	expect_equal(coarsen_index(index_values2, significant_digits = 4),
							 expected = c(310, 86940, 10))
})

test_that("coarsen_index correctly rounds negative values",{
	index_values1 = c(0.84729, -0.9379, 0.19328)
	index_values2 = c(-307, 86938, -13)
	
	expect_equal(coarsen_index(index_values1, significant_digits = 1),
							 expected = c(0.8, -0.9, 0.2))
	expect_equal(coarsen_index(index_values1, significant_digits = 3),
							 expected = c(0.847, -0.938, 0.193))
	expect_equal(coarsen_index(index_values2, significant_digits = 1),
							 expected = c(0, 90000, 0))
	expect_equal(coarsen_index(index_values2, significant_digits = 4),
							 expected = c(-310, 86940, -10))
})

test_that("cov_hall returns a covariance matrix with correct dimensions",{
	data(growth_incomplete)
	
	index_grid = c(1.25, seq(from = 2, to = 18, by = 1))
	cov_matrix = cov_hall(growth_incomplete, index_evalGrid = index_grid)
	
	expect_identical(class(cov_matrix)[1], expected = "matrix")
	expect_type(cov_matrix, type = "double")
	expect_identical(dim(cov_matrix), expected = rep(length(index_grid), 2))
})

test_that("gfpca_twoStep (Gaussian) output is a list with non-null items and class fpca",{
	Y = simulate_functional_data(seed = 2020)$Y
	Y$value = Y$latent_mean
	
	fpca_object = gfpca_twoStep(Y, npc = 2)
	
	expect_equal(class(fpca_object), "fpca")
	expect_equal(fpca_object$family, "gaussian")
	
	expect_false(any(is.na(fpca_object$t_vec)))
	expect_false(any(is.na(fpca_object$mu)))
	expect_false(any(is.na(fpca_object$efunctions)))
	expect_false(any(is.na(fpca_object$evalues)))
	expect_false(any(is.na(fpca_object$scores)))
})

test_that("gfpca_twoStep (Gaussian) output has correct number of dimensions",{
	Y = simulate_functional_data(I = 100, D = 200, seed = 2020)$Y
	Kt = 8
	fpca_object = gfpca_twoStep(Y, npc = 2, Kt = Kt, index_significantDigits = 4)
	
	expect_equal(length(fpca_object$t_vec), 200)
	expect_equal(dim(fpca_object$alpha), c(200, 1))
	expect_equal(dim(fpca_object$efunctions), c(200, 2))
	expect_equal(length(fpca_object$evalues), 2)
	expect_equal(dim(fpca_object$scores), c(length(unique(Y$id)), 2))
	expect_equal(length(fpca_object$knots), Kt - 4)
	
	fpca_object = gfpca_twoStep(Y, npc = 1, Kt = Kt, index_significantDigits = 4)
	expect_equal(dim(fpca_object$efunctions), c(200, 1))
})

test_that("gfpca_twoStep (Binomial) output has correct number of dimensions",{
	Y = simulate_functional_data(I = 100, D = 200, seed = 2020)$Y
	Kt = 8
	fpca_object = gfpca_twoStep(Y, npc = 2, Kt = Kt, family = "binomial",
															index_significantDigits = 4)
	
	expect_equal(length(fpca_object$t_vec), 200)
	expect_equal(dim(fpca_object$alpha), c(200, 1))
	expect_equal(dim(fpca_object$efunctions), c(200, 2))
	expect_equal(length(fpca_object$evalues), 2)
	expect_equal(dim(fpca_object$scores), c(length(unique(Y$id)), 2))
	expect_equal(length(fpca_object$knots), Kt - 4)
	
	fpca_object = gfpca_twoStep(Y, npc = 1, Kt = Kt, family = "binomial",
															index_significantDigits = 4)
	expect_equal(dim(fpca_object$efunctions), c(200, 1))
})

test_that("gfpca_twoStep (Gamma) output has correct number of dimensions",{
	Y       = simulate_functional_data(I = 100, D = 200, seed = 2020)$Y
	Y$value = Y$value + 1 # make data strictly positive for gamma family
	Kt      = 8
	fpca_object = gfpca_twoStep(Y, npc = 2, Kt = Kt, family = "gamma",
															index_significantDigits = 4)
	
	expect_equal(length(fpca_object$t_vec), 200)
	expect_equal(dim(fpca_object$alpha), c(200, 1))
	expect_equal(dim(fpca_object$efunctions), c(200, 2))
	expect_equal(length(fpca_object$evalues), 2)
	expect_equal(dim(fpca_object$scores), c(length(unique(Y$id)), 2))
	expect_equal(length(fpca_object$knots), Kt - 4)
	
	fpca_object = gfpca_twoStep(Y, npc = 1, Kt = Kt, family = "gamma",
															index_significantDigits = 4)
	expect_equal(dim(fpca_object$efunctions), c(200, 1))
})

test_that("gfpca_twoStep (Poisson) output has correct number of dimensions",{
	Y       = simulate_functional_data(I = 100, D = 200, seed = 2020)$Y
	Y$value = Y$value + 1 # make data strictly positive for poisson family
	Kt      = 8
	fpca_object = gfpca_twoStep(Y, npc = 2, Kt = Kt, family = "poisson",
															index_significantDigits = 4)
	
	expect_equal(length(fpca_object$t_vec), 200)
	expect_equal(dim(fpca_object$alpha), c(200, 1))
	expect_equal(dim(fpca_object$efunctions), c(200, 2))
	expect_equal(length(fpca_object$evalues), 2)
	expect_equal(dim(fpca_object$scores), c(length(unique(Y$id)), 2))
	expect_equal(length(fpca_object$knots), Kt - 4)
	
	fpca_object = gfpca_twoStep(Y, npc = 1, Kt = Kt, family = "poisson",
															index_significantDigits = 4)
	expect_equal(dim(fpca_object$efunctions), c(200, 1))
})


test_that("gfpca_twoStep (Gaussian) returns a correct knots vector when periodic = TRUE",{
	Y = simulate_functional_data(I = 100, D = 200, seed = 2020)$Y
	Kt = 8
	fpca_object = gfpca_twoStep(Y, npc = 2, Kt = Kt, periodic = TRUE)
	
	expect_equal(length(fpca_object$knots), Kt - 1)
})

test_that("gfpca_twoStep (Gaussian) has correct number of dimensions when applied on incomplete curves",{
	Y = registr::growth_incomplete
	Kt = 8
	fpca_object = gfpca_twoStep(Y, npc = 2, Kt = Kt, index_significantDigits = 4)
	
	expect_equal(length(fpca_object$t_vec), 30)
	expect_equal(dim(fpca_object$alpha), c(30, 1))
	expect_equal(dim(fpca_object$efunctions), c(30, 2))
	expect_equal(length(fpca_object$evalues), 2)
	expect_equal(dim(fpca_object$scores), c(length(unique(Y$id)), 2))
	expect_equal(length(fpca_object$knots), Kt - 4)
	
	fpca_object = gfpca_twoStep(Y, npc = 1, Kt = Kt, index_significantDigits = 4)
	expect_equal(dim(fpca_object$efunctions), c(30, 1))
})

test_that("gfpca_twoStep (Gamma) throws an error when applied to non-strictly positive data",{
	Y = registr::growth_incomplete
	
	expect_error(gfpca_twoStep(Y, family = "gamma"),
							 "family = 'gamma' can only be applied to strictly positive data.")
})

test_that("gfpca_twoStep (Poisson) throws an error when applied to negative data",{
	Y = registr::growth_incomplete
	
	expect_error(gfpca_twoStep(Y, family = "poisson"),
							 "family = 'poisson' can only be applied to nonnegative data.")
})
