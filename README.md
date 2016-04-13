#GOAD
Dealing with the [Glia Open Access Database](http://bioinf.nl:8080/GOAD/) that was recently [published](http://www.ncbi.nlm.nih.gov/pubmed/25808223) by Holtman et al. without an API.

Install via devtools
```
devtools::install_github('oganm/GOADquery')
```

* **goadDifGenes:** Given dataset ID(s), a p value treshold and differential expression direction, it extracts the sets of differentially expressed genes for chosen comparisons.
* **[GOADdatasets](data-raw/GOADdatasets.tsv):** Has a list of datasets avaliable on the database with their IDs.
* **GOADextract:** The code to generate the GOADdatasets object. Not exported on package installation.