public class UtilAddressTranslation 
{
	public static Map<String, String> addtrmap = new Map<String, String>();
    public static ProvinceTranslation__mdt prolist; 
    public static Map<String, String> gettranslatedvalues(string market)
    {
	   
       prolist = [select Object__c,Picklist_Name__c,Province_EN1__c,Province_EN10__c,Province_EN11__c,Province_EN12__c,Province_EN13__c,Province_EN14__c,Province_EN15__c,Province_EN16__c,
                  Province_EN17__c,Province_EN18__c,Province_EN19__c,Province_EN2__c,Province_EN20__c,Province_EN21__c,Province_EN22__c,Province_EN23__c,
                  Province_EN24__c,Province_EN25__c,Province_EN26__c,Province_EN27__c,Province_EN28__c,Province_EN29__c,Province_EN3__c,Province_EN30__c,Province_EN31__c,
                  Province_EN32__c,Province_EN33__c,Province_EN34__c,Province_EN35__c,Province_EN36__c,Province_EN37__c,Province_EN38__c,Province_EN39__c,
                  Province_EN4__c,Province_EN40__c,Province_EN41__c,Province_EN42__c,Province_EN43__c,Province_EN44__c,Province_EN45__c,Province_EN46__c,
                  Province_EN47__c,Province_EN5__c,Province_EN6__c,Province_EN7__c,Province_EN8__c,Province_EN9__c,Province_TR1__c,Province_TR10__c,Province_TR11__c,
                  Province_TR12__c,Province_TR13__c,Province_TR14__c,Province_TR15__c,Province_TR16__c,Province_TR17__c,Province_TR18__c,Province_TR19__c,Province_TR2__c,
                  Province_TR20__c,Province_TR21__c,Province_TR22__c,Province_TR23__c,Province_TR24__c,Province_TR25__c,Province_TR26__c,Province_TR27__c,Province_TR28__c,
                  Province_TR29__c,Province_TR3__c,Province_TR30__c,Province_TR31__c,Province_TR32__c,Province_TR33__c,Province_TR34__c,Province_TR35__c,Province_TR36__c,
                  Province_TR37__c,Province_TR38__c,Province_TR39__c,Province_TR4__c,Province_TR40__c,Province_TR41__c,Province_TR42__c,Province_TR43__c,Province_TR44__c,
                  Province_TR45__c,Province_TR46__c,Province_TR47__c,Province_TR5__c,Province_TR6__c,Province_TR7__c,Province_TR8__c,Province_TR9__c 
                  from ProvinceTranslation__mdt where MD__c =: market];
        
        addtrmap.put(prolist.Province_EN1__c,prolist.Province_TR1__c);
        addtrmap.put(prolist.Province_EN2__c, prolist.Province_TR2__c);
        addtrmap.put(prolist.Province_EN3__c, prolist.Province_TR3__c);
        addtrmap.put(prolist.Province_EN4__c, prolist.Province_TR4__c);
        addtrmap.put(prolist.Province_EN5__c, prolist.Province_TR5__c);
        addtrmap.put(prolist.Province_EN6__c, prolist.Province_TR6__c);
        addtrmap.put(prolist.Province_EN7__c, prolist.Province_TR7__c);
        addtrmap.put(prolist.Province_EN8__c, prolist.Province_TR8__c);
        addtrmap.put(prolist.Province_EN9__c, prolist.Province_TR9__c);
        addtrmap.put(prolist.Province_EN10__c, prolist.Province_TR10__c);
        addtrmap.put(prolist.Province_EN11__c, prolist.Province_TR11__c);
        addtrmap.put(prolist.Province_EN12__c, prolist.Province_TR12__c);
        addtrmap.put(prolist.Province_EN13__c, prolist.Province_TR13__c);
        addtrmap.put(prolist.Province_EN14__c, prolist.Province_TR14__c);
        addtrmap.put(prolist.Province_EN15__c, prolist.Province_TR15__c);
        addtrmap.put(prolist.Province_EN16__c, prolist.Province_TR16__c);
        addtrmap.put(prolist.Province_EN17__c, prolist.Province_TR17__c);
        addtrmap.put(prolist.Province_EN18__c, prolist.Province_TR18__c);
        addtrmap.put(prolist.Province_EN19__c, prolist.Province_TR19__c);
        addtrmap.put(prolist.Province_EN20__c, prolist.Province_TR20__c);
        addtrmap.put(prolist.Province_EN21__c, prolist.Province_TR21__c);
        addtrmap.put(prolist.Province_EN22__c, prolist.Province_TR22__c);
        addtrmap.put(prolist.Province_EN23__c, prolist.Province_TR23__c);
        addtrmap.put(prolist.Province_EN24__c, prolist.Province_TR24__c);
        addtrmap.put(prolist.Province_EN25__c, prolist.Province_TR25__c);
        addtrmap.put(prolist.Province_EN26__c, prolist.Province_TR26__c);
        addtrmap.put(prolist.Province_EN27__c, prolist.Province_TR27__c);
        addtrmap.put(prolist.Province_EN28__c, prolist.Province_TR28__c);
        addtrmap.put(prolist.Province_EN29__c, prolist.Province_TR29__c);
        addtrmap.put(prolist.Province_EN30__c, prolist.Province_TR30__c);
        addtrmap.put(prolist.Province_EN31__c, prolist.Province_TR31__c);
        addtrmap.put(prolist.Province_EN32__c, prolist.Province_TR32__c);
        addtrmap.put(prolist.Province_EN33__c, prolist.Province_TR33__c);
        addtrmap.put(prolist.Province_EN34__c, prolist.Province_TR34__c);
        addtrmap.put(prolist.Province_EN35__c, prolist.Province_TR35__c);
        addtrmap.put(prolist.Province_EN36__c, prolist.Province_TR36__c);
        addtrmap.put(prolist.Province_EN37__c, prolist.Province_TR37__c);
        addtrmap.put(prolist.Province_EN38__c, prolist.Province_TR38__c);
        addtrmap.put(prolist.Province_EN39__c, prolist.Province_TR39__c);
        addtrmap.put(prolist.Province_EN40__c, prolist.Province_TR40__c);
        addtrmap.put(prolist.Province_EN41__c, prolist.Province_TR41__c);
        addtrmap.put(prolist.Province_EN42__c, prolist.Province_TR42__c);
        addtrmap.put(prolist.Province_EN43__c, prolist.Province_TR43__c);
        addtrmap.put(prolist.Province_EN44__c, prolist.Province_TR44__c);
        addtrmap.put(prolist.Province_EN45__c, prolist.Province_TR45__c);
        addtrmap.put(prolist.Province_EN46__c, prolist.Province_TR46__c);
        addtrmap.put(prolist.Province_EN47__c, prolist.Province_TR47__c);
        return addtrmap;
    }
	/* Translate companylegalform picklist value to text using custom metadata type 
	   Japan 2.0 SFDCJP-474
	   Created by Sivaram.A
     */ 
	public static Map<String, String> addtrmaps = new Map<String, String>();
    public static Account_Object__mdt prolists; 
    public static Map<String, String> gettranslatedAccName(string market)
    {
        prolists = [select Object__c,Picklist_Name__c,Cooperative_society__c,Education_insitution__c,Joint_venture__c,Limited_partnership_company__c,Limited_liability_company__c,Medical_corporation__c,Medical_enterprise__c,Mutual_aid_association__c,
                    Mutual_company__c,Others__c,Religious_corporation__c,Social_welfare_institution__c,Stock_company__c,Unlimited_partnership_company__c,Cooperative_society_TL__c,Education_insitution_TL__c,Joint_venture_TL__c,
                    Limited_partnership_company_TL__c,Limited_liability_company_T__c,Medical_corporation_TL__c,Medical_enterprise_TL__c,Mutual_aid_association_TL__c,Mutual_company_TL__c,Others_TL__c,Religious_corporation_TL__c,Social_welfare_institution_TL__c,
                    Stock_company_TL__c,Unlimited_partnership_company_TL__c from Account_Object__mdt where MD__c =: market];
        
        addtrmaps.put(prolists.Cooperative_society__c,prolists.Cooperative_society_TL__c);
        addtrmaps.put(prolists.Social_welfare_institution__c, prolists.Social_welfare_institution_TL__c);
        addtrmaps.put(prolists.Education_insitution__c, prolists.Education_insitution_TL__c);
        addtrmaps.put(prolists.Joint_venture__c, prolists.Joint_venture_TL__c);
        addtrmaps.put(prolists.Limited_partnership_company__c, prolists.Limited_partnership_company_TL__c);
        addtrmaps.put(prolists.Limited_liability_company__c, prolists.Limited_liability_company_T__c);
        addtrmaps.put(prolists.Medical_corporation__c, prolists.Medical_corporation_TL__c);
        addtrmaps.put(prolists.Medical_enterprise__c, prolists.Medical_enterprise_TL__c);
        addtrmaps.put(prolists.Mutual_aid_association__c, prolists.Mutual_aid_association_TL__c);
        addtrmaps.put(prolists.Mutual_company__c, prolists.Mutual_company_TL__c);
        addtrmaps.put(prolists.Others__c, prolists.Others_TL__c);
        addtrmaps.put(prolists.Religious_corporation__c, prolists.Religious_corporation_TL__c);
        addtrmaps.put(prolists.Stock_company__c, prolists.Stock_company_TL__c);
        addtrmaps.put(prolists.Unlimited_partnership_company__c, prolists.Unlimited_partnership_company_TL__c);
        return addtrmaps;
    }
}