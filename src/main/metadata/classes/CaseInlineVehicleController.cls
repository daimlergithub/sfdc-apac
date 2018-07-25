/**
**New Controller Class for Sales Lead Record Type selected
** Created By: Namitha
** Date: 2018-03-27
History:
Author                         Date                    Description
**/
public with sharing class CaseInlineVehicleController {
    
    //To fetch case details
    public Id recID {get;set;}
    public Id recTypeId {get;set;}
    public Id leadrecTypeId {get;set;}
    public string rec {get;set;}
    public boolean isHide {get;set;}
    public boolean isHidecomp {get;set;}
    public integer prefcount;
    public integer prefcountcomp;
    public integer i;
    public integer j;
    public static integer chk;
    public static integer chkcomp;
    public boolean valSuccess = true;
    public boolean makevalSuccess = true;
    public string editaddressId {get;set;} 
    public id tobeEdited{get; set;} 
    public List<Case> Acc{get; set;}
    public boolean editTradeInFlg{get;set;}
    

    //This is used for interested vehicle
    public list<Lead_Details__c> intVehicle {get;set;} 
    
    //This is used for competitor vehicle
    public list<Lead_Details__c> compVehc {get;set;} 
    
    //This is used for Trad-in vehicle
    public list<Lead_Details__c> tradeVehc {get;set;}
    
    public list<Lead_Details__c> allVehicles = new list<Lead_Details__c>();
    public list<Vehicle_Relationship__c> vehRel {get;set;}
    









    ApexPages.StandardController stdController;
    public CaseInlineVehicleController(ApexPages.StandardController controller) {
      //recID = controller.getRecord().Id; 
      recID = ApexPages.currentPage().getParameters().get('id');
      system.debug('ReciD : ' +recID);
      if(chk != 1)isHide = true;
      if(chkcomp != 1)isHidecomp = true;
      

      intVehicle = new list<Lead_Details__c>();
      compVehc = new list<Lead_Details__c>();
      tradeVehc = new list<Lead_Details__c>();
      editTradeInFlg = false;
      

      //To populate all the vehicles already associated to any Case record.
      Acc = [Select ID, AccountID from Case where ID = :recID limit 1];
      vehRel = [Select Vehicle_Model__c,Vehicle_Brand__c,Vehicle_Class__c,Mileage_start__c,Mileage_End__c from Vehicle_Relationship__c where Contact__c= :Acc[0].AccountID ];
      intVehicle =[Select Id,Brand__c,Car_Model__c,Car_Model_Competitor__c,Class__c,Color__c,Market__c,Mileage__c,Preferred__c,Related_Lead__c,Trade_In_Vehicle__c,Trim__c,Type__c,Vehicle_Model_Type__c,Year_of_Manufacture__c from Lead_Details__c where Related_Case__c=:recID and RecordType.DeveloperName='Interested_Vehicle'];
      compVehc =[Select Id,Brand__c,Car_Model__c,Car_Model_Competitor__c,Class__c,Color__c,Market__c,Mileage__c,Preferred__c,Related_Lead__c,Trade_In_Vehicle__c,Trim__c,Type__c,Vehicle_Model_Type__c,Year_of_Manufacture__c from Lead_Details__c where Related_Case__c=:recID and RecordType.DeveloperName='Competitor'];
      tradeVehc =[Select Id,Brand__c,Car_Model__c,Car_Model_Competitor__c,Class__c,Color__c,Market__c,Mileage__c,Preferred__c,Related_Lead__c,Trade_In_Vehicle__c,Trim__c,Type__c,Vehicle_Model_Type__c,Year_of_Manufacture__c from Lead_Details__c where Related_Case__c=:recID and RecordType.DeveloperName='Trade_In'];
      

      //To add a new tradIn details
            if(tradeVehc.size() == 0){
      Lead_Details__c tld = new Lead_Details__c();
      tld.type__c = 'Trade In';
      tradeVehc.add(tld);
      leadrecTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_TradeIn_Record_Type);
      tld.RecordTypeId = leadrecTypeId;
            }
    }

    
        //To add more records for Interested Vehicle
        public PageReference AddIntRecord() {
      Lead_Details__c ld = new Lead_Details__c();
      ld.type__c = 'Interested';
      leadrecTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type);
      ld.RecordTypeId = leadrecTypeId;
      ld.Related_Case__c = recID;
      intVehicle.add(ld);
      return null;
        }
    
        //To add more records for Competitor Vehicle
        public PageReference AddCompRecord() {
      Lead_Details__c cld = new Lead_Details__c();
      cld.type__c = 'Competitor';
      leadrecTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
      cld.RecordTypeId = leadrecTypeId;
      compVehc.add(cld);
      return null;
        }
    
        public void UpdateModInfo(){
      set<id> carModel = new set<id>();
      set<id> compModel = new set<id>();
      allVehicles.addall(intVehicle);
      allVehicles.addall(compVehc);
      for(Lead_Details__c l :allVehicles){
        carmodel.add(l.Car_Model__c);
        compModel.add(l.Car_Model_Competitor__c);
      }

      list<Car_Model__c> cml = [select id, brand__C,series__c,Colour__c,Trim__c from car_model__C where id in: carModel or id in: compModel];
      for(Lead_Details__c l :allVehicles){
        for(Car_Model__c cm : cml){
          if(l.Car_Model__c == cm.id || l.Car_Model_Competitor__c == cm.id){
            l.brand__C = cm.brand__C;
            l.Class__c = cm.series__c;
            l.color__c = cm.colour__c;
            l.trim__C = cm.trim__c;
          }
        }
      }
    }




    
    //function to check Vehicle make in Tradin info is numeric.
    public void Vehmake(){
      makevalSuccess = true;
      string  yom = tradeVehc[0].Year_of_Manufacture__c;
      if (yom != null && (!yom.isNumeric() || yom.length() != 4))
      {

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.IN_Year_Of_Make));
        makevalSuccess = false;
      }
    }


    
    public void PreferredChk(){
      chk = 1;
      prefcount = 0;
      isHide = true;
      valSuccess = true;
      system.debug('size'+intVehicle.size());
      if(intVehicle!=null && intVehicle.size()>0)
      {

        for(i=0;i<intVehicle.size();i++)
        {

          if(intVehicle[i].Preferred__c)
          {

            system.debug('i'+i);
            prefcount++;
          }
        }


        system.debug('prefcount: '+prefcount);
        if(prefcount>1)
        {

          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.IN_Interested_Preferred_vehicle));
          isHide = false;
          valSuccess = false;
        }
      }
    }

    public void editTradeInDetails(){
        editTradeInFlg = true;
    }

    
    public void PreferredChkComp(){
      chkcomp = 1;
      prefcountcomp = 0;
      isHidecomp = true;
      valSuccess = true;
      system.debug('size'+compVehc.size());
      if(compVehc!=null && compVehc.size()>0)
      {

        for(j=0;j<compVehc.size();j++)
        {

          if(compVehc[j].Preferred__c)
          {

            system.debug('j'+j);
            prefcountcomp++;
          }
        }


        system.debug('prefcountcomp: '+prefcountcomp);
        if(prefcountcomp>1)
        {

          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.IN_Competitor_Preferred_vehicle));
          isHidecomp = false;
          valSuccess = false;
        }
      }
    }



    public void EditOptions(){
      system.debug('Inside edit: ' + editaddressId);
    }   

    public void savecase(){
      editaddressId = null;
      Vehmake();
      system.debug('valSuccess: '+valSuccess);
      if(valSuccess && makevalSuccess) {
        allVehicles = new list<Lead_Details__c>();
        //added for loops so that lead detail is not inserted if user oest not pick any model
        for(integer i=0;i<intVehicle.size();i++){
          system.debug('intmodel:' + intVehicle[i].Car_Model__c);
          if(intVehicle[i].Car_Model__c != null) allVehicles.add(intVehicle[i]);
        }

        for(integer i=0;i<compVehc.size();i++){
          system.debug('comptmodel:' + compVehc[i].Car_Model__c);
          if(compVehc[i].Car_Model_Competitor__c != null) allVehicles.add(compVehc[i]);
        }

        system.debug('trade size' + tradeVehc.size());
        for(integer i=0;i<tradeVehc.size();i++){
          system.debug('trademodel:' + tradeVehc[i].Trade_In_Vehicle__c);
          if(tradeVehc[i].Trade_In_Vehicle__c != null) allVehicles.add(tradeVehc[i]);
        }           

        for(Lead_Details__c l :allVehicles){
          l.Related_Case__c = recID;
        }
        try{


          Upsert allVehicles;
          //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Vehicle successfully added to the case.'));
        }

        catch(DmlException e){
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getDMLMessage(0)));                                          
        }


      }  
    }


}