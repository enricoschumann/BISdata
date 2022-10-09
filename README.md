# BISdata

Functions for downloading data from the Bank for
International Settlements (BIS;
<https://www.bis.org/>) in Basel.
Supported are only full datasets in (typically) CSV
format.  The package is lightweight and without
dependencies; suggested packages are used only if data
is to be transformed into particular data structures,
for instance into 'zoo' objects. Downloaded data can
optionally be cached, to avoid repeated downloads of
the same files.

## Installation

To install the package from a running R session, type:

    install.packages('BISdata',
                     repos = c('http://enricoschumann.net/R',
                               getOption('repos')))


or clone/build the repository's latest version.
