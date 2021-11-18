\name{fetch_csv}
\alias{fetch_csv}
\alias{csv_datasets}
\alias{BISdata}
\title{
  Download Data from the Bank for International Settlements (BIS)
}
\description{

  Download datasets from the Bank for International
  Settlements (BIS) and convert to data frames.

}
\usage{
fetch_csv(dest.dir, dataset, bis.url = "https://www.bis.org/statistics/", ...)
csv_datasets(url = "https://www.bis.org/statistics/full_data_sets.htm", ...)

}
\arguments{
  \item{dest.dir}{
    a file path
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
  \item{\dots}{
    currently not used
}
}
\details{

  Supported are only full datasets in \acronym{CSV}
  format.  Downloaded data may optionally be cached, to
  avoid repeated downloads of the same files.

}
\value{
  typically a \code{\link{data.frame}}
}
\author{
  Enrico Schumann
}
%% \seealso{
%%   package
%% }
\examples{
\donttest{
csv_datasets()
}

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
