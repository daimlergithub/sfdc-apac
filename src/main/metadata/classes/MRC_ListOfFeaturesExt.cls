/*******************************************************************************************
* Class:                            MRC_ListOfFeaturesExt
* Description:                      This class is used to display a table of all features(permission sets/custom permissions/functionality)
                                    linked to all existing persona
* ------------------------------------------------------------------------------------------
* Date          Name                   Modification Description
* 20/4/2017     Harshit Kabra           Modified  

===========================================================================================*/
public class MRC_ListOfFeaturesExt
{
   public boolean PScheck{get; set;}
   public boolean CPcheck{get; set;}
   public List<FeatureDetails> FeatureList {get; set;} 
   public List<Persona__c> majList {get; set;}
   public String SMkt{get; set;}
   public String SProf{get; set;}
   public String SActive{get; set;}
   public String SPersona{get; set;}
   public String SFunctionality{get; set;} 
   public String SFeatureType{get; set;}
   public boolean check; 
   public String query1;
   
   public integer totalno = 0; 
   public integer OffsetSize = 0;
   public integer LimitSize= 2;
   public boolean Flag3{get;set;} 
   public boolean Flag4{get;set;}
   public boolean flag{get;set;}
    
    
   public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Select--'));
        options.add(new SelectOption('True','True'));
        options.add(new SelectOption('False','False'));
       
        return options;
    }
    
    public List<SelectOption> getfeatureTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('ABC','--Select--'));
        options.add(new SelectOption('PS','Permission Sets'));
        options.add(new SelectOption('CP','Custom permissions'));
       
        return options;
    }
 public MRC_ListOfFeaturesExt(ApexPages.StandardController controller) 
    { flag=false;
      flag3=false;
      flag4=false;  
      PScheck=true;
      CPcheck=true;
      query1='Select PersonaName__c,Market__c,Active__c,Functionality_Access__r.Module_Name__c,Functionality_Access__r.PermissionSet_Ids__c,Functionality_Access__r.Permission_Sets__c ,Profiles__c from Persona__c'; 
      check=false; 
     getFeatureList();
             
     }
      
  public void getFeatureList()
  {  
   try{
       
       totalno=0;
       flag4=true;
       if(flag3==false) OffsetSize=0;
      majList=new List<Persona__c>();
      FeatureList=new List<FeatureDetails>();
      //majList=[Select Persona__c,Market__c,Active__c,Functionality_Access__r.Module_Name__c,Functionality_Access__r.PermissionSet_Ids__c,Functionality_Access__r.Permission_Sets__c ,Profiles__c from Persona__c];
      list<Persona__c>majList1=new List<Persona__c>();
      majList1= database.query(query1);
      totalno = majList1.size();
      
      query1+=' LIMIT '+LimitSize +' OFFSET '+OffsetSize;
       
      majList=database.query(query1);
      for(Persona__c mj : majList){
        FeatureDetails fd=new FeatureDetails();
        fd.persona=mj.PersonaName__c;
        fd.functionality=mj.Functionality_Access__r.Module_Name__c;
        fd.Uprofile=mj.Profiles__c;
        fd.Market=mj.Market__c;
        fd.Active=mj.Active__c;  
        if(mj.Functionality_Access__r.PermissionSet_Ids__c != null)
        {
           fd.UpermissionSetIDs=mj.Functionality_Access__r.PermissionSet_Ids__c.split(';');
           fd.UpermissionSetNames=mj.Functionality_Access__r.Permission_Sets__c.split(';') ;
        }
        if(fd.UpermissionSetIDs!= null)
        {
           fd.Ucustompermissions=[SELECT  DeveloperName FROM CustomPermission where id IN (SELECT SetupEntityId from SetupEntityAccess WHERE SetupEntityType='CustomPermission' AND ParentId In : fd.UpermissionSetIDs ) ];
        }
       // fd.FeatureMap = new Map<String,String>();
       
        FeatureList.add(fd); 
        
        
      } 
    if(FeatureList.size()>0)
        {flag=true;}
        else
        flag=false;
   
   }
      catch(Exception e)
      {
         CustomLogUtil.CustomLoggingEntry('Error Occured' + e.getmessage() +'-- '+e.getlinenumber());
      }
 
 }
 
//method to provide search filters
  public void searchFeatures(){
      //String query1='';
      CPcheck=true;PScheck=true;
      if(SFeatureType.equals('PS')) CPcheck=false;
      if(SFeatureType.equals('CP')) PScheck=false;
      query1='Select PersonaName__c,Market__c,Active__c,Functionality_Access__r.Module_Name__c,Functionality_Access__r.PermissionSet_Ids__c,Functionality_Access__r.Permission_Sets__c ,Profiles__c from Persona__c'; 

      String whereCond='';
      if(SMkt!=null && SMkt!='')
            whereCond=whereCond+' where Market__c like \'%' + String.escapeSingleQuotes(SMkt) + '%\'';
      if(SActive!=null && SActive!='')
      {
          if(whereCond.length()>0)
             {
              whereCond=whereCond+' And Active__c = '+ String.escapeSingleQuotes(SActive);
             }
          else{
               whereCond=whereCond+' where Active__c = '+ String.escapeSingleQuotes(SActive) ;
              }
         
      }
      if(SPersona!=null && SPersona!='')
      {
          if(whereCond.length()>0)
             {
              whereCond=whereCond+' And PersonaName__c like \'%' + String.escapeSingleQuotes(SPersona) + '%\'';
             }
          else{
               whereCond=whereCond+' where PersonaName__c like \'%' + String.escapeSingleQuotes(SPersona) + '%\'';
              }
         
      }
      if(SFunctionality!=null && SFunctionality!='')
      {
          if(whereCond.length()>0)
             {
              whereCond=whereCond+' And Functionality__c like \'%' + String.escapeSingleQuotes(SFunctionality) + '%\'';
             }
          else{
               whereCond=whereCond+' where Functionality__c like \'%' + String.escapeSingleQuotes(SFunctionality) + '%\'';
              }
         
      }
      if(whereCond.length()>0 )
      {
          query1=(query1+whereCond);
          flag3=false;
      }
      
      //system.debug('query'+query1);
      getFeatureList();
        
         
    }      

    
    
  public class FeatureDetails
  { public String persona {get;set;}
    public Boolean active{get; set; }
    public String functionality {get;set;}
    public String  Uprofile {get;set;}
    public String Market{get; set;}
    public List<CustomPermission> Ucustompermissions {get;set;}
    List<String> UpermissionSetIDs {get;set;}
    public List<String> UpermissionSetNames{get;set;}
    //Map<String, String> FeatureMap {get; set;}
    
  }     

//pagination methods:

public Integer getPageNumber() {
Integer x=0;
if(offsetsize==100) x = offsetsize/LimitSize ;
else x = offsetsize/LimitSize +1 ;
return x;
}
     
     
public Integer getTotalPages() {
if (math.mod(totalno, limitSize) > 0) return totalno/limitSize + 1;
else return (totalno/limitSize);
}      
public void FirstPage()
{
OffsetSize = 0;
searchFeatures();

}
public void previous()
{
OffsetSize = OffsetSize - LimitSize;
flag3=true;
searchFeatures();

}public void next()
{
OffsetSize = OffsetSize + LimitSize;
flag3=true;
searchFeatures();

}public void LastPage()
{
OffsetSize = totalno - math.mod(totalno,LimitSize);
flag3=true;
searchFeatures();


}
public boolean getprev()
{
if(OffsetSize == 0)
return true;
else
return false;
}
public boolean getnxt()
{
if((OffsetSize + LimitSize) >= totalno)
return true;
else
return false;
}     
    

}