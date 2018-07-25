public class INTriggerRecursionCheck {

/**
** Class to hold static variables that prevent recursion of same methods for India trigger handlers.
** Created By: Rajesh
** Date: May 20 2018
**/
    //prevent account recursion
    public static boolean inAccountAftIns = false;
    public static boolean inAccountAftUpd = false;
    public static boolean updPriAddressFlag =false;
    //prevent Address recursion
    public static boolean inAddrAftInsUpd = false;
    //prevent Accountlink validation recursion
    public static boolean inAccLinkvalC2C = false;
    //prevent Opportunity methods recursion
    public static boolean inOppBefIns = false;
    public static boolean inOppBefUpd = false;
    public static boolean inOppAftInsUpd = false;
    //prevent vehicle relationship methods recursion
    public static boolean inVRAftIns = false;
    public static boolean inVRAftUpd = false;
    public static boolean inVRAftDel = false;
    //prevent case methods recursion
    public static boolean inCaseCustPhase = false;
    public static boolean inCaseCaseOwner = false;
    public static boolean inCaseBefIns = false;
    public static boolean inCaseBefUpd = false;
    public static boolean inCaseRetCpy = false;
    public static boolean inCaseShare = false;
    public static boolean inCaseCompAmt = false;
    public static boolean inAccLinkshareretailCopy = false;//07042018 : Namitha added to prevent shareretailcopy recursion as part of ph2.
    public static boolean inAccLinkshareAccount = false;// 07042018 : Namitha added to prevent shareaccount recursion as part of ph2.
}