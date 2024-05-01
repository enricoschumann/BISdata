library("BISdata")


txt <- readLines("https://data.bis.org/bulkdownload", warn = FALSE)

i <- grep("static/bulk", txt)

m <- gregexec('href="/static/bulk/([^>]+?zip)">', txt[i])
files <- regmatches(txt[i], m)[[1]][2, ]

for (file in files) {
    message(file)
    fetch_dataset(dest.dir = "~/Downloads/BISdata",
                  dataset = file)
}




## Commercial Property Prices
d <- BISdata::fetch_dataset(dataset = "WS_CPP_csv_col.zip",
                            dest.dir = "~/Downloads/BISdata")

d <- BISdata::fetch_dataset(dataset = "WS_CPP_csv_flat.zip",
                            dest.dir = "~/Downloads/BISdata")
d$"TIME_PERIOD:Time period or range"

## Consumer prices
d <- BISdata::fetch_dataset(dataset = "WS_LONG_CPI_csv_col.zip",
                            dest.dir = "~/Downloads/BISdata")
d <- BISdata::fetch_dataset(dataset = "WS_LONG_CPI_csv_flat.zip",
                            dest.dir = "~/Downloads/BISdata")


