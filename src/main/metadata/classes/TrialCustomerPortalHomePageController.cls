public class TrialCustomerPortalHomePageController {
   
   User loggedInUser = [Select id,contactId,Contact.AccountId from User where id = :UserInfo.getUserId()];
   
   public List<Asset> MyRegisteredProducts {get; set;}
   public List<Case> MyRecentCases {get; set;}
   public List<Solution> TopSolutions {get; set;}
   public List<Idea> PopularIdeas {get; set;}
   
   public String sortField1 {get; set;}
   public String previousSortField1 {get; set;}
   public String sortField2 {get; set;}
   public String previousSortField2 {get; set;}
   public String sortField3 {get; set;}
   public String previousSortField3 {get; set;}
   public String sortField4 {get; set;}
   public String previousSortField4 {get; set;}  
   public static string ascString='asc';
   public static string descString='desc';
   
            
   public TrialCustomerPortalHomePageController() {
        
        MyRegisteredProducts = [select id,Name,SerialNumber,InstallDate,UsageEndDate,Status,CreatedById,createddate
                                from Asset 
                                where ContactId = :loggedInUser.ContactId 
                                order by SerialNumber desc limit 3];
        
        MyRecentCases = [select id,CaseNumber,Subject,Status,LastModifiedDate,CreatedById
                         from Case 
                         where ContactId = :loggedInUser.ContactId 
                         order by LastModifiedDate desc limit 3];
        
        TopSolutions = [select id,SolutionName,TimesUsed,LastModifiedDate,CreatedById 
                        from Solution 
                        order by TimesUsed desc limit 3];
                           
        PopularIdeas = [select id,Title,Categories,VoteTotal,CreatedById,lastmodifiedbyid
                        from Idea 
                        order by VoteTotal desc limit 3];
   }
   
    public void SortProducts(){
        system.debug('@@@@ MyRegisteredProducts'+MyRegisteredProducts);
        String order = ascString;
        if(previousSortField1 == sortField1){
            order = descString;
            previousSortField1 = null;
        }else{
            previousSortField1 = sortField1;
        }
       system.debug('@@@@ MyRegisteredProducts1'+MyRegisteredProducts);
        superSort.sortList(MyRegisteredProducts,sortField1,order);
    } 
     public void SortCases(){
       String order = ascString;
        if(previousSortField2 == sortField2){
            order = descString;
            previousSortField2 = null;
        }else{
            previousSortField2 = sortField2;
        }
        superSort.sortList(MyRecentCases,sortField2,order);
    } 
    public void SortSolutions(){
        String order = ascString;
        if(previousSortField3 == sortField3){
            order =descString;
            previousSortField3 = null;
        }else{
            previousSortField3 = sortField3;
        }
                                     
        superSort.sortList(TopSolutions,sortField3,order);
    }
    public void SortIdeas(){
        String order = ascString;
        if(previousSortField4 == sortField4){
            order = descString;
            previousSortField4 = null;
        }else{
            previousSortField4 = sortField4;
        }
        superSort.sortList(PopularIdeas,sortField4,order);
    } 
   
}