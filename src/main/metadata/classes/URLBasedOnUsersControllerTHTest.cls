@isTest
public class URLBasedOnUsersControllerTHTest{
public static testmethod void testurl(){
    Lead__C l=new Lead__C();
    insert l;
    URLBasedOnUsersControllerTH a=new URLBasedOnUsersControllerTH();
    a.baseurl=l;
    URLBasedOnUsersController u=new URLBasedOnUsersController();
    }
}