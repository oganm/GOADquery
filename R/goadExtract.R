goadExtract = function(){
    
    size = 40
    while(TRUE){
        url = paste0('http://bioinf.nl:8080/GOAD2/databaseSelectServlet?comparisonID=on&fold_change=ALL&p_value=0&comparison_ids=', size)
        site = RCurl::getURL(url)
        if (grepl('STATUS 500',site)){
            break
        }
        size = size +1
    }
    size = size -1
    
    datasets = vector(mode = 'list', length = size)
    
    for (id in 1:size){
        url = paste0('http://bioinf.nl:8080/GOAD2/databaseSelectServlet?comparisonID=on&fold_change=ALL&p_value=0&comparison_ids=', id)
        site = RCurl::getURL(url)
        if (grepl('HTTP Status 500',site)){
            break
        }
        relevant = stringr::str_extract(site,'geneTable.*?\n.*?\n.*?\n.*?\n.*')
        relevant = unlist(strsplit(relevant,split='\n'))
        Comparison = stringr::str_extract(relevant[3], stringr::regex('(?<=>).*?(?=<)'))
        Author = stringr::str_extract(relevant[5], stringr::regex('(?<=h4>).*?(?= \\()'))
        Paper = stringr::str_extract(relevant[4], stringr::regex('(?<=h4>).*?(?= <)'))
        Year = stringr::str_extract(relevant[5], stringr::regex('(?<=\\().*?(?=\\))'))
        datasets[[id]] = c(Comparison = Comparison,ID = id, Paper = Paper, Author = Author,Year = Year)
    }
    
    datasets = t(as.data.frame(datasets))
    datasets = as.data.frame(datasets,stringsAsFactors = F)
    datasets$ID = as.numeric(datasets$ID)
    datasets$Year = as.numeric(datasets$Year)
    
    
    rownames(datasets) = NULL
    GOADdatasets = datasets
    save(GOADdatasets,file = 'data/GOADdatasets.rda')
    write.table(datasets,file = 'data-raw/GOADdatasets.tsv',sep='\t', row.names = F)
    # dataFile = file('GOAD/datasets.md')
    # writeLines( kable(datasets), dataFile)
    # close(dataFile)
    
}