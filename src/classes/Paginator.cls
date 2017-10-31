/*********************************************************************************************************
Description  : Helper class that is used for custom pagination of objects
***********************************************************************************************************/
public with sharing class Paginator {
    
    /************************************************
     VARIABLES
    **************************************************/
    private final Integer RESULTS_PER_PAGE;
    public Integer totalResults {set; get;}
    public Integer currentPage {set; get;}
    public Integer totalPage {set; get;}
    private Integer showingFrom;
    private Integer showingTo;
    private List<List<sObject>> allResults = new List<List<sObject>>();
    
    //Method created to use paging with list
    public Paginator() {}
    public Paginator(Integer ppResults, List<sObject> resultLst){
      
      RESULTS_PER_PAGE = ppResults;
      totalResults = 0;
      allResults.add(resultLst);
      totalResults = totalResults + resultLst.size();
      init(); 
    }
    
    public void init(List<sObject> resultLst){
      
      totalResults = 0;
      allResults.add(resultLst);
      totalResults = totalResults + resultLst.size();
      init();
    }
    
    //Initialize variables at call of constructor
    private void init(){
        currentPage = 1;
        totalPage = totalResults / RESULTS_PER_PAGE ;
        if (totalPage * RESULTS_PER_PAGE < totalResults){
          totalPage++;
        }
        isNextPageAvailable = currentPage < totalPage ?  true : false;
        isPreviousPageAvailable = false;
    }
      
    //Method to show start indexing of record on current page  
    public Integer getShowingFrom(){
       showingFrom = (currentPage * RESULTS_PER_PAGE ) - RESULTS_PER_PAGE + 1;
       return showingFrom;
    }
    
    //Method to show end indexing of record on current page
    public Integer getShowingTo(){
      showingTo = currentPage * RESULTS_PER_PAGE ;
      if (totalResults < showingTo){
        showingTo = totalResults;
      }
      return showingTo;
    }
          
    //Method to return list of records on current page
    public List<sObject> getPage(Integer pageNo){
        sObject[] selectedResult =  new sObject[RESULTS_PER_PAGE];
        Integer endTo = RESULTS_PER_PAGE * pageNo;
        Integer startFrom = endTo - RESULTS_PER_PAGE;
        Integer currentRecordNo = 0;
        Integer resultIndex = 0;
        Integer recordIndex = -1;
        for (sObject[] recordBatch:allResults){
            currentRecordNo = currentRecordNo + recordBatch.size();
            if (currentRecordNo >= startFrom ){
                for (sObject record:recordBatch){
                    recordIndex++;
                    if (recordIndex >= startFrom && recordIndex <= endTo && resultIndex<RESULTS_PER_PAGE){
                        selectedResult[resultIndex] = record ;
                        resultIndex++ ;
                    }else if (resultIndex == RESULTS_PER_PAGE){
                        break;
                    }
                }
           }else{
                recordIndex += recordBatch.size(); 
                if (resultIndex == RESULTS_PER_PAGE){
                    break;
                }
            }
        }
      return selectedResult;
    } 
      
  //Method to return First page records
  public List<sObject> getFirstPage(){
    currentPage = 1;
    updateNavigationStatus();
    return getPage(1);
  }
  
  //Method to return Last page records
  public List<sObject> getLastPage(){
    currentPage = totalPage;
    updateNavigationStatus();
    return getPage(totalPage);
  }
      
  //Method to update boolean values for next and previous page
  public void updateNavigationStatus(){
    if (totalPage >1){
      isNextPageAvailable = currentPage < totalPage ? true : false;
      isPreviousPageAvailable = currentPage > 1 ? true : false;
    }else{
      isNextPageAvailable = false;
      isPreviousPageAvailable = false;
    }
  }  
      
  public boolean isNextPageAvailable {set; get;}
  
  //Method to return next page records
  public List<sObject> getNextPage(){
    updateNavigationStatus();
    if (isNextPageAvailable){
      currentPage ++;
    }
    updateNavigationStatus();
    return getPage(currentPage);
  }
  
  public boolean isPreviousPageAvailable {set; get;}
  
  //Method to return Previous page records
  public List<sObject> getPreviousPage(){
    updateNavigationStatus();
    if (isPreviousPageAvailable){
      currentPage --;
    }
    updateNavigationStatus();
    
    return getPage(currentPage);
  }
}