/*
 * Name                 : UtilLeadEmailEscalation
 * Object               : Account(Dealer), Lead
 * Requirement          : US-Lead-46, US-Lead-47, US-Lead-48
 * Refer classes        : 
 * Author               : Mouse Liu
 * Create Date          : 2013-06-18
 * Modify History       : 
 * 
 */
public class UtilLeadEmailEscalation {
    // Check Touched Rate in 72H for weekly and ByRegion
    public static Boolean checkFollowupRate(Account acc) {
        Decimal touchedCount = 0;
        for (Lead__c lead : acc.Lead_Assigned_Dealer__r) {
            // Calc touched count
            if (!lead.Dealer_Untouched_In_72H__c) {
                touchedCount++;
            }
        }

        // If followup rate is > 90%, return true
        if (acc.Lead_Assigned_Dealer__r.size() == 0) {
            return true;
        }
        
        return touchedCount / acc.Lead_Assigned_Dealer__r.size() > 0.9;
    }

    // Get the dealers of every Destrict Manager(Dealer Owner)
    public static Map<String, List<Account>> getSeparateAccountsBySubRegion(List<Account> accs) {
        Map<String, List<Account>> subRegion2Accounts = new Map<String, List<Account>>();
        for (Account acc : accs) {
            String subRegion = acc.Dealer_MB_Sub_Region__c;

            if (subRegion2Accounts.containsKey(subRegion)) {
                subRegion2Accounts.get(subRegion).add(acc);
            }
            else {
                subRegion2Accounts.put(subRegion, new List<Account>{acc});
            }
        }

        return subRegion2Accounts;
    }

    private static String monthlyTableHeader = 
        '<table cellspacing="0px" border="1px solid #272822;" style="font-size:12px; ' +
            'background-color: #CDCDCD;border-collapse:collapse"> ' + 
            '<tr style="font-weight: bold;">' + 
                '<td width="3%" style="border:solid black 1.0pt;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">NO.</p>' +
                '</td>' + 

                '<td width="16%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'NameCn<br>Dealer' +
                    '</p>' +
                '</td>' +

                '<td width="8%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'ND Code<br>ND code' +
                    '</p>' +
                '</td>' +

                '<td width="8%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'BDC Dealer<br>BDC distributors' +
                    '</p>' +
                '</td>' +

                '<td width="5%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' + 
                    '<p align="center" style="margin:5px; text-align:center">' + 
                        'Region<br>Regional' +
                    '</p>' +
                '</td>' + 

                '<td width="12%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' + 
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Total Leads<br>Total number of assigned sales leads' + 
                    '</p>' +
                '</td>' + 

                '<td width="12%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' + 
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Leads Follow-Up<br>within 72 hours<br>' +
                        'by Dealer<br>Distributor within 72 hours following up leads' + 
                    '</p>' +
                '</td>' + 

                '<td width="12%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' + 
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Follow-Up rate<br>(within 72 hours)<br>Sales lead follow-up rate<br>（KPI ≥ 90%）' +
                    '</p>' +
                '</td>' + 

                '<td width="12%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' + 
                    '<p align="center" style="margin:5px; text-align:center">' + 
                        'Successfully<br>Contacted Leads<br>by Dealer<br>' +
                        'Number of dealer success contacting sales leads' +
                    '</p>' +
                '</td>' + 

                '<td width="12%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' + 
                    '<p align="center" style="margin:5px; text-align:center">' + 
                        'Successfully<br>Contacted Rate<br>Success contact rate<br>（KPI ≥ 80%）' +
                    '</p>' +
                '</td>' + 

                //'<td width="10%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                //    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' + 
                //    '<p align="center" style="margin:5px; text-align:center">' +
                //        'Authentic Updated<br>Leads Checked<br>by CAC<br>' + 
                //        'The CAC verification follow-up status<br>Actual number of sales leads' +
                //    '</p>' +
                //'</td>' + 

                //'<td width="12%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                //    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' + 
                //    '<p align="center" style="margin:5px; text-align:center">' +
                //        'Leads Status Update<br>Authenticity Rate Checked<br>by CAC<br>' +
                //        'Authenticity leads status update<br>（KPI ≥ 80%）' +
                //    '</p>' +
                //'</td>' + 
            '</tr>';

    private static String weeklyTableHeader = 
        '<table cellspacing="0px" border="1px solid #272822;" style="font-size:12px; ' +
                'background-color: #CDCDCD;border-collapse:collapse"> ' + 
            '<tr height="" style="font-weight: bold;">' + 
                '<td width="1%" style="border:solid black 1.0pt;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">NO.</p>' +
                '</td>' + 

                '<td width="16%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'NameCn<br>Dealer</p>' +
                '</td>' +

                '<td width="7%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'ND Code<br>ND code' +
                    '</p>' +
                '</td>' +

                '<td width="8%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'BDC Dealer<br>BDC distributors' +
                    '</p>' +
                '</td>' +

                '<td width="4%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Region<br>Regional</p>' +
                '</td>' +

                '<td width="9%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Total Leads<br>Total number of assigned sales leads</p>' +
                '</td>' +

                '<td width="15%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Leads Follow-Up within 72 hours<br>by Dealer<br>' + 
                        'Distributor within 72 hours following up leads</p>' + 
                '</td>' +

                '<td width="12%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Follow-Up rate<br>(within 72 hours)<br>' +
                        'Sales lead follow-up rate（KPI ≥ 90%）</p>' +
                '</td>' +

                '<td width="15%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Successfully Contacted Leads<br>by Dealer<br>' + 
                        'Number of dealer success contacting sales leads</p>' + 
                '</td>' + 

                '<td width="13%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Successfully<br>Contacted Rate<br>' +
                        'Success contact rate（KPI ≥ 80%）</p>' +
                '</td>' +
            '</tr>';

    private static String emailNotes = 
        '<br>' +
        '<div align="left">' +
            '<div style="font-size: 12px;">' +
                '<b>Note：</b>' +
            '</div>' + 
            '<div style="font-size: 12px;">' +
                '<b>Sales lead follow-up rate(KPI ≥ 90%): </b>[Follow up on sales leads within 72 hours/total number of assigned leads]' +
            '</div>' + 
            '<div style="font-size: 12px;">' +
                '<b>Success contact rate(KPI ≥ 80%): </b>[Successfully obtained within 72 hours contact/follow up on sales leads]' +
            '</div>' +
        '</div>';

    public static String getMonthlyEmailBodyByDealer(Account acc) {
        // Populate Email Body
        Date lastDayInLastMonth = System.today().toStartOfMonth() - 1;
        Date firstDayInLastMonth = lastDayInLastMonth.toStartOfMonth();
        
        String emailContent = 
            '<div align="left" style="font-size: 13px;">' + 
                acc.Name + 'Dealer：<br>Last month（' + getDateLiteral(firstDayInLastMonth) + 
                ' To ' + getDateLiteral(lastDayInLastMonth) + 
                '）Your lead follow up are as follows：' +
            '</div>';

        String monthlyTableTitle = 
            '<div align="center" style="font-family:corpoA; font-size: 12px;">' + 
                '<h3>Leads Follow-Up Monthly Report<BR>Sales lead follow up monthly reports</h3>' +
            '</div>';

        // Add Report Detail: Table Content
        String monthlyTableContent = '<tr style="background-color: #CDCDCD;">';
        List<String> rowValue = getRowValue(1, acc, true);
        for (Integer i = 0; i < rowValue.size(); i++) {
            String border = 'border:solid black 1.0pt;border-left:none;';
            if (i == 0) border = 'border:solid black 1.0pt;';
            monthlyTableContent += 
                '<td style="' + border + 'background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt">' +
                    '<p style="margin:5px; text-align:center">' + 
                        rowValue[i] + 
                    '</p>' +
                '</td>';
        }
        monthlyTableContent += '</tr></table>';

        // Combine these
        String emailBody = 
            '<div style="font-family: corpoS Arial">' + 
                emailContent + monthlyTableTitle + 
                monthlyTableHeader + monthlyTableContent + emailNotes +
            '</div>';

        return emailBody;
    }

    public static String getWeeklyEmailBodyByDealer(Account acc) {
        // Populate Email Body
        Date lastSunday = System.today().toStartOfWeek() - 1;
        Date lastMonday = lastSunday - 6;
        
        String emailContent = 
            '<div align="left" style="font-size: 13px">' + 
                acc.Name + 'Dealer：<br>Last week（' + getDateLiteral(lastMonday) + 
                ' To ' + getDateLiteral(lastSunday) + 
                ')Of your sales lead follow-up rate of nonconformance (less than 90%),' + 
                'Please follow up and update the status as soon as possible.' +
            '</div><br>';

        String weeklyTableTitle = 
            '<div align="center" style="font-family:corpoA; font-size: 12px;">' + 
                '<h3>Leads Follow-Up Weekly Report<BR>Sales lead follow-up weekly reports</h3>' +
            '</div>';

        // Add Report Detail: Table Content
        String weeklyTableContent = '<tr style="background-color: #CDCDCD">';
        List<String> rowValue = getRowValue(1, acc, false);
        for (Integer i = 0; i < rowValue.size(); i++) {
            String border = 'border:solid black 1.0pt;border-left:none;';
            if (i == 0) border = 'border:solid black 1.0pt;';
            weeklyTableContent += 
                '<td style="' + border + 'background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt">' +
                    '<p style="margin:5px; text-align:center">' + 
                        rowValue[i] + 
                    '</p>' +
                '</td>';
        }
        weeklyTableContent += '</tr></table>';

        // Combine these
        String emailBody =             
            '<div style="font-family: corpoS Arial">' + 
                emailContent + weeklyTableTitle + 
                weeklyTableHeader + weeklyTableContent + emailNotes +
            '</div>';

        return emailBody;
    }

    public static String getMonthlyEmailBodyByRegion(List<Account> accs) {
        // Populate Email Body
        Date lastDayInLastMonth = System.today().toStartOfMonth() - 1;
        Date firstDayInLastMonth = lastDayInLastMonth.toStartOfMonth();
        
        String emailContent = 
            '<div align="left" style="font-size: 13px;">' + 
                'Last month（' + getDateLiteral(firstDayInLastMonth) + 
                ' To ' + getDateLiteral(lastDayInLastMonth) + '）' +
                (accs[0].Dealer_MB_Sub_Region__c == null ? '' : 
                 accs[0].Dealer_MB_Sub_Region__c) +  
                'Regional sales lead follow up monthly report are as follows:' + 
            '</div>' + 
            '<br>';

        String monthlyTableTitle = 
            '<div align="center" style="font-family:corpoA Arial; font-size: 12px;">' + 
                '<h3>Leads Follow-Up Monthly Report<BR/>Regional sales lead follow up monthly report are as follows:</h3>' +
            '</div>';

        // Add Report Detail: Table Content
        List<String> tableContentList = new List<String>();
        for (List<String> rowValue : getRowValues(accs, true)) {
            List<String> tdList = new List<String>();
            for (Integer i = 0; i < rowValue.size(); i++) {
                String border = 'border:solid black 1.0pt;border-left:none;';
                if (i == 0) border = 'border:solid black 1.0pt;';
                tdList.add( 
                    '<td style="' + border + 'background:#CDCDCD;' +
                        'padding:0cm 5.4pt 0cm 5.4pt">' +
                        '<p style="margin:5px; text-align:center">' + 
                            rowValue[i] + 
                        '</p>' +
                    '</td>');
            }
            // Add Report Detail: Table weiba
            tableContentList.add('<tr style="background-color: #CDCDCD">' + 
                String.join(tdList, '\n') + '</tr>');
        }
        String monthlyTableContent = String.join(tableContentList, '\n') + '</table>';
        
        String emailBody = 
            '<div align="center" style="font-family: corpoS Arial">' + 
                emailContent + monthlyTableTitle + monthlyTableHeader + 
                monthlyTableContent + emailNotes + 
            '</div>';

        return emailBody;
    }

    public static String getWeeklyEmailBodyByRegion(List<Account> accs) {
        // Populate Email Body
        Date lastSunday = System.today().toStartOfWeek() - 1;
        Date lastMonday = lastSunday - 6;
        
        String emailContent =
            '<div align="left" style="font-size: 13px;">' + 
                'Last week（' + getDateLiteral(lastMonday) + 
                ' To ' + getDateLiteral(lastSunday) + '）' +
                (accs[0].Dealer_MB_Sub_Region__c == null ? '' : 
                 accs[0].Dealer_MB_Sub_Region__c) +  
                'Regional sales lead follow-up weekly reports are as follows:' + 
            '</div>' + 
            '<br>';

        String weeklyTableTitle = 
            '<div align="center" style="font-family:corpoA; font-size: 12px;">' + 
                '<h3>Leads Follow-Up Weekly Report<BR/>Sales lead follow-up weekly reports</h3>' +
            '</div>';

        // Add Report Detail: Table Content
        String weeklyTableContent = '';
        for (List<String> rowValue : getRowValues(accs, false)) {
            weeklyTableContent += '<tr style="background-color: #CDCDCD">';
            for (Integer i = 0; i < rowValue.size(); i++) {
                String border = 'border:solid black 1.0pt;border-left:none;';
                if (i == 0) border = 'border:solid black 1.0pt;';
                weeklyTableContent += 
                    '<td style="' + border + 'background:#CDCDCD;' +
                        'padding:0cm 5.4pt 0cm 5.4pt">' +
                        '<p style="margin:5px; text-align:center">' + 
                            rowValue[i] + 
                        '</p>' +
                    '</td>';
            }
            // Add Report Detail: Table weiba
            weeklyTableContent += '</tr>';
        }
        weeklyTableContent += '</table>';

        // Combine these
        String emailBody =             
            '<div style="font-family: corpoS Arial">' + 
                emailContent + weeklyTableTitle + 
                weeklyTableHeader + weeklyTableContent + emailNotes +
            '</div>';

        return emailBody;
    }

    // By Region
    private static List<List<String>> getRowValues(List<Account> accs, Boolean isMonthly) {
        List<List<String>> rowValues = new List<List<String>>();
        for (Integer i = 0; i < accs.size(); i++) {
            Account acc = accs[i];
            rowValues.add(getRowValue(i + 1, acc, isMonthly));
        }

        return rowValues;
    }

    // By Dealer
    private static List<String> getRowValue(Integer itemNumber, Account acc, Boolean isMonthly) {
        // Dealer No., Dealer Name,  Dealer ND Code, Dealer LMS, Dealer Region
        String dealerNo = String.valueOf(itemNumber);
        String dealerName = acc.Name;
        String dealerNDCode = '';
        if (acc.Dealer_ND_Code__c != null) {
            dealerNDCode = acc.Dealer_ND_Code__c;
        }
        String dealerLMS = '';
        if (acc.Dealer_LMS__c != null) {
            dealerLMS = acc.Dealer_LMS__c;
        }
        String dealerRegion = '';
        if (acc.Dealer_MB_Sub_Region__c != null) {
            dealerRegion = acc.Dealer_MB_Sub_Region__c;
        }

        // Calculate total assigned lead count, 
        // Touched Lead count and Rate, 
        // Contacted Lead count and Rate
        Decimal touchedCount = 0;
        Decimal contactedCount = 0;
        Decimal authenticityCount = 0;
        Decimal totalAssignedLeadCount = acc.Lead_Assigned_Dealer__r.size();
        Decimal touchedRate = 0;
        Decimal contactedRate = 0;
        Decimal authenticityRate = 0;
        for (Lead__c lead : acc.Lead_Assigned_Dealer__r) {
            // Calc touched count
            if (!lead.Dealer_Untouched_In_72H__c) {
                touchedCount++;
            }

            // Calc contacted count
            if (lead.Dealer_Successful_Contacted__c) {
                contactedCount++;
            }

            // Calc authenticity count
            //if (lead.Dealer_Successful_Contacted__c
            //        && lead.Dealer_Audit__c 
            //        && lead.Dealer_Audit_Result__c == 'Dealers contacted the customer') {
            //    authenticityCount++;
            //}
        }

        // If totalAssignedLeadCount is 0, touchedRate is 0
        if (totalAssignedLeadCount != 0) {
            touchedRate = (touchedCount / totalAssignedLeadCount).setScale(2);
        }

        // If touchedCount is 0, contactedRate is 0
        if (touchedCount != 0) {
            contactedRate = (contactedCount / touchedCount).setScale(2);
        }
        
        // If contactedCount is 0, authenticityRate is 0
        //if (contactedCount != 0) {
        //    authenticityRate = (authenticityCount / contactedCount).setScale(2);
        //}

        // Both Weekly and Monthly have these values
        List<String> rowValues = new List<String>{
            dealerNo, dealerName, dealerNDCode, dealerLMS, dealerRegion,
            String.valueOf(totalAssignedLeadCount),
            String.valueOf(touchedCount), 
            format(touchedRate),
            String.valueOf(contactedCount), 
            format(contactedRate)
        };

        // If monthly, two more values
        //if (isMonthly) {
        //    rowValues.add(String.valueOf(authenticityCount));
        //    rowValues.add(format(authenticityRate));
        //}

        return rowValues;
    }


    /**************************************************************
     * Conversion Rate Part
     **************************************************************/
    private static String conversionRateTableHeader = 
        '<div align="center">' + 
        '<table width="80%" cellspacing="0px" border="1px solid #272822;" style="font-size:12px; ' +
                'background-color: #CDCDCD;border-collapse:collapse; "> ' + 
            '<tr height="" style="font-weight: bold;">' + 
                '<td width="20%" style="border:solid black 1.0pt;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">Region<br>区域</p>' +
                '</td>' + 

                '<td width="20%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Send To dealer sales leads<br>Leads sent to dealers<sup>1</sup></p>' +
                '</td>' +

                '<td width="20%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Success linked to owners<br>Call Successfully</p>' +
                '</td>' +

                '<td width="20%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Trading volume<br>Converted<sup>2</sup></p>' +
                '</td>' +
                '<td width="20%" style="border:solid black 1.0pt;border-left:none;background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt;height:63.85pt">' +
                    '<p align="center" style="margin:5px; text-align:center">' +
                        'Sales lead conversion rates<br>Leads Conversion Rate</p>' +
                '</td>' +
            '</tr>';

    private static String conversionRateEmailNotes = 
        '<br>' +
        '<div align="left">' +
            '<div style="font-size: 12px;">' +
                '<b>注：</b>' +
            '</div>' + 
            '<div style="font-size: 12px;">' +
                '<b>Leads sent to dealers<sup>1</sup>: </b>Leads assigned to dealers 1 year ago.' +
            '</div>' + 
            '<div style="font-size: 12px;">' +
                '<b>Converted<sup>2</sup>: </b>Leads converted by dealers in last 12 rolling months.' +
            '</div>' +
        '</div>';

    // Get conversion rate regional outbound email body
    public static String getConversionRateEmailBodyByRegion(List<Account> accsInPast12thMonth) {
        // Populate Email Body
        Date lastDayInLastMonth = System.today().toStartOfMonth() - 1;
        Date firstDayInLastMonth = lastDayInLastMonth.toStartOfMonth();
        
        String emailContent =
            '<div align="left" style="font-size: 13px;">' + 
                '（' + getDateLiteral(firstDayInLastMonth.addYears(-1)) + 
                ' To ' + getDateLiteral(lastDayInLastMonth.addYears(-1)) + '）' +
                (accsInPast12thMonth[0].Dealer_MB_Sub_Region__c == null ? '' : 
                 accsInPast12thMonth[0].Dealer_MB_Sub_Region__c) +  
                'Monthly report of sales lead conversion rates are as follows:' + 
            '</div>' + 
            '<br>';

        String conversionRateTableTitle = 
            '<div align="center" style="font-family:corpoA; font-size: 12px;">' + 
                '<h3>Leads Conversion Rate Report<BR/>Sales lead conversion rate of monthly reports</h3>' +
            '</div>';

        // Add Report Detail: Table Content
        String conversionRateTableContent = '<tr style="background-color: #CDCDCD">';
        List<String> rowValue = getConversionRateRowValue(accsInPast12thMonth);
        for (Integer i = 0; i < rowValue.size(); i++) {
            String border = 'border:solid black 1.0pt;border-left:none;';
            if (i == 0) border = 'border:solid black 1.0pt;';
            conversionRateTableContent += 
                '<td style="' + border + 'background:#CDCDCD;' +
                    'padding:0cm 5.4pt 0cm 5.4pt">' +
                    '<p style="margin:5px; text-align:center">' + 
                        rowValue[i] + 
                    '</p>' +
                '</td>';
        }
        conversionRateTableContent += '</tr></table></div>';

        // Combine these
        String emailBody =             
            '<div style="font-family: corpoS Arial">' + 
                emailContent + conversionRateTableTitle + 
                conversionRateTableHeader + conversionRateTableContent + conversionRateEmailNotes +
            '</div>';

        return emailBody;

        return emailBody;
    }

    private static List<String> getConversionRateRowValue(List<Account> accsInPast12thMonth) {
        Decimal sentLeadsAmount = 0;
        Decimal contactedLeadsAmount = 0;
        Decimal convertedLeadsAmount = 0;
        Decimal convertedRate = 0;

        Date lastDay = System.today().toStartOfMonth().addMonths(-12) - 1;
        Date firstDay = lastDay.toStartOfMonth();
        Date firstDayOfNext13thMonth = firstDay.addMonths(13);

        for (Account acc : accsInPast12thMonth) {
            sentLeadsAmount += acc.Lead_Assigned_Dealer__r.size();
            for (Lead__c lead : acc.Lead_Assigned_Dealer__r) {
                // Calc convertedLeadsAmount
                if (lead.CAC_Lead_Status__c == 'Purchased(Only Non BDC)'
                        && lead.Purchased_Date__c >= firstDay
                        && lead.Purchased_Date__c < firstDayOfNext13thMonth) {
                    convertedLeadsAmount++;
                }

                // Calc contactedLeadsAmount
                if (lead.Dealer_Successful_Contacted__c) {
                    contactedLeadsAmount++;
                }
            }
        }

        // Calc Converted Rate
        if (sentLeadsAmount != 0) {
            convertedRate = (convertedLeadsAmount / sentLeadsAmount).setScale(2);
        }

        return new List<String>{
            accsInPast12thMonth[0].Dealer_MB_Sub_Region__c,
            String.valueOf(sentLeadsAmount),
            String.valueOf(contactedLeadsAmount),
            String.valueOf(convertedLeadsAmount),
            format(convertedRate)
        };
    }

    // Format decimal value as percentage and precision is 0
    private static String format(Decimal decimalValue) {
        return String.valueOf((decimalValue * 100).setScale(0)) + '%';
    }

    // Return Date Format: 2013-06-05
    private static String getDateLiteral(Date theDate) {
        return String.valueOf(theDate.year()) + '-' +
               String.valueOf(theDate.month()) + '-' +
               String.valueOf(theDate.day());
    }

    // Get Dealer ToAddesses
    private static String getDealerToAddresses(Account acc) {
        Set<String> emails = new Set<String> {
            acc.Dealer_CRM_Manager_Email__c, 
            acc.Dealer_General_Manager_Email__c, 
            acc.Dealer_Marketing_Manager_Email__c, 
            acc.Dealer_Sales_Manager_Email__c
        };

        return getValidEmails(emails);
    }

    // Get Dealer ccAddress 
    private static String getDealerCcAddresses(Account acc) {
        return getValidEmails(new Set<String>{acc.Owner.Email});
    }
    
    // Get Region ToAddress
    private static String getRegionToAddresses(Account acc, Map<Id, UserRole> roleMap) {
        Set<String> destrictManagerEmail = new Set<String>();

        String ownerParentRoleId = acc.Owner.UserRole.ParentRoleId;
        List<UserRole> urs = [SELECT Id, (select id, name, email from Users) FROM UserRole WHERE ParentRoleId = :ownerParentRoleId];
        if(urs.size() > 0){
            for(UserRole ur : urs){
                for(User usr : ur.Users){
                    destrictManagerEmail.add(usr.Email);
                }
            }
        }

        return getValidEmails(destrictManagerEmail);
    }

    // Get Region ccAddress
    // Two Part: Regional Manager and Emails in Custom Settings
    private static String getRegionCcAddresses(Account acc, Map<Id, UserRole> roleMap) {
        Set<String> ccEmails = new Set<String>();

        // Add Regional Manager Email to ccEmails
        String ownerParentRoleId = acc.Owner.UserRole.ParentRoleId;
        if (ownerParentRoleId != null) {
            // Get the Parent Role
            UserRole regionalManagerRole = roleMap.get(ownerParentRoleId);

            // Get the user emails in under the parent role
            for (User usr : regionalManagerRole.Users) {
                ccEmails.add(usr.Email);
            }
        }

        return getValidEmails(ccEmails);
    }

    // Combine Email List to email String that is seprated by semicolon
    private static String getValidEmails(Set<String> emails) {
        List<String> tempList = new List<String>();
        for (String email : emails) {
            if (email != null) {
                tempList.add(email);
            }
        }

        return String.join(tempList, ';');
    }
}