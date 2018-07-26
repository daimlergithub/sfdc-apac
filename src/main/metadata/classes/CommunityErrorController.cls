public  class CommunityErrorController {
    //Variable Declaration
    public String failingPageResponse { get; set; }
    public String japanesePageResponse { get; set; }

    public PageReference PageLevelAction()
    {
        failingPageResponse = Site.getErrorDescription();
        
        
        if(failingPageResponse.startsWithIgnoreCase('Maximum view state size limit (135KB) exceeded') ){
        
            japanesePageResponse ='検索結果が多すぎます。検索条件を追加してくだ';
            
        
        }
        return null;
    }
}