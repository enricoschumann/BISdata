if (Sys.getenv("ES_PACKAGE_TESTING_73179826243954") == "true") {

    archive.dir <- "~/Downloads/BIS"
    if (!dir.exists(archive.dir))
        dir.create(archive.dir)


    x <- BISdata::datasets()
    for (f in x$filename) {
        data <- try(BISdata::fetch_dataset(dest.dir = archive.dir,
                                       dataset = f))
    }
}
