public with sharing class UtilSobject {

    public static void insertSobjects(List<Sobject> sos) {
        try {
            insert sos;
        }
        catch (DMLException e) {
            sos[0].addError(e.getDMLMessage(0));
            System.debug('Exception message is :' + e.getDMLMessage(0));
        }
    }
    
    public static void updateSobjects(List<Sobject> sos) {
        try {
            update sos;
        }
        catch (DMLException e) {
            sos[0].addError(e.getDMLMessage(0));
            System.debug('Exception message is :' + e.getDMLMessage(0));
        }
    }    
    
    public static void deleteSobjects(List<Sobject> sos) {
        try {
            delete sos;
        }
        catch (DMLException e) {
            sos[0].addError(e.getDMLMessage(0));
            System.debug('Exception message is :' + e.getDMLMessage(0));
        }
    }    
}