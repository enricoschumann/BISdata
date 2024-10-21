library("BISdata")
library("plotseries")


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


d <- BISdata::fetch_dataset(dataset = "WS_DPP_csv_flat.zip",
                            dest.dir = "~/Downloads/BISdata")
str(d)
table(d$"REF_AREA:Reference area")
dd <- d[d$"REF_AREA:Reference area" == "CN: China", ]
str(dd)
table(dd$"COVERED_AREA:Covered area")
table(dd$"RE_VINTAGE:Real estate vintage")
table(dd$"RE_TYPE:Real estate type")


ddd <- dd[
dd$"RE_TYPE:Real estate type" == "8: Flats" &
dd$"RE_VINTAGE:Real estate vintage" == "1: Existing" &
!is.na(dd$"TIME_PERIOD:Time period or range") ,
]

plot(as.yearmon(ddd$"TIME_PERIOD:Time period or range"),
     ddd$"OBS_VALUE:Observation Value")


ddd <- dd[
dd$"RE_TYPE:Real estate type" == "N: Mixed (residential and non-residential) properties" &
!is.na(dd$"TIME_PERIOD:Time period or range") ,
]
plot(as.yearmon(ddd$"TIME_PERIOD:Time period or range"),
     ddd$"OBS_VALUE:Observation Value")


## Credit
d <- BISdata::fetch_dataset(dataset = "WS_TC_csv_flat.zip",
                            dest.dir = "~/Downloads/BISdata")
str(d)
table(d$"TC_BORROWERS:Borrowing sector")


countries <- c("US: United States", "IL: Israel", "JP: Japan",
               "FR: France","CH: Switzerland")
country <- countries[1]


dd <- d[d$"TC_BORROWERS:Borrowing sector" == "G: General government" &
        d$"BORROWERS_CTY:Borrowers' country" == country &
        d$"UNIT_TYPE:Unit type" == "770: Percentage of GDP" &
        !is.na(d$"TIME_PERIOD:Time period or range") &
        d$"VALUATION:Valuation method" == "N: Nominal value",
        c("TIME_PERIOD:Time period or range",
          "OBS_VALUE:Observation Value")]
plotseries(dd[, 2], as.yearqtr(dd[, 1], format = "%Y-Q%q"), ylim = c(0, 300))

sec <- "H: Households & NPISHs"
dd <- d[d$"TC_BORROWERS:Borrowing sector" == sec &
        d$"BORROWERS_CTY:Borrowers' country" == country &
        d$"UNIT_TYPE:Unit type" == "770: Percentage of GDP" &
        !is.na(d$"TIME_PERIOD:Time period or range") &
        d$"VALUATION:Valuation method" == "M: Market value",
        c("TIME_PERIOD:Time period or range",
          "OBS_VALUE:Observation Value")]
plotseries(dd[, 2], as.yearqtr(dd[, 1], format = "%Y-Q%q"), lines = TRUE)

sec <- "N: Non-financial corporations"
dd <- d[d$"TC_BORROWERS:Borrowing sector" == sec &
        d$"BORROWERS_CTY:Borrowers' country" == country &
        d$"UNIT_TYPE:Unit type" == "770: Percentage of GDP" &
        !is.na(d$"TIME_PERIOD:Time period or range") &
        d$"VALUATION:Valuation method" == "M: Market value",
        c("TIME_PERIOD:Time period or range",
          "OBS_VALUE:Observation Value")]
plotseries(dd[, 2], as.yearqtr(dd[, 1], format = "%Y-Q%q"), lines = TRUE)

sec <- "P: Private non-financial sector"
dd <- d[d$"TC_BORROWERS:Borrowing sector" == sec &
        d$"BORROWERS_CTY:Borrowers' country" == country &
        d$"UNIT_TYPE:Unit type" == "770: Percentage of GDP" &
        !is.na(d$"TIME_PERIOD:Time period or range") &
        d$"TC_LENDERS:Lending sector" == "A: All sectors" &
        d$"VALUATION:Valuation method" == "M: Market value",
        c("TIME_PERIOD:Time period or range",
          "OBS_VALUE:Observation Value")]
plotseries(dd[, 2], as.yearqtr(dd[, 1], format = "%Y-Q%q"), lines = TRUE)

sec <- "C: Non financial sector"
dd <- d[d$"TC_BORROWERS:Borrowing sector" == sec &
        d$"BORROWERS_CTY:Borrowers' country" == country &
        d$"UNIT_TYPE:Unit type" == "770: Percentage of GDP" &
        !is.na(d$"TIME_PERIOD:Time period or range") &
        d$"TC_LENDERS:Lending sector" == "A: All sectors" &
        d$"VALUATION:Valuation method" == "M: Market value",
        c("TIME_PERIOD:Time period or range",
          "OBS_VALUE:Observation Value")]
plotseries(dd[, 2], as.yearqtr(dd[, 1], format = "%Y-Q%q"), lines = TRUE)


## Consumer prices
d <- BISdata::fetch_dataset(dataset = "WS_LONG_CPI_csv_col.zip",
                            dest.dir = "~/Downloads/BISdata")
d <- BISdata::fetch_dataset(dataset = "WS_LONG_CPI_csv_flat.zip",
                            dest.dir = "~/Downloads/BISdata")

## Policy rates
d <- BISdata::fetch_dataset(dataset = "WS_CBPOL_csv_col.zip",
                            dest.dir = "~/Downloads/BISdata")


## debug(fetch_dataset)
d <- fetch_dataset(dataset = "WS_CBPOL_csv_flat.zip",
                   dest.dir = "~/Downloads/BISdata",
                   return.class = "zoo",
                   frequency = "daily")

rates <- na.locf(d)

d <- fetch_dataset(dataset = "WS_LONG_CPI_csv_flat.zip",
                   dest.dir = "~/Downloads/BISdata",
                   return.class = "zoo",
                   frequency = "monthly")

cpi <- na.locf(d)


area <- "CH: Switzerland"

area <- "US: United States"
plotseries(window(rates[, area],
                  start = as.Date("1960-1-1")),
           y.labels.at.remove = NA,
           ylim = c(-1, 9), col = "darkgreen", lwd = 2)

plotseries(window(cpi[, area],
                  start = as.Date("1960-1-1")),
           y.labels.at.remove = NA, lines = TRUE,
           col = "blue")



## plot(na.locf(d[, area]), ylim = c(-2, 5))
## plot(na.locf(d[, "US: United States"]))

plotseries(window(cpi[, area],
                  start = as.Date("1960-1-1")),
           y.labels.at.remove = NA, lines = TRUE,
           col = "blue")
