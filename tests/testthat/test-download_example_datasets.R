library(testthat)

skip_if_slow_tests_disabled()


test_that("download_example_datasets works if xdszip=cached", {
    skip_if_slow_tests_disabled()
    skip_if_no_example_datasets()
    x <- evalwith(
        datadir_persistent = "filled",
        datadir_temp = "missing",
        message = "captured",
        expr = {
            download_example_datasets(persistent = TRUE)
            expected_path <- file.path(datadir(), "example_datasets.zip")
        }
    )
    expect_true(file.exists(expected_path))
    expect_equal(file.size(expected_path), xds$zip_size)
    expect_equal(object = x$message, expected = character())
})

test_that("download_example_datasets works if xdszip=missing", {
    skip_if_slow_tests_disabled()
    skip_if_no_example_datasets()
    x <- evalwith(datadir_persistent = "missing", datadir_temp = "missing", message = "captured", {
        download_example_datasets()
        expected_path <- file.path(datadir(), "example_datasets.zip")
    })
    expected_message <- paste("Downloading", xds$url, "as", expected_path)
    expect_equal(file.exists(expected_path), TRUE)
    expect_equal(file.size(expected_path), xds$zip_size)
    expect_equal(x$message, expected_message)
})

test_that("download_example_datasets works if xdszip=missing and persistent=T", {
    skip_if_slow_tests_disabled()
    skip_if_no_example_datasets()
    x <- evalwith(datadir_persistent = "missing", datadir_temp = "missing", message = "captured", {
        download_example_datasets(persistent = TRUE)
        expected_path <- file.path(datadir(), "example_datasets.zip")
    })
    expected_message <- paste("Downloading", xds$url, "as", expected_path)
    expect_equal(file.exists(expected_path), TRUE)
    expect_equal(file.size(expected_path), xds$zip_size)
    expect_equal(x$message, expected_message)
})

test_that("download_example_datasets warns for outdated persistent cache", {
    skip_if_slow_tests_disabled()
    skip_if_no_example_datasets()
    x <- evalwith(
        datadir_persistent = "filled",
        datadir_temp = "missing",
        message = "captured",
        {
            pzip <- zip_persistent()
            if (file.exists(pzip)) unlink(pzip)
            file.create(pzip)
            download_example_datasets(persistent = FALSE)
            expect_true(file.exists(zip_temp()))
            expect_equal(file.size(zip_temp()), xds$zip_size)
        }
    )
    msg <- paste(x$message, collapse = "\n")
    expect_match(msg, "Found outdated or corrupt persistent cache file")
})
