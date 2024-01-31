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
