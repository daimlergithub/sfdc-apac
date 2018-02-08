public Class TriggerRecursiveCheck{
    public static boolean run = true;
    public static boolean run2 = true;
	public static boolean AccountLinkCheck=true;
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
}