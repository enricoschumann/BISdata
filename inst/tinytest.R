if (requireNamespace("tinytest", quietly = TRUE))
    tinytest.results <- tinytest::test_package("BISdata",
                                               color = interactive(),
                                               verbose = 1)
