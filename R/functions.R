csv_datasets <-
function(url = "https://www.bis.org/statistics/full_data_sets.htm", ...) {

    u <- url(url)
    txt <- readLines(u)
    close(u)
    txt <- txt[grep('href=./statistics.*full.*zip', txt)]

    data.frame(filename = gsub(".*(full[^/]+?zip).*", "\\1", txt),
               description = NA,
               updated = NA)
}


fetch_csv <-
function(dest.dir, dataset,
         bis.url = "https://www.bis.org/statistics/", ...) {


    if (!dir.exists(dest.dir)) {
        create.dir <- askYesNo(
            paste(sQuote("dest.dir"), "does not exist. Create it?"))
        if (!isTRUE(create.dir))
            return(invisible(NULL))
        dir.create(dest.dir, recursive = TRUE)
    }

    dataset <- basename(dataset)
    f.name <- paste0(format(Sys.Date(), "%Y%m%d_"), dataset)

    dataset <- paste0(bis.url, dataset)
    f.path <- file.path(normalizePath(dest.dir), f.name)

    if (!file.exists(f.path))
        dl.result <- download.file(dataset, f.path)
    else
        dl.result <- 0

    if (dl.result != 0L) {
        warning("download failed with code ", dl.result, "; see ?download.file")
        return(invisible(NULL))
    }

    tmp2 <- unzip(f.path, exdir = tempdir())
    txt <- read.table(tmp2, header = TRUE, sep = ",",
                      stringsAsFactors = FALSE,
                      check.names = FALSE)
    file.remove(tmp2)

    ## TODO apply filespecific parsing
    txt
}
