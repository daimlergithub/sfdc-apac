public Class TriggerRecursiveCheck{
    public static boolean run = true;
    public static boolean run2 = true;
    public static boolean AccountLinkCheck=true;
    public static boolean ALAddressCheck=true;
    public static boolean isNotVRrelatedUpdateTH=true;
    public static boolean isNotSalesAddressrelatedUpdateTH=true;
    //Rajesh - added flag to prevent referral point recalculation 
    public static boolean ReferralCalcFlag=true;
    public static boolean runVandVR = true;
    public static boolean copyAttachmentOnLoadJP = true;
	
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }
        else{
            return run;
        }
    }
    public static boolean runOnce2(){
        if(run2){
            run2=false;
            return true;
        }
        else{
            return run2;
        }
    }
    public static boolean AccountLinkRecursiveCheck(){
        if(AccountLinkCheck){
            AccountLinkCheck=false;
            return true;
        }
        else{
            return AccountLinkCheck;
        }
    }
    public static boolean AccountLinkAddressCheck(){
        if(ALAddressCheck){
            ALAddressCheck=false;
            return true;
        }
        else{
            return ALAddressCheck;
        }
    }
    public static boolean VRrelatedCheckTH(){
        if(isNotVRrelatedUpdateTH){
            isNotVRrelatedUpdateTH=false;
            return true;
        }
        else{
            return isNotVRrelatedUpdateTH;
        }
    }
    public static boolean SalesAddressCheckTH(){
        if(isNotSalesAddressrelatedUpdateTH){
            isNotSalesAddressrelatedUpdateTH=false;
            return true;
        }
        else{
            return isNotSalesAddressrelatedUpdateTH;
        }
    }
    
    public static boolean runOnceForVandVR(){
        if(runVandVR){
            runVandVR=false;
            return true;
        }
        else{
            return runVandVR;
        }
    }
    
	public static boolean copyAttachmentOnLoadCheckJP(){
        if(copyAttachmentOnLoadJP){
            copyAttachmentOnLoadJP=false;
            return true;
        }
        else{
            return copyAttachmentOnLoadJP;
        }
    }
	
}