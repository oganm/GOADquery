#' Get differentially expressed genes in GOAD datasets
#' @description Acquires differentially expressed genes in chosen GOAD datasets. Datasets are represented 
#' as ids in the GOAD database. To see which id refers to which dataset see GOADdatasets table
#' @param ids GOAD ids of the datasets. To see which id refers to which dataset see GOADdatasets table
#' @param p p value threshold for selection. A threshold of 1 can be used to axtract all genes in the platforms
#' @param foldChange direction of fold change. 
#' @export
goadDifGenes = function(ids, p,foldChange=c('ALL','UP','DOWN')){
    foldChange = match.arg(foldChange)
    geneList = lapply(ids, function(id){
        url = paste0("http://bioinf.nl:8080/GOAD2/databaseSelectServlet?comparisonID=on&fold_change=", 
                     foldChange, 
                     '&p_value=',p,
                     '&comparison_ids=',id)

        site = RCurl::getURL(url)
        
        list = stringr::str_extract(site, stringr::regex('(?<=(var vennData = )).*') )
        # separate components
        list = unlist(strsplit(unlist(list), '([}]|[\"]),([\"]|[{])'))
        # find group names and locations
        groupHeads = grep('name',list)
        groupNames = stringr::str_extract(list[groupHeads],stringr::regex('(?<=:[\"]).*'))
        # some cleaning
        list[grep('data',list)] = stringr::str_extract(list[grep('data',list)], stringr::regex('(?<=:\\[\\").*'))
        list[grep('}|[]]',list)] =  stringr::str_extract(list[grep('}|[]]',list)], stringr::regex('^.*?(?=[\"])'))
        list[1] = groupNames
        return(list)
    })
    
    groupNames = sapply(geneList,function(x){x[1]})
    geneList = lapply(geneList, function(x){x[-1]})
    names(geneList) = groupNames
    return(geneList)
}




#' List of datasets on GOAD. 
#' 
#' @name GOADdatasets
#' @keywords GOADdatasets
NULL