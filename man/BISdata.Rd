\name{BISdata}
\alias{fetch_dataset}
\alias{datasets}
\alias{BISdata}
\title{
  Download Data from the Bank for International Settlements (BIS)
}
\description{

  Download datasets from the Bank for International
  Settlements (\acronym{BIS}) and convert to data frames.

}
\usage{
fetch_dataset(dest.dir, dataset,
              bis.url = "https://data.bis.org/static/bulk/",
              exdir = tempdir(),
              return.class = NULL,
              frequency = NULL,
              \dots,
              header = TRUE,
              sep = ",",
              stringsAsFactors = FALSE,
              check.names = FALSE,
              na.strings = "",
              quote = "\"",
              fill = TRUE)

datasets(url = "https://data.bis.org/bulkdownload", \dots)
}
\arguments{
  \item{dest.dir}{
    file path: where to store the files?
  }
  \item{dataset}{
    the name of the file
  }
  \item{bis.url}{
    the base \acronym{url}
  }
  \item{url}{
    the \acronym{url} from which to fetch information about the datasets
  }
  \item{exdir}{
    file path: where to unzip?
  }
  \item{return.class}{\code{NULL} or character: currently, only
    \code{\link[zoo]{zoo}} is supported
  }
  \item{frequency}{
    string, or nothing (\code{NULL})
  }
  \item{\dots}{
    passed on to \code{\link{read.table}}
  }
  \item{header, sep, stringsAsFactors, check.names,
        na.strings, quote, fill}{
    passed on to \code{\link{read.table}}
  }
}
\details{

  Supported are full datasets (typically) in \acronym{CSV}
  format.  Downloaded data can optionally be cached, to
  avoid repeated downloads of the same files.

  The default download fetches the data and puts them into
  a \code{\link{data.frame}}.  If \code{return.class} is
  not \code{NULL}, \code{fetch_dataset} selects/transforms
  data; but this is only supported for few datasets.

  If the download fails with an error, then both
  functions will return \code{NULL}.  For
  \code{fetch_dataset}, if the download failed with a
  warning from \code{\link{download.file}}, then the
  function will evaluate to the return value of
  \code{\link{download.file}}.


}
\value{
  typically a \code{\link{data.frame}}.

  \code{bis_datasets} returns a \code{\link{data.frame}}
    with three columns:
    \item{filename}{the dataset filename}
    \item{description}{a brief description of the dataset}
    \item{updated}{if available, the date when the
      dataset was last updated}

}
\author{
  Enrico Schumann
}
\examples{
\donttest{
## (Internet connection required)
datasets()
bis.data <- fetch_dataset(dest.dir = tempdir(),
                          "WS_CBPOL_csv_col.zip")
}}
