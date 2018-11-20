public virtual class ServiceRetailTskDefault implements ServiceRetailTsk{
    private Factory_Fields__mdt rec;
    public Factory_Fields__mdt  getmdRec(){
        return this.rec;    
    }
    public void setmdRec(Factory_Fields__mdt fRec){
        this.rec=fRec;
    }
    public Map<String,List<String>> fieldSetMap = new Map<String,List<String>>();
    
    public Map<String,List<String>> retrieveFieldSet(SObject sObj, String filterName, String recordType,String market){
        try{
            if(rec.Input_Fields__c!=null){
                fieldSetMap.put('inputFields',rec.Input_Fields__c.split(','));
            }
            if(rec.Buttons__c!=null){
                fieldSetMap.put('buttons',rec.Buttons__c.split(','));
            }
            if(rec.Output_Fields__c!=null){
                fieldSetMap.put('outputFields',rec.Output_Fields__c.split(','));
            }
            if(rec.Tile_Heading__c!=null){
                fieldSetMap.put('Tile_Heading',rec.Tile_Heading__c.split(','));
            }
            if(rec.Table_Columns__c!=null){
                fieldSetMap.put('Table Columns',rec.Table_Columns__c.split(','));
            }
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return fieldSetMap ;
    }
    
}