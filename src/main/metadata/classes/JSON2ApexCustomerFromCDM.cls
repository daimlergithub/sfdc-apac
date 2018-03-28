/*
  Created by Shashi 
  Date: 2018/03/22
  Function: created this as structure of India json response is different
*/

public class JSON2ApexCustomerFromCDM {

    public List<Out_JSON_UCID_List> out_JSON_UCID_List;

    public class Out_JSON_UCID_List {
        public String IdentificationTypeValue;
        public String AdminSystemValue;
        public String IdentificationNum;
        public Integer ComponentID;
        public String AdminClientNum;
        public Integer IdentificationType;
        public Integer AdminSystemType;
    }

    
    public static JSON2ApexCustomerFromCDM parse(String json) {
        return (JSON2ApexCustomerFromCDM) System.JSON.deserialize(json, JSON2ApexCustomerFromCDM.class);
    }
}