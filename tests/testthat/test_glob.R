test_that("glob", {
    path <- file.path(".", "*.{R,r,S,s}")
    expect_equal(basename(glob(path, engine = "r")),
                 c("test_expand.R", "test_glob.R"))
})
