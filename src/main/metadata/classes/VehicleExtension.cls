/**
    Purpose: creates new vehicle record    
    created: sriram kalluri
    Date   : 11/18/2015
*/

public with sharing class VehicleExtension {
    public Vehicle__c vehicle{get;set;}
    public String serialized_vehicleTypeMap {set;get;}
    public String brandClassMapping {get;set;}
    public String classModelMapping {get;set;}
    public String VehicleBrandClassMapping {get;set;}
    public List<VehicleBrandsAndClasses> vBrandsAndClasses {get;set;}
    public VehicleBrandsAndClasses vBC {get;set;}
    Map<String, Set<String>> brandClassMap {get;set;}
    Map<String, Set<String>> classModelMap {get;set;}
    public String enteredText1{get;set;}
    public String enteredText2{get;set;}
    public String enteredText3{get;set;}
    public PageReference nextPage;
    
   

    /*Constructor Method*/
    public VehicleExtension(ApexPages.StandardController controller) {
        
        vehicle = new Vehicle__c();
        List<Car_Model__c> carModels;
        serialized_vehicleTypeMap = JSON.serialize('');
        brandClassMap = new Map<String, Set<String>>();
        classModelMap = new Map<String, Set<String>>();
        
        try{
            
            /***************** CAR MODEL WRAPPER CLASS LOGIC : START ****************************/
            
            /*Query Car Model Records : INTERESETED VEHICLE*/
            carModels = [SELECT Brand__c,Model__c,Series__c FROM Car_Model__c Where Status__c = 'Own Sellable'];
            Set<String> tempSet = new Set<String>();
           
            for(Car_Model__c cm : carModels){
                //Create brand class map.
                tempSet = brandClassMap.get(cm.Brand__c);
                if(tempSet == null){
                    brandClassMap.put(cm.Brand__c, new Set<String>{cm.Series__c});
                }else{
                    tempSet.add(cm.Series__c);
                } 
                //Create Class model map.
                tempSet = classModelMap.get(cm.Series__c);
                if(tempSet == null){
                    classModelMap.put(cm.Series__c, new Set<String>{cm.Model__c});
                }else{
                    tempSet.add(cm.Model__c);
                }
            }           

           
            brandClassMapping = JSON.serialize(brandClassMap);
           
            
            /*Work on the Picklist values here */
            if (vBrandsAndClasses == null){
                vBrandsAndClasses = new List<vehicleBrandsAndClasses>();
            }
            
            Integer dynamicID = 0;
            Set<String> brandKeySets = brandClassMap.keySet();
            for (String brands : brandKeySets){
                System.debug('@Entered for loop...' +brandClassMap.keySet());
                vBC = new VehicleBrandsAndClasses();
                vBC.name = new Map<String, String>();
                vBC.name.put('Id',String.valueof(++dynamicID));
                vBC.name.put('name', brands);
                System.debug('vBC Maps :' +vBC);
                if (brandClassMap.get(brands) != null){
                    Set<String> b_Classes = brandClassMap.get(brands);
                   
                    vBC.brandClass = new List<Map<String,String>>();
                    for (String cls : b_Classes){
                        BrandClasses b_Cls = new BrandClasses();                    
                        b_Cls.name = new Map<String, String>();
                        b_Cls.name.put('Id', String.valueof(++dynamicID));
                        b_Cls.name.put('name', cls);
                        vBC.brandClass.add(b_Cls.name);
                        System.debug('@Brand Classes :' +vBC);
                    }
                }
                vBrandsAndClasses.add(vBC);             
            } 

           
            VehicleBrandClassMapping = JSON.serialize(vBrandsAndClasses);
            classModelMapping = JSON.serialize(classModelMap);
            
            /***************** CAR MODEL WRAPPER CLASS LOGIC : END ****************************/ 
           

             
        }catch(Exception e){
            System.debug('Exception encountered...' +e.getMessage());
        }  
        
        
    }
    
    /*********** WRAPPER CLASSES *******************/
    public class VehicleBrandsAndClasses{
        public Map<String, String> name {get; set;}
        public List<Map<String,String>> brandClass {get; set;}
    }
    
    public class BrandClasses{
        public Map<String, String> name {get;set;}
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
         system.debug('saveVal method enters here'+enteredText1);
         if(enteredText1==null || enteredText1 == '?'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Required_Information));
            nextPage = null;
         }
        else{
            if(enteredText2 == '?'){
                enteredText2=null;
            }
            if(enteredText3 == '?'){
                enteredText3=null;
            }
            
            vehicle.Brand__c=enteredText1;
            vehicle.Class__c=enteredText2;
            vehicle.Model__c=enteredText3;
            try{
                insert vehicle;
            }catch(Exception e){
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
    
        /**    
     * @Description : saves the record and redirects to same vehicle create page
     * @author      : sriram kalluri
     * @Date        : 11/18/2015
     * @param       : Field values entered in vf page
     * @return      : redirects to create_vehicle page
     * @see         : VehicleExtension
    **/   
   
    public PageReference saveValnew()
    {
          system.debug('saveValnew method enters here');
          if(enteredText1==null || enteredText1 == '?'){  
             
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Required_Information));
             nextPage = null;
              
          }else{
                if(enteredText2 == '?'){
                    enteredText2=null;
                    }
                if(enteredText3 == '?'){
                    enteredText3=null;
                }
                vehicle.Brand__c=enteredText1;
                vehicle.Class__c=enteredText2;
                vehicle.Model__c=enteredText3;          
                try{
                    insert vehicle;
                }catch(Exception e){
                    string error=e.getMessage();
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,error));
                    System.debug('Exception encountered...' +error);
                } 
              
                nextPage = new PageReference('/apex/Create_Vehicle');
                nextPage.setRedirect(true);
          
          }
             return nextPage;
            
    }
    
    
   

}