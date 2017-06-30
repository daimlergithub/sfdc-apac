/**
    Purpose: creates new vehicle record    
    created: sriram kalluri
    Date   : 11/18/2015
*/

public with sharing class VehicleEditExtension {
    
    public String recordType {set;get;} 
    public boolean profileav{set;get;}
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
    public static Id vehicleId;
    public String recrdType {get;set;} 
    private ApexPages.StandardController stdController;
    public String type {get;set;}
    Map<String,Set<String>> brandClassMap = new Map<String, Set<String>>();
     Map<String,Set<String>> classModelMap = new Map<String, Set<String>>(); 
        Map<String,Set<String>> modelRangeMap = new Map<String, Set<String>>();
        Map<String,Set<String>> rangeMpMap = new Map<String, Set<String>>();
        Map<String,Set<String>> rangeVgMap = new Map<String, Set<String>>();
        Map<String,Set<String>> rangeSteeringMap = new Map<String, Set<String>>();
        Map<String,Set<String>> brandCompitiorModelMap = new Map<String, Set<String>>();
        List<Map<String, Set<String>>> finalMap = new List<Map<String, Set<String>>>();   
        Set<String> tempSet = new Set<String>();
        

    /*Constructor Method*/
    public VehicleEditExtension(ApexPages.StandardController stdController) {
       this.vehicle= (Vehicle__c)stdController.getRecord();
           
           
             vehicleId= ApexPages.currentPage().getParameters().get('id');
         
           
            vehicle =[SELECT id,Name,UsVIN__c,Brand__c,EuroVIN__c,Competitor_Brand__c,Competitor_Model__c,Model_Description__c,New_Used__c,Related_contact__c,Finance_Method__c,Related_From__c,Related_To__c,Portal_Vehicle_ID__c,InsuranceExpiryDate__c,MOT_Expired_Date__c,Vehicle_Role__c,FirstRegistrationDate__c,Transmission__c,RegistrationNo__c,System_Data_Source__c,VehicleStatus__c,ProductionDate__c,NextServiceDate__c,NextInspectionDate__c,recordtypeid,recordtype.name,Class__c,Model__c,Range__c,Modification_Package__c,Vehicle_Group__c,BaumusterEx__c,OptionCode__c,Colour__c,EngineNumber__c,Trim__c,CurrentMileage__c,CylinderCapacity__c,Fuel__c,Height__c,Length__c,Width__c,Weight__c,ModelYear__c,National_Model__c,VehicleAge__c,Product_Model__c,Category_Code__c FROM Vehicle__c Where id =:vehicleId limit 1];
            system.debug('vehicleeeeeeeeee'+vehicle);
            recrdType=vehicle.recordtype.name;
            if(recrdType == 'MB'){
            type='Own Sellable';
            }else
            {
             type='Competitor';
            }
           
           brand=vehicle.Brand__c;
           class1=vehicle.Class__c;
           model=vehicle.Model__c;
           range=Vehicle.Range__c;
           modPackage=vehicle.Modification_Package__c;
           VG=vehicle.Vehicle_Group__c;
           steering=vehicle.BaumusterEx__c;
           compBrand=vehicle.Competitor_Brand__c;
           compModel=vehicle.Competitor_Model__c;
           brandClassMap = new Map<String, Set<String>>();
           classModelMap = new Map<String, Set<String>>(); 
           modelRangeMap = new Map<String, Set<String>>();
           rangeMpMap = new Map<String, Set<String>>();
           rangeVgMap = new Map<String, Set<String>>();
           rangeSteeringMap = new Map<String, Set<String>>();
            brandCompitiorModelMap = new Map<String, Set<String>>();
     
         Id profileId = UserInfo.getProfileId();
         String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
         system.debug('Profile Name'+profileName);
         if(profileName.contains('Japan Dealer'))
         {
           profileav=true;
         }else{
            profileav=false;
         }
         
         if(profileav == true && recrdType == 'MB'){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient Access To Update MB')); 
         }
    }
    
     
    
    public List<SelectOption> getbrands()
    {
        List<SelectOption> options = new List<SelectOption>();
        set<string> brandit=new set<string>();
        
         for (Car_Model__c m :[Select Brand__c,Series__c,Name,Range__c,Mod_Pack__c,Vehicle_Group__c,Steering__c FROM Car_Model__c WHERE Status__c =:type])
         {
          
          brandit.add(m.Brand__c); 
         }
          for(String brands:brandit){
          
          options.add(new SelectOption(brands,brands));
          
          }
          system.debug('optionssssss'+options.size());
        return options;
    } 
    
      
    
       
     public List<SelectOption> getclasses()
    {
        List<SelectOption> options = new List<SelectOption>();
        system.debug('brand'+brand);
        set<string> brandit=new set<string>();
        if(brand!=null){
        
         options.add(new SelectOption('',''));
         for (Car_Model__c m : [Select Brand__c,Series__c,Name,Range__c,Mod_Pack__c,Vehicle_Group__c,Steering__c FROM Car_Model__c WHERE Status__c =:type and Brand__c=:brand] )
         {
          brandit.add(m.Series__c); 
         }
          for(String series:brandit){
          
          options.add(new SelectOption(series,series));
          
          }
         }
         system.debug('optionssssss'+options.size());
        return options;
    }     
    public List<SelectOption> getmodels()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(class1!=null){
        
          options.add(new SelectOption('',''));
         
         for (Car_Model__c m : [Select Brand__c,Series__c,Name,Range__c,Mod_Pack__c,Vehicle_Group__c,Steering__c FROM Car_Model__c WHERE Status__c =:type and Series__c=:class1 and Brand__c=:brand ] )
         {
          system.debug('m'+m);
          options.add(new SelectOption(m.Name,m.Name));
         }
         }
         system.debug('optionssssss'+options.size());
        return options;
    }     
    
     public List<SelectOption> getranges()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(model!=null){
         
          options.add(new SelectOption('',''));
          
           
         for (Car_Model__c m : [Select Brand__c,Series__c,Name,Range__c,Mod_Pack__c,Vehicle_Group__c,Steering__c FROM Car_Model__c WHERE Status__c =:type and Name=:model] )
         {
          system.debug('m'+m);
          if(m.Range__c!=null){
          options.add(new SelectOption(m.Range__c,m.Range__c));
          }
         }
         }
         system.debug('optionssssss'+options.size());
        return options;
    }     
    
     public List<SelectOption> getmodeldesc()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(range!=null){
         options.add(new SelectOption('',''));
         
           
         for (Car_Model__c m : [Select Brand__c,Series__c,Name,Range__c,Mod_Pack__c,Vehicle_Group__c,Steering__c FROM Car_Model__c WHERE Status__c =:type and Range__c=:range] )
         {
          system.debug('m'+m);
          if(m.Mod_Pack__c!=null){
          options.add(new SelectOption(m.Mod_Pack__c,m.Mod_Pack__c));
          }
         }
         }
         system.debug('optionssssss'+options.size());
        return options;
    }     
    public List<SelectOption> getvgs()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(modPackage!=null){
        
         options.add(new SelectOption('',''));
         for (Car_Model__c m : [Select Brand__c,Series__c,Name,Range__c,Mod_Pack__c,Vehicle_Group__c,Steering__c FROM Car_Model__c WHERE Status__c =:type and Mod_Pack__c=:modPackage] )
         {
          system.debug('m'+m);
          if(m.Vehicle_Group__c!=null){
          options.add(new SelectOption(m.Vehicle_Group__c,m.Vehicle_Group__c));
          }
         }
         }
         system.debug('optionssssss'+options.size());
        return options;
    }     
     
      
     public List<SelectOption> getsteers()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(VG!=null){
         
        options.add(new SelectOption('',''));
          
         for (Car_Model__c m : [Select Brand__c,Series__c,Name,Range__c,Mod_Pack__c,Vehicle_Group__c,Steering__c FROM Car_Model__c WHERE Status__c =:type and Vehicle_Group__c=:VG limit 1000] )
         {
          system.debug('m'+m);
          if(m.Steering__c !=null){
          options.add(new SelectOption(m.Steering__c,m.Steering__c ));
          }
         }
         }
         system.debug('optionssssss'+options.size());
        return options;
    }      
     
     public List<SelectOption> getcompbrands()
    {
        List<SelectOption> options = new List<SelectOption>();
         set<string> brandit=new set<string>();
           
         for (Car_Model__c m : [Select Brand__c,Series__c,Name,Range__c,Mod_Pack__c,Vehicle_Group__c,Steering__c FROM Car_Model__c WHERE Status__c =:type] )
         {
          brandit.add(m.Brand__c); 
         }
          for(String brands:brandit){
          
          options.add(new SelectOption(brands,brands));
          
          }
        return options;
    } 
    public List<SelectOption> getcompmodels()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(compBrand!=null){
       
         options.add(new SelectOption('',''));
        
         for (Car_Model__c m : [Select Brand__c,Series__c,Name,Range__c,Mod_Pack__c,Vehicle_Group__c,Steering__c FROM Car_Model__c WHERE Status__c =:type and Brand__c=:compBrand] )
         {
          
          options.add(new SelectOption(m.Name,m.Name));
         }
         system.debug('options'+options);
         }
        return options;
    } 
     
     public PageReference saveveh()
    {
        
        if (!Schema.sObjectType.Vehicle__c.isUpdateable()){
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'InsufficientAccessToUpdate')); 
                     return null;
                   }
                else{
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
                vehicle.Brand__c=brand;
                vehicle.Competitor_Brand__c=compBrand;
                vehicle.Class__c=class1;
                vehicle.Model__c=model;
                vehicle.Range__c=range;
                vehicle.Modification_Package__c=modPackage;
                vehicle.Vehicle_Group__c=VG;
                vehicle.BaumusterEx__c=steering;
                vehicle.Competitor_Model__c=compModel;
               
                 if(recrdType == UtilConstant.MB){
            list<Car_Model__c> carModelId = [select id from Car_Model__c where Brand__c=:brand and Series__c =:class1 and Name =:model and Range__c=:range and Mod_Pack__c=:modPackage and Status__c='Own Sellable' order by CreatedDate ];
            if(!carModelId.isEmpty()){
                vehicle.Car_Model__c=carModelId[0].id;
                vehicle.Model_Description__c=model;
            }
        }
        else if(recrdType == UtilConstant.Competitor){
            list<Car_Model__c> carModelId = [select id from Car_Model__c where Brand__c=:compBrand and Name =:compModel and Status__c='Competitor' order by CreatedDate ];                   
            if(!carModelId.isEmpty()){
                vehicle.Car_Model__c=carModelId[0].id;
                vehicle.Model_Description__c=compModel;
                 vehicle.Brand__c=compBrand;
            }
        }
        
                try{  
                    update vehicle;                       
                  }catch(DmlException  e){
                   string error=e.getMessage();
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,error));
                   System.debug('Exception encountered...' +error);
                }
        
                nextPage = new PageReference('/' + vehicle.Id);
                nextPage.setRedirect(true);
                system.debug('redirecturl'+nextPage);
              }
         
        
        return nextPage;
    }
    
       
   
    public PageReference saveAndNew()
    {
           if (!Schema.sObjectType.Vehicle__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'InsufficientAccessToUpdate')); 
                     return null;
                   }
                else{
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
                vehicle.Brand__c=brand;
                vehicle.Class__c=class1;
                vehicle.Model__c=model;
                vehicle.Range__c=range;
                vehicle.Modification_Package__c=modPackage;
                vehicle.Vehicle_Group__c=VG;
                vehicle.BaumusterEx__c=steering;
                vehicle.Competitor_Model__c=compModel;
                vehicle.Competitor_Brand__c=compBrand;
                 if(recrdType == UtilConstant.MB){
            list<Car_Model__c> carModelId = [select id from Car_Model__c where Brand__c=:brand and Series__c =:class1 and Name =:model and Range__c=:range and Mod_Pack__c=:modPackage and Status__c='Own Sellable' order by CreatedDate ];
            if(!carModelId.isEmpty()){
                vehicle.Car_Model__c=carModelId[0].id;
                vehicle.Model_Description__c=model;
            }
        }
        else if(recrdType == UtilConstant.Competitor){
            list<Car_Model__c> carModelId = [select id from Car_Model__c where Brand__c=:compBrand and Name =:compModel and Status__c='Competitor' order by CreatedDate ];                   
            if(!carModelId.isEmpty()){
                vehicle.Car_Model__c=carModelId[0].id;
                vehicle.Model_Description__c=compModel;
            }
        }
                try
                {
                 update vehicle;
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
                   
        return nextPage;
            
    }

   
   
    
    
    public PageReference Cancel()
    {     system.debug('profileav-------- '+profileav);
          string returnId = ApexPages.currentPage().getParameters().get('Id');
          
        if(returnId!=null && profileav == false){
          nextPage = new PageReference(System.Url.getSalesforceBaseURL().toExternalForm()+'/'+returnId);
        }
        else if(returnId!=null && profileav == true){
         nextPage = new PageReference(System.Url.getSalesforceBaseURL().toExternalForm()+'/MBJapan/'+returnId);
        }
        else{
            string returnId1=Vehicle__c.sObjectType.getDescribe().getKeyprefix();

            nextPage = new PageReference(System.Url.getSalesforceBaseURL().toExternalForm()+'/'+returnId1+'/o');
        }
          nextPage.setRedirect(true);
          return nextPage;
    }
   
    
}