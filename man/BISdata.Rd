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
              bis.url = "https://www.bis.org/statistics/",
              exdir = tempdir(),
              return.class = NULL,
              \dots)
datasets(url = "https://www.bis.org/statistics/full_data_sets.htm", \dots)

}
\arguments{
  \item{dest.dir}{
    file path: where to store the files?
  }
  \item{dataset}{
    the name of the file
  }
  \item{bis.url}{
    the base url
  }
  \item{url}{
    the url from which to fetch information about the datasets
  }
  \item{exdir}{
    file path: where to unzip?
  }

  \item{return.class}{\code{NULL} or character: currently, only
    \code{\link[zoo]{zoo}} is supported

  }
  \item{\dots}{
    currently not used
  }
}
\details{

  Supported are  full datasets (typically) in \acronym{CSV}
  format.  Downloaded data may optionally be cached, to
  avoid repeated downloads of the same files.

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
%% \seealso{
%%   package
%% }
\examples{
\donttest{
datasets()
bis.data <- fetch_dataset(tempdir(),
                          "full_bis_total_credit_csv.zip")
}

}
