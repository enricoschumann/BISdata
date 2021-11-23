datasets <-
function(url = "https://www.bis.org/statistics/full_data_sets.htm", ...) {

    u <- url(url)
    txt <- readLines(u)
    close(u)
    txt <- txt[grep('href=./statistics.*full.*zip', txt)]

    fn <- gsub(".*(full[^/]+?zip).*", "\\1", txt)

    descr <- gsub("<[^>]*?>", "", txt)
    descr <- gsub("&nbsp;", " ", descr)
    descr <- gsub("(.*[)]).*", "\\1", descr)

    upd <- gsub("&nbsp;", " ", txt)
    upd <- gsub("<[^>]*?>", "", upd)
    upd <- gsub(paste0(".*?([0-9]+ (",
                       paste(month.name, collapse = "|"),
                       ") [0-9]+).*"), "\\1", upd)
    for (i in 1:12)
        upd <- sub(month.name[i], i, upd)
    upd <- as.Date(upd, "%d %m %Y")


    data.frame(filename = trimws(fn),
               description = trimws(descr),
               updated = upd)
}


fetch_dataset <-
function(dest.dir, dataset,
         bis.url = "https://www.bis.org/statistics/",
         exdir = tempdir(),
         return.class = NULL,
         ...) {


    if (!dir.exists(dest.dir)) {
        create.dir <- askYesNo(
            paste(sQuote("dest.dir"), "does not exist. Create it?"),
            default = FALSE)
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

    txt <- process_dataset(f.path,
                           exdir = exdir,
                           return.class = return.class)

    ## TODO apply filespecific parsing
    txt
}

process_dataset <- function(f.path, exdir, return.class, ...) {

    tmp <- unzip(f.path, exdir = exdir)
    on.exit(file.remove(tmp))
    txt <- read.table(tmp, header = TRUE, sep = ",",
                      stringsAsFactors = FALSE,
                      check.names = FALSE)

    if (is.null(return.class))
        return(txt)

    if (return.class == "zoo") {
        if (!requireNamespace("zoo")) {
            warning("package ", sQuote("zoo"), " not available")
            return(txt)
        }

        if (grepl("full_webstats_credit_gap_dataflow_csv.zip",
                  basename(f.path), fixed = TRUE) ||
            grepl("full_bis_total_credit_csv.zip",
                  basename(f.path), fixed = TRUE)) {

            ## FIXME grep for first date?
            j <- which(colnames(txt) == "Time Period")
            ans <- t(txt[, -seq_len(j)])
            ans <- zoo::zoo(ans,
                            zoo::as.yearqtr(rownames(ans),
                                            format = "%Y-Q%q"))
            attr(ans, "headers") <- t(txt[, seq_len(j)])
            colnames(ans) <- colnames(attr(ans, "headers")) <-
                txt[["Time Period"]]
        }
    } else
        ans <- txt
    ans
}
