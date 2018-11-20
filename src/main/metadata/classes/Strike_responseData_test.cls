@isTest
public class Strike_responseData_test {
   public static testMethod void strike_responsetest(){
 List<Opportunity> opps = new List<Opportunity>();
        for(integer i = 0; i<1000; i++){
            opps.add(new Opportunity(Name = 'test' + i, Amount = 1000 * Math.random()));
        }
       strike_responseData srd=new strike_responseData(); 
       srd.addError('Error');
       srd.getJsonString();
}
}