public interface ServiceRetailTsk {
    Map<String,List<String>> retrieveFieldSet(SObject sObj, String componentName,String recordTypeId,String market);
    Factory_Fields__mdt getmdRec();
    void setmdRec(Factory_Fields__mdt rec);
}