public class MakeUpdateLinkControl { 

public String CustomerCareEmail{set; get;}
   
public MakeUpdateLinkControl (){
CustomerCareEmail = UtilConstant.ORGWIDE_EMAIL_ADDRESS_DEFAULT;

}

    


    private static string QUERY_SQL = ' '+
                                      'Select e.LocalPart,e.FunctionId, e.EmailDomainName ' +
                                      'From EmailServicesAddress e ' +
                                      'where e.FunctionId in ' +
                                      '( select id from EmailServicesFunction where IsActive = true  and FunctionName = \'EocStatus Update\')' +
                                      'and IsActive = true';

    public String getLeadId() { 
        return null;
    }
       
        
    
    public String getLeadName() { 
        return null;
    }

    public String getEmailserviceAddress() {
        String address = '';
        for(EmailServicesAddress add : Database.query(QUERY_SQL)){
            address = add.localpart + '@' + add.EmailDomainName; 
        }
 
        return address;
    }

}