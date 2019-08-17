test_that("glob", {
    path <- file.path(".", "*.{R,r,S,s}")   
    expect_equal(basename(glob(path)), c("test_expand.R", "test_glob.R"))
})
