/**
    Purpose: creates new vehicle record    
    created: sriram kalluri
    Date   : 11/18/2015
*/

public with sharing class VehicleExtension {
    
    public String recordType {set;get;} 
    public boolean check{set;get;}
    public Vehicle__c vehicle{get;set;}
    public String brand{get;set;}
    public String class1{get;set;}
    public String model{get;set;}
    public String compBrand{get;set;}
    public String range{get;set;}
    public String modPackage{get;set;}
    public String VG{get;set;}
    public String steering{get;set;}
    public String compModel{get;set;}
    public PageReference nextPage;
    private ApexPages.StandardController stdController;
    
    // ***For Thailand*** Declaration Start
    public Id userId{get;set;}
    public Integer thailandUserCount;
    public boolean nonThaiUserLoggedIn{get;set;}
    // ***For Thailand*** Declaration End
    
    /*Constructor Method*/
    public VehicleExtension(ApexPages.StandardController stdController) {
        String type;
        check=true;
        
        // ***For Thailand*** Start
        nonThaiUserLoggedIn = true;
        // ***For Thailand*** End
        
        vehicle = (Vehicle__C)stdController.getRecord();
        
        // ***For Thailand*** Start
        
        userId=userinfo.getUserId();
        // thailandUserCount = [select id,name,Market__c,profile.name from user where Id=:userId and Market__c = 'TH' and ((profile.name LIKE 'Thailand %') or (Profile.name = 'System Administrator'))].size();
        thailandUserCount = [select id,name,Market__c,profile.name from user where Id=:userId and Market__c = 'TH'].size();
        if(thailandUserCount > 0 && (Apexpages.currentpage().getparameters().get('id')==Null)){
            System.debug('thailandUserCount value: '+thailandUserCount+' id: '+Apexpages.currentpage().getparameters().get('id'));
            nonThaiUserLoggedIn = false;
        }
        
        // ***For Thailand*** End
    }
       
    /**    
     * @Description : saves the record and redirects to record detail page
     * @author      : sriram kalluri
     * @Date        : 11/18/2015
     * @param       : Field values entered in vf page
     * @return      : redirects to record detail page
     * @see         : VehicleExtension
    **/     
    

     public PageReference saveVal()
    {
        
        if((recordType == UtilConstant.MB && (brand == UtilConstant.Question ))||(recordType == UtilConstant.Competitor && (compBrand == UtilConstant.Question ))){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Required_Information));
                return null;
                nextPage = null;
         }
        else{
               // Check if the user has create access on the Vehilce__c.Name field
                 if (!Schema.sObjectType.Vehicle__c.isCreateable()){
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.InsufficientAccessToCreate)); 
                     return null;
                   }
                else{
                try
                {
                save();
                }
                Catch(DmlException  e){
                    string error=e.getDMLMessage(0);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,error));
                    System.debug('Exception encountered in Save...' +error);  
                    return null; 
                }
                nextPage = new PageReference('/' + vehicle.Id);
                nextPage.setRedirect(true);
                system.debug('redirecturl'+nextPage);
            }
        }
        return nextPage;
    }
    
        /**    
     * @Description : saves the record and redirects to same vehicle create page
     * @author      : sriram kalluri
     * @Date        : 11/18/2015
     * @param       : Field values entered in vf page
     * @return      : redirects to create_vehicle page
     * @see         : VehicleExtension
    **/   
   
    public PageReference saveAndNew()
    {
          
        if((recordType == UtilConstant.MB && (brand == UtilConstant.Question))||(recordType == UtilConstant.Competitor && compBrand == UtilConstant.Question )){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Required_Information));
                nextPage = null;
         }
        else{   
               // Check if the user has create access on the vehicle field
            if (!Schema.sObjectType.Vehicle__c.isCreateable()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.InsufficientAccessToCreate)); 
                return null;
            }
            else{
                try{
                    save();
                }
                Catch(DmlException  e){
                    string error=e.getDMLMessage(0);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,error));
                    System.debug('Exception encountered in Save...' +error);  
                    return null; 
                }
                nextPage = new PageReference('/apex/Create_Vehicle');
                nextPage.setRedirect(true);
                system.debug('redirecturl'+nextPage);
            } 
        }            
        return nextPage;    
    }

     /**    
     * @Description : saves the vehicle record
     * @author      : sriram kalluri
     * @Date        : 12/1/2015
     * @param       : Field values entered in vf page 
     * @return      : nothing
     * @see         : VehicleExtension
    **/  
    
    public void save(){
        if(brand == UtilConstant.Question){
            brand=null;
        }
        if(class1 == UtilConstant.Question){
            class1=null;
        }
        if(model == UtilConstant.Question){
            model=null;
        }
        if(compBrand == UtilConstant.Question){
            compBrand=null;
        }
        if(range == UtilConstant.Question){
            range=null;
        }
        if(modPackage == UtilConstant.Question){
            modPackage=null;
        }
        if(VG == UtilConstant.Question){
            VG=null;
        }
        if(steering == UtilConstant.Question){
            steering=null;
        }
        if(compModel == UtilConstant.Question){
            compModel=null;
        }
        if(recordType == UtilConstant.MB){
            list<Car_Model__c> carModelId = [select id from Car_Model__c where Brand__c=:brand and Series__c =:class1 and Name =:model and Range__c=:range and Mod_Pack__c=:modPackage and Status__c='Own Sellable' order by CreatedDate ];
            if(!carModelId.isEmpty()){
                vehicle.Car_Model__c=carModelId[0].id;
                vehicle.Model_Description__c=model;
            }
        }
        else{
            list<Car_Model__c> carModelId = [select id from Car_Model__c where Brand__c=:compBrand and Name =:compModel and Status__c='Competitor' order by CreatedDate ];                   
            if(!carModelId.isEmpty()){
                vehicle.Car_Model__c=carModelId[0].id;
                vehicle.Model_Description__c=compModel;
            }
        }
        
        vehicle.RecordTypeId=Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        vehicle.Brand__c=brand;
        vehicle.Class__c=class1;
        vehicle.Model__c=model;
        vehicle.Competitor_Brand__c=compBrand;
        vehicle.Range__c=range;
        vehicle.Modification_Package__c=modPackage;
        vehicle.Vehicle_Group__c=VG;
        vehicle.BaumusterEx__c=steering;
        vehicle.Competitor_Model__c=compModel;
        
        //try{  
        insert vehicle;                       
        // }catch(DmlException  e){
        //   string error=e.getMessage();
        //   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,error));
        //   System.debug('Exception encountered...' +error);
        //}  
    }
    
     /**    
     * @Description : Redirects to Account record detail Page
     * @author      : sriram kalluri
     * @Date        : 12/1/2015
     * @return      : Account record detail Page URL
     * @see         : VehicleExtension
    **/  
    public PageReference Cancel()
    { 
          string returnId = ApexPages.currentPage().getParameters().get('accId');
        if(returnId!=null){
          nextPage = new PageReference(System.Url.getSalesforceBaseURL().toExternalForm()+'/'+returnId);
        }else{
            nextPage = new PageReference(System.Url.getSalesforceBaseURL().toExternalForm()+'/a04/o');
        }
          nextPage.setRedirect(true);
          return nextPage;
    }
   
    
    /**    
     * @Description : gets related map values based on Record Type
     * @author      : sriram kalluri
     * @Date        : 12/1/2015
     * @param       : Selected RecordType Value 
     * @return      : Relared values as Map
     * @see         : VehicleExtension
    **/  
    
    @RemoteAction
    public static List<Map<String, Set<String>>> getCarModelValues(String status_type){   
             
        String type;
        List<Car_Model__c> carModels;
        Map<String,Set<String>> brandClassMap = new Map<String, Set<String>>();
        Map<String,Set<String>> classModelMap = new Map<String, Set<String>>(); 
        Map<String,Set<String>> modelRangeMap = new Map<String, Set<String>>();
        Map<String,Set<String>> rangeMpMap = new Map<String, Set<String>>();
        Map<String,Set<String>> rangeVgMap = new Map<String, Set<String>>();
        Map<String,Set<String>> rangeSteeringMap = new Map<String, Set<String>>();
        Map<String,Set<String>> brandCompitiorModelMap = new Map<String, Set<String>>();
        List<Map<String, Set<String>>> finalMap = new List<Map<String, Set<String>>>();   
        Set<String> tempSet = new Set<String>();
        
        system.debug('status_type'+status_type);
        type=status_type;
        
        if(type==UtilConstant.MB){
            type='Own Sellable';
        }
                    
        carModels = [SELECT Brand__c,Series__c,Name,Range__c,Mod_Pack__c,Vehicle_Group__c,Steering__c FROM Car_Model__c Where Status__c =:type];
        
        for(Car_Model__c cm : carModels){
            
            //Create brand class map.
            tempSet = brandClassMap.get(cm.Brand__c);
            if(tempSet == null){
                brandClassMap.put(cm.Brand__c, new Set<String>{cm.Series__c});
            }else{
                tempSet.add(cm.Series__c);
            } 
        
             //Create Class model map.
            tempSet = classModelMap.get(cm.Brand__c+cm.Series__c);
            if(tempSet == null){
                classModelMap.put(cm.Brand__c+cm.Series__c, new Set<String>{cm.Name});
            }else{
                tempSet.add(cm.Name);
            }
            //Create model Range map.
           
            tempSet = modelRangeMap.get(cm.Brand__c+cm.Series__c+cm.Name);
            if(tempSet == null){
                modelRangeMap.put(cm.Brand__c+cm.Series__c+cm.Name, new Set<String>{cm.Range__c});
            }else{
                tempSet.add(cm.Range__c);
            }
        
         //Create  Range MP map.
           
            tempSet = rangeMpMap.get(cm.Brand__c+cm.Series__c+cm.Name+cm.Range__c);
            if(tempSet == null){
                rangeMpMap.put(cm.Brand__c+cm.Series__c+cm.Name+cm.Range__c, new Set<String>{cm.Mod_Pack__c});
            }else{
                tempSet.add(cm.Mod_Pack__c);
            }
        
         //Create  Range Vehicle group map.
           
            tempSet = rangeVgMap.get(cm.Brand__c+cm.Series__c+cm.Name+cm.Range__c);
            if(tempSet == null){
                rangeVgMap.put(cm.Brand__c+cm.Series__c+cm.Name+cm.Range__c, new Set<String>{cm.Vehicle_Group__c});
            }else{
                tempSet.add(cm.Vehicle_Group__c);
            }
        
        //Create  Range steering group map.
           
            tempSet = rangeSteeringMap.get(cm.Brand__c+cm.Series__c+cm.Name+cm.Range__c);
            if(tempSet == null){
                rangeSteeringMap.put(cm.Brand__c+cm.Series__c+cm.Name+cm.Range__c, new Set<String>{cm.Steering__c});
            }else{
                tempSet.add(cm.Steering__c);
            }
        
        //Create  Brand and Compitior Model group map.
           
            tempSet = brandCompitiorModelMap.get(cm.Brand__c);
            if(tempSet == null){
                brandCompitiorModelMap.put(cm.Brand__c, new Set<String>{cm.Name});
            }else{
                tempSet.add(cm.Name);
            }   
        }            
        
        finalMap.clear();
        finalMap.add(brandClassMap);
        finalMap.add(classModelMap);
        finalMap.add(modelRangeMap);
        finalMap.add(rangeMpMap);
        finalMap.add(rangeVgMap);
        finalMap.add(rangeSteeringMap);
        finalMap.add(brandCompitiorModelMap);
        
        system.debug('finalMap'+finalMap);
        
        return finalMap;
    }
    
}