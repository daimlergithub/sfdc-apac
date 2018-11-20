@isTest
Private class CustomSelectOptiontest {

    @isTest
    static void Custom(){
        string value = 'value';
        string label = 'label';
        boolean disabled = false;
        boolean escapeItem = false;
        string value1 = 'value1';
        string label1 = 'label1';
        boolean isDisabled = false;
        //boolean escapeItem = false;
        CustomSelectOption cso = new CustomSelectOption(value,label);
        CustomSelectOption cso1 = new CustomSelectOption(value1,label1, isDisabled);
    }
    
}