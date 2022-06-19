datasets <-
function(url = "https://www.bis.org/statistics/full_data_sets.htm", ...) {

    u <- url(url)
    txt <- try(readLines(u), silent = TRUE)
    close(u)
    if (inherits(txt, "try-error")) {
        warning("download failed with message ", sQuote(txt, FALSE))
        return(invisible(NULL))
    }
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

    if (!file.exists(f.path)) {
        dl.result <- try(download.file(dataset, f.path), silent = TRUE)
        if (inherits(dl.result, "try-error")) {
            warning("download failed with message ", sQuote(dl.result, FALSE))
            return(invisible(NULL))
        }
    } else
        dl.result <- 0

    if (dl.result != 0L) {
        warning("download failed with code ", dl.result, "; see ?download.file")
        return(invisible(NULL))
    }

    ## TODO apply filespecific parsing
    txt <- process_dataset(f.path,
                           exdir = exdir,
                           return.class = return.class, ...)

    txt
}

process_dataset <- function(f.path, exdir, return.class, ...) {

    tmp <- unzip(f.path, exdir = exdir)
    on.exit(file.remove(tmp))
    txt <- read.table(tmp, header = TRUE, sep = ",",
                      stringsAsFactors = FALSE,
                      check.names = FALSE,
                      fill = TRUE, ...)

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
        } else if (grepl("full_xru_d_csv_row.zip",
                         basename(f.path), fixed = TRUE)) {
            i <- which(txt[[1]] == "Time Period")
            ans <- txt[-seq_len(i), -1]
            ans <- apply(ans, 2, as.numeric)
            
            t <- as.Date(txt[-seq_len(i), 1])
            ans <- zoo(ans, t)
            attr(ans, "headers") <- txt[seq_len(i), -1]

            colnames(ans) <- colnames(attr(ans, "headers"))  <-
                txt[i, -1]
        }

    } else
        ans <- txt
    ans
}
