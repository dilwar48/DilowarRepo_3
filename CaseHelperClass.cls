/*****************************************************************************************************
* Created By                 : Jade Global 
* Created Date               : 25th May 2015
* LastModified By            : Vinay Vernekar
* LastModified Date          : 26th May 2015
* Purpose                    : This is used to  
*                               1.Populate return to address.
*                               2.Check if asset is already assigned to another RMA or FA case.
*                               3.change FA case status to Cancelled when RMA is Cancelled
*                               4.create FA case on modification of Order Name from RMA
*                               5.Set value of FA due date depending on TAC and FA network impact, severity values
*                               6.Set completion date on milestone if owner is changed.
*                               7.Set completion date on milestone on "Under investigation" and "closed" status of case.
*                               8.Set default entitlement of selected sold to account on TAC case.
*                               9.Populate RMA vendor as per the MAPpings in VendorMAP custom setting
*                               10.To create a Tasks depending on the records in Activity template object.
*07272019    Suman Tumurugoti    Two Cusomer Design, set Case account id to Asset.EndCustomer__c if different
* ******************************************************************************************************/

public class CaseHelperClass{
    public static boolean isRecursion=true;
    public static Boolean isFirstTime = true;
    
    /* public static void updateCaseIds(LIST<Case> newCases,MAP<Id,Case> oldCaseMAP){
Id cId; 
Id recordTypeIdTAC = UtilityClass.getObjectRecordTypeId(Case.SObjectType, 'TAC');
LIST<CaseSolution> caseSolutions = new LIST<CaseSolution>();
LIST<CaseArticle> caseArticles = new LIST<CaseArticle>();
system.debug('****updateCaseIds****'); 
if(!newCases.isEmpty() && newCases.size() == 1){
if(newCases[0].Status == 'Closed' && newCases[0].IsDuplicate__c != true && newCases[0].Status != oldCaseMAP.get(newCases[0].Id).Status && newCases[0].RecordTypeId == recordTypeIdTAC){
cId = newCases[0].Id;
} 
if(cId != Null){
caseSolutions = [Select Id, CaseId From CaseSolution where CaseId = :cId];
System.debug('***Case Solutions***'+caseSolutions);
caseArticles = [Select Id, CaseId From CaseArticle where CaseId = :cId];
System.debug('***Case Articles***'+caseArticles);
if(caseSolutions.isEmpty() && caseArticles.isEmpty()){
newCases[0].addError('There should be atleast one Solution or Article attached to the Case');
}
}   
}
}*/
    
    public static void EmailAlertRmaContact(List<Case> NewList,Map<Id,Case> NewMap,Map<Id,Case> OldMap){
        /*  try{

String str='';
List<Id> ListCaseId = new List<Id> ();
Map<String,String> MapCaseOwnerFeed = new Map<String,String>();
id TACRecordTypeId          = Schema.SObjectType.Case.getRecordTypeInfosByName().get('TAC').getRecordTypeId();
id RMARecordTypeId          = Schema.SObjectType.Case.getRecordTypeInfosByName().get('RMA').getRecordTypeId();
for(Case objCase: NewList){
if(objCase.RecordTypeId==RMARecordTypeId ){
ListCaseId .add(objCase.Id);
}
}
if(ListCaseId!=NULL){
for(Case objCase:[SELECT Id,CaseNumber,RecordTypeId,SLP_Acknowledgement__c,SLP_Depot_Code__c,slp_order_status_date__c,  SLP_Order_ETA__c,SLP_Order_Status__c,RMAContact__r.Email,RMAContact__r.Receive_RMA_Case_Feed_Update_Email__c FROM CASE WHERE Id IN: ListCaseId]){
System.debug('objCase.RMAContact__r.Receive_RMA_Case_Feed_Update_Email__c=='+objCase.RMAContact__r.Receive_RMA_Case_Feed_Update_Email__c );
if((objCase.RMAContact__r.Receive_RMA_Case_Feed_Update_Email__c==TRUE)&&(objCase.SLP_Acknowledgement__c!=OldMap.get(objCase.Id).SLP_Acknowledgement__c||objCase.SLP_Depot_Code__c!=OldMap.get(objCase.Id).SLP_Depot_Code__c||objCase.slp_order_status_date__c!=OldMap.get(objCase.Id).slp_order_status_date__c||objCase.SLP_Order_ETA__c!=OldMap.get(objCase.Id).SLP_Order_ETA__c||objCase.SLP_Order_Status__c!=OldMap.get(objCase.Id).SLP_Order_Status__c)){
str= 'Change of value ';
MapCaseOwnerFeed .put(objCase.RMAContact__r.Email,str);
}

}
}
System.debug('MapCaseOwnerFeed=='+MapCaseOwnerFeed);

Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> ();
if(MapCaseOwnerFeed.keySet()!=NULL){
for(String strEmail: MapCaseOwnerFeed.keySet()){
Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
// Set recipients to two contact IDs.
// Replace IDs with valid record IDs in your org.
message.toAddresses = new String[] { strEmail };
System.debug('message.toAddress=='+message.toAddresses);
//System.debug(''+MapCaseOwnerFeed.get(strEmail).Receive_RMA_Case_Feed_Update_Email__c );
message.subject = 'Case Feed Update';
message.plainTextBody = MapCaseOwnerFeed.get(strEmail);
// message.plainTextBody = MapCaseOwnerFeed.get(strEmail);
// Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
messages.add(message);
}
Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
System.debug('results=='+results);  
}  
else{
System.debug('MapCaseOwnerFeed.keySet()=='+MapCaseOwnerFeed.keySet());
}
}catch(Exception e){
System.debug('e.getMessage()=='+e.getMessage()+'------'+'e.getLineNumber()=='+e.getLineNumber());
}  */
    }
    
/******************************************************************************************************************************
* Purpose                   : UnCheck Customer Responded 
* Created by                : Appirio (2019)
*                           : for Issue I-375173 5/22/2019 by appirio Team
* 
*******************************************************************************************************************************/    
    
    public static void unCheckCustomerResponded(List<Case> newCaseList, Map<id,Case> oldMap){
           List<Case> caseToUpdate = new List<Case>();
           String currentUserLicense = [SELECT id,profile.UserLicense.Name From User Where id =: System.UserInfo.getUserId() limit 1].profile.UserLicense.Name;
           
           System.debug('currentUserLicense : '+currentUserLicense);
            for(Case c : newCaseList){
               if((currentUserLicense =='Salesforce' && c.Customer_Responded__c && isFirstTime)||(c.Customer_Responded__c && c.LastActivityDate__c != oldMap.get(c.id).LastActivityDate__c && isFirstTime)){
                   System.debug('c.Customer_Responded__c : '+c.Customer_Responded__c);
                   c.Customer_Responded__c = false;
                   }
            }
            isFirstTime = false;
    }

    
/******************************************************************************************************************************
* Purpose                   : Populate Asset field on case
* Created by                : Appirio (2019)
*                           : for Issue I-375173 5/29/2019 by appirio Team
* 
*******************************************************************************************************************************/
      public static void populateAsset(List<Case> newCaseList, Map<id,Case> oldMap){
            Map<id,case> parentIdtoCaseMap = new Map<id,case>();
            Map<String,id> SerialNumberToAssetId = new Map<String,id>();
            Map<Id,String> CaseParentIdToSerialNumberMap = new Map<Id,String>();
            Id FARecordTypeId = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('Failure Analysis').getRecordTypeId();
            //System.debug('>>FARecordTypeId :'+FARecordTypeId);
            for(case c : newCaseList){
                //System.debug('>>c.recordtypeId :'+c.recordtypeId);
                //System.debug('>>c.parentId :'+c.parentId);
                if(c.recordtypeId == FARecordTypeId &&c.status == 'In Progress' && oldMap.get(c.id).status=='New'  && c.parentId !=null){
                    parentIdtoCaseMap.put(c.parentId,c);
                }
            }
            System.debug('>>parentIdtoCaseMap :'+parentIdtoCaseMap);
            
            for(RMA_Line_Item__c rli : [Select id,ReceivedSerialNumber__c,ActualReceivedPON__c,Case__c,Received_Asset__c From RMA_Line_Item__c Where Case__c IN : parentIdtoCaseMap.keySet()]){
                if(parentIdtoCaseMap.containsKey(rli.Case__c) && rli.ReceivedSerialNumber__c !=null){
                    //parentIdtoCaseMap.get(rli.Case__c).AssetId = (Id)rli.ReceivedSerialNumber__c;
                    CaseParentIdToSerialNumberMap.put(rli.Case__c,rli.ReceivedSerialNumber__c);
                    SerialNumberToAssetId.put(rli.ReceivedSerialNumber__c,null);
                }
                //System.debug('>>rli.ActualReceivedPON__c :'+rli.ActualReceivedPON__c);
                if(parentIdtoCaseMap.containsKey(rli.Case__c) && rli.ActualReceivedPON__c !=''){
                    parentIdtoCaseMap.get(rli.Case__c).PartNumber__c = rli.ActualReceivedPON__c;
                }
                if(parentIdtoCaseMap.containsKey(rli.Case__c) && !String.isBlank(rli.Received_Asset__c)){
                    parentIdtoCaseMap.get(rli.Case__c).ActualRecievedSerialNumber__c = rli.Received_Asset__c;
                }
            }
            
            for(Asset a : [SELECT id,SerialNumber FROM asset Where SerialNumber IN : SerialNumberToAssetId.keySet()]){
                if(SerialNumberToAssetId.containsKey(a.SerialNumber)){
                    SerialNumberToAssetId.put(a.SerialNumber,a.id);
                }
                
            }
            //System.debug('>>SerialNumberToAssetId :'+SerialNumberToAssetId);
            //System.debug('>>parentIdtoCaseMap :'+parentIdtoCaseMap);
            for(case c : newCaseList){
                if(c.parentId !=null && CaseParentIdToSerialNumberMap.containsKey(c.parentId)){
                    c.AssetId = SerialNumberToAssetId.get(CaseParentIdToSerialNumberMap.get(c.parentId));
                }
                 if(c.parentId !=null && parentIdtoCaseMap.containsKey(c.parentId)){  
                    c.PartNumber__c = parentIdtoCaseMap.get(c.parentId).PartNumber__c;
                    c.ActualRecievedSerialNumber__c = parentIdtoCaseMap.get(c.parentId).ActualRecievedSerialNumber__c;
                }
                
            }
     }  
    /******************************************************************************************************************************
* Purpose                   : Populate Customer TZ field on case with RMA contact user's timezone or Ship to Timezone(Account) 
* Created by                : Appirio (2019)
*                           : for Task T-795426 4/12/2019 by Mukesh
* 
*******************************************************************************************************************************/
    public static void populateCustomerTimezoneOnCase(List<Case> newCaseList){
        Map<Id,String> contactIdToUserTimeMap = new Map<Id,String>();
        Map<Id,String> accountIdToAccountShipToTimeZoneMap = new Map<Id,String>();
        Map<String,String> valueToLabelMap = new Map<String,String>();
        Id recordTypeHRRId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        
        for( Schema.PicklistEntry pickListVal : Case.Customer_Tz__c.getDescribe().getPicklistValues()){
            
            //pickListVal.getValue().split('\\) ')[1].trim();
            //tSub = pickListVal.split('\\) ')[1].trim();
            System.debug('>> SubString ::'+pickListVal.getValue().split('\\) ')[1].trim());
            valueToLabelMap.put(pickListVal.getValue().split('\\) ')[1].trim(),pickListVal.getValue());
        }
        system.debug('>>>valueToLabelMap >> :'+valueToLabelMap);
        
        for(Case c : newCaseList){
            if(c.RecordTypeId == recordTypeHRRId && String.isBlank(c.Customer_Tz__c)){
                if(String.isNotBlank(c.RMAContact__c)){
                    contactIdToUserTimeMap.put(c.RMAContact__c,'');
                    system.debug('>> Case RMAContact__c'+c.RMAContact__c);
                }
                if(String.isNotBlank(c.RMA_Ship_To__c)){
                    accountIdToAccountShipToTimeZoneMap.put(c.RMA_Ship_To__c,'');
                    system.debug('>> Case AccountId'+c.AccountId);
                }
            }
        }
        
        
        //List<User> userList = [SELECT id,TimeZoneSidKey,ContactId From User WHERE ContactId IN : contactIdToUserTimeMap.keySet()];
        for(User u : [SELECT id,TimeZoneSidKey,ContactId From User WHERE ContactId IN : contactIdToUserTimeMap.keySet()]){
            if(String.isNotBlank(u.TimeZoneSidKey)){
                TimeZone tz = TimeZone.getTimeZone(u.TimeZoneSidKey);
                String t =tz.getID();
                String tzName = tz.getDisplayName();
                String key = tz.getDisplayName()+' ('+u.TimeZoneSidKey+')';
                System.debug('>>key vipin::'+key);
                System.debug('>>valueToLabelMap.get(key) ::'+valueToLabelMap.get(key));
                if(valueToLabelMap.containsKey(key)){
                    contactIdToUserTimeMap.put(u.ContactId,valueToLabelMap.get(key));
                }
                //contactIdToUserTimeMap.put(u.ContactId,tz.getDisplayName());
            }
        }
        
        //for(Id tid : contactIdToUserTimeMap.keySet()){
        //    If(contactIdToUserTimeMap.get(tid)==''){
        //        accountIdToAccountShipToTimeZoneMap
        //}
        
        for(Account acc : [SELECT id,Ship_to_Timezone__c FROM Account WHERE Id IN : accountIdToAccountShipToTimeZoneMap.keySet()]){
            if(String.isNotBlank(acc.Ship_to_Timezone__c)){
                accountIdToAccountShipToTimeZoneMap.put(acc.Id,acc.Ship_to_Timezone__c);
                System.debug(' >>acc.Ship_to_Timezone__c ::'+acc.Ship_to_Timezone__c);
            }
        }
        
        
        system.debug('>>  contactIdToUserTimeMap :: '+contactIdToUserTimeMap);
        system.debug('>>  accountIdToAccountShipToTimeZoneMap :: '+accountIdToAccountShipToTimeZoneMap);
        for(Case c : newCaseList){
            if(c.RecordTypeId == recordTypeHRRId){
                if(contactIdToUserTimeMap.containsKey(c.RMAContact__c) && 
                   String.isNotBlank(contactIdToUserTimeMap.get(c.RMAContact__c))){
                       c.Customer_Tz__c = contactIdToUserTimeMap.get(c.RMAContact__c);
                   }
                else if(accountIdToAccountShipToTimeZoneMap.containsKey(c.RMA_Ship_To__c) &&
                        String.isNotBlank(accountIdToAccountShipToTimeZoneMap.get(c.RMA_Ship_To__c))){
                            c.Customer_Tz__c = accountIdToAccountShipToTimeZoneMap.get(c.RMA_Ship_To__c);
                        }
            }
        }
    }
    // End of method
    
    public static void insertProductIdOnAsset(LIST<Case> newCases){
        Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        List<Case> NewRMACases = new List<Case>();
        Set<Id> AssetIds = new Set<Id>();
        for(Case Newcase : NewCases)
        {
            if(Newcase.RecordTypeId == recordTypeIdRMA && Newcase.AssetId != null)
            {
                NewRMACases.add(Newcase);      
                AssetIds.add(Newcase.AssetId);
            }//End of If
        }//End of For
        if(!NewRMACases.isEmpty() && !AssetIds.isEmpty()){
            system.debug('*****Inside updateProductIdOnAsset*****'+NewRMACases);
            Map<id,Asset> mapAssets = new Map<id,Asset>();   
            Map<Id,Id> AssetProductMAP = new Map<Id,Id>();
            mapAssets = new Map<id,Asset>([Select Id,Product2Id,Product2.Serialized__c,EndCustomer__c from Asset where Id IN :AssetIds]);
            if(mapAssets.size()>0){
                for(Asset rmaAsset:mapAssets.values()){
                    if(rmaAsset.Product2Id != null && rmaAsset.Product2.Serialized__c == true){
                        AssetProductMAP.put(rmaAsset.Id,rmaAsset.Product2Id);
                    }
                }//END of FOR
                system.debug('****AssetProductMAP****'+AssetProductMAP);
                if(!AssetProductMAP.isEmpty() && AssetProductMAP.keySet() != null){
                    for(Case c: NewRMACases){
                        //07272019 Suman Two Cusomer Design, set Case account id to Asset.EndCustomer__c if different
                        if(Trigger.isInsert && c.AssetId!=null && mapAssets.containsKey(c.AssetId) 
                                    && mapAssets.get(c.AssetId).EndCustomer__c!=null && c.AccountId!=mapAssets.get(c.AssetId).EndCustomer__c)
                            c.AccountId = mapAssets.get(c.AssetId).EndCustomer__c;
                        if(c.AssetId != null && AssetProductMAP.containsKey(c.AssetId)){
                            c.ProductId = AssetProductMAP.get(c.AssetId);
                        }//End of If
                    }//END of FOR
                }//End of If
                
            }//End of If
        }//End of If
    }//End of Method
    
    public static void validateNonSerializedProduct(LIST<Case> newCases){
        Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        List<Case> NewRMACases = new List<Case>();
        Set<Id> ProductIds = new Set<Id>();
        for(Case Newcase : NewCases)
        {
            if(Newcase.RecordTypeId == recordTypeIdRMA && Newcase.AssetId == null && Newcase.ProductId != null)
            {
                NewRMACases.add(Newcase);      
                ProductIds.add(Newcase.ProductId);
            }//End of If
        }//End of For
        if(!NewRMACases.isEmpty() && !ProductIds.isEmpty()){
            system.debug('*****Inside validateNonSerializedProduct*****'+NewRMACases);
            List<Product2> listProducts = new List<Product2>();   
            Set<Id> serializedProducts = new Set<Id>();
            if(!ProductIds.IsEmpty()){
                listProducts = [Select Id,ProductCode,Serialized__c from Product2 where Id IN :ProductIds];
            }
            
            if(!listProducts.isEmpty()){
                for(Product2 rmaProduct:listProducts){
                    if(rmaProduct.Serialized__c == true){
                        serializedProducts.add(rmaProduct.Id);
                    }
                }//END of FOR
                system.debug('****listProducts****'+listProducts);
                system.debug('****serializedProducts****'+serializedProducts);
                if(!NewRMACases.isEmpty() && !serializedProducts.isEmpty()){
                    for(Case c: NewRMACases){
                        if(c.ProductId != null && c.AssetId == null && c.Serial_Number_Customer__c==null && serializedProducts.contains(c.ProductId)){
                            c.ProductId.addError(label.ValidateNonSerializedProduct); 
                        }//End of If
                    }//END of FOR
                }//End of If
                
            }//End of If
        }//End of If 
        
    }
    
    
    public static void updateTimetoTier4Assign(LIST<Case> newCases,MAP<Id,Case> oldCaseMAP){
        Id recordTypeIdTier4 = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TER').getRecordTypeId();
        List<Case> NewTier4Cases = new List<Case>();
        Set<Id> groupIds = new Set<Id>();
        for(Case Newcase : newCases)
        {
            system.debug(Newcase.OwnerId != oldCaseMAP.get(Newcase.id).ownerID );
            system.debug(Newcase.OwnerId);
            system.debug(oldCaseMAP.get(Newcase.id).ownerID );
            if(Newcase.RecordTypeId == recordTypeIdTier4 && Newcase.OwnerId != oldCaseMAP.get(Newcase.id).ownerID && Newcase.Tier4_Time_to_Assign__c == null)
            {
                NewTier4Cases.add(Newcase);       
            }
        }
        system.debug('***Cases to Update***'+NewTier4Cases);
        if(!NewTier4Cases.isEmpty()){
            list<Group> Tier4QueueIds = [select Id,Name from Group where Name = 'Technical Escalation Queue' and Type = 'Queue'];
            if(!Tier4QueueIds.isEmpty()){
                for(Group tier4Grp: Tier4QueueIds){
                    groupIds.add(tier4Grp.Id);
                }
                system.debug('***QueueIds***'+groupIds);
                if(!groupIds.isEmpty() && !NewTier4Cases.isEmpty()){
                    for(Case c: NewTier4Cases){
                        if(c.OwnerId != oldCaseMAP.get(c.id).OwnerId && groupIds.contains(oldCaseMAP.get(c.id).OwnerId) && !groupIds.contains(c.OwnerId) && c.Tier4_Time_to_Assign__c == null){
                            c.Tier4_Time_to_Assign__c = system.now();
                            system.debug('****Tier4 Time to Assign***'+c.Tier4_Time_to_Assign__c);
                        }
                    }
                }
            }
        }
        
    }
    
    
    public static void validateTACOwnership(LIST<Case> newCases,MAP<Id,Case> oldCaseMAP){
        Id recordTypeIdTAC = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TSR').getRecordTypeId();
        Set<string> groupSet=new Set<string>();
        Set<string>  userSet=new Set<string>();
        List<validateTACOwnership__c> vTAC = validateTACOwnership__c.getAll().values();
        for(validateTACOwnership__c v:vTAC){
            if(v.IsQueue__c==True){
                groupSet.add(v.Name);
            }
            if(v.IsProfile__c==True){
                userSet.add(v.name);
            }
            
        }
        
        /* if(validateTACOwnership__c.IsUser__c){
userSet=Label.validateTACOwnership;
}*/
        List<Case> NewTACCases = new List<Case>();
        for(Case Newcase : newCases)
        {
            if(Newcase.RecordTypeId == recordTypeIdTAC && Newcase.OwnerId != oldCaseMAP.get(Newcase.id).ownerID )
            {
                NewTACCases.add(Newcase);       
                
            }
        }
        System.debug('Cases to updated'+NewTACCases);
        if(!NewTACCases.isEmpty()){
            list<Group> TACQueueIds = [select Id,Name from Group where Name IN : groupSet];
            list<user> Users = [SELECT Id, profile.name FROM User where profile.name in :userSet];
            Set<Id> groupIds = new Set<Id>();
            Set<Id> UserIds = new Set<Id>();
            if(!TACQueueIds.isEmpty() && !Users.isEmpty()){
                for(Group tacGroup : TACQueueIds){
                    groupIds.add(tacGroup.id);
                    
                } 
                system.debug('***QueueIds***'+groupIds);
                for(User u: Users){
                    UserIds.add(u.id);
                }
                system.debug('***UserIds***'+UserIds);
                if(!groupIds.isEmpty() && !UserIds.isEmpty()){
                    for(Case c: NewTACCases){
                        system.debug('***Inside For***'+c.OwnerId +'****Old Owner****' +oldCaseMAP.get(c.id).OwnerId );
                        if(c.OwnerId != oldCaseMAP.get(c.id).OwnerId && !(groupIds.contains(c.OwnerId) || UserIds.contains(c.OwnerId))){
                            c.addError('Incorrect TAC Case Owner!');  
                        }
                    }
                }
                
            }
        }
        
    }
    
    
    
    public static void preventTACChangeRMAOwnership(LIST<Case> newCases,MAP<Id,Case> oldCaseMAP){
        Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        List<Case> NewRMACases = new List<Case>();
        for(Case Newcase : NewCases)
        {
            if(Newcase.RecordTypeId ==recordTypeIdRMA && Newcase.OwnerId != oldCaseMAP.get(Newcase.id).ownerID )
            {
                NewRMACases.add(Newcase);       
                
            }
        }
        System.debug('Cases to updated'+NewRMACases);
        if(!NewRMACases.isEmpty())
        {
            set<Id> updatedCaseIds = new Set<id>();
            //current user profile id
            Id LoggedIdUserID=UserInfo.getUserId();
            MAP<id, String> UserWithProfile = new Map<id, string>();
            
            list<Group> RMAQueueID = [select Id from Group where Name = 'Hardware Delivery Queue' and Type = 'Queue'];
            list<user> Users = [SELECT Id, profile.name FROM User where profileid in (select id from Profile where name in ('Service Logistics User','Service Logistics Manager', 'Call Center User', 'Technical Support Manager', 'Technical Support User','Escalation Support User'))];
            set<id> UserIds = new set<id>();
            if(!Users.IsEmpty()){
                for(User u : Users)
                {
                    UserIds.add(u.id);
                    UserWithProfile.put(u.id, u.profile.name);
                }
            }
            if(!NewRMACases.IsEmpty()){
                for(case c : NewRMACases)
                {
                    if(UserIds.contains(LoggedIdUserID))
                    {
                        system.debug('********^^^^^^^^^^^'+UserWithProfile.get(oldCaseMAP.get(c.id).Ownerid));
                        if( UserWithProfile.get(LoggedIdUserID) == 'Call Center User' ||UserWithProfile.get(LoggedIdUserID) == 'Technical Support Manager' ||UserWithProfile.get(LoggedIdUserID) == 'Technical Support User' ||UserWithProfile.get(LoggedIdUserID) == 'Escalation Support User')
                        {
                            if((UserIds.contains(oldCaseMAP.get(c.id).Ownerid) && (UserWithProfile.get(oldCaseMAP.get(c.id).Ownerid) == 'Service Logistics User' || UserWithProfile.get(oldCaseMAP.get(c.id).Ownerid) == 'Service Logistics Manager'))||(oldCaseMAP.get(c.id).Ownerid == RMAQueueID.get(0).id))
                            {
                                c.addError('TAC users cannot change the owner of RMA case!');  
                            }
                        }
                    }
                }
            }
        }
        system.debug('************'+newCases);
    }
    /******************************************************************************************************
* Purpose                   : This method is called while Service Contact on the Case is NUll.  
******************************************************************************************************/    
    public static void clearCaseFieldsUpdate(LIST<Case> newCases,MAP<Id,Case> oldCaseMAP){
        
        for(Case c:newCases){
            if(c.Service_Contact__c == Null && oldCaseMAP.containsKey(c.Id) && c.Service_Contact__c != oldCaseMAP.get(c.Id).Service_Contact__c){
                c.AccountId = Null;
                c.ContactId = Null;
                c.ServiceAccount__c = Null;
                system.debug('---------------------NULL');
            }
            
        }
        system.debug('************'+newCases);
    }   
    
    /******************************************************************************************************
* Purpose                   : This method is called while Case is updated.  
******************************************************************************************************/
    /*   public static void autoPopulateCaseFieldsUpdate(LIST<Case> newCases,MAP<Id,Case> oldCaseMAP){
Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByName().get('RMA').getRecordTypeId();
LIST<Case> updatedCases = new LIST<Case>();
System.debug('*******New Cases******'+newCases);
for(Case c:newCases){
System.debug('*****RMA Shipt To*****'+c.RMA_Ship_To__c);
System.debug('*****RMA Shipt To Country*****'+c.ShipToCountry__c);
if(c.RMA_Ship_To__c != Null && c.RecordTypeId == recordTypeIdRMA && oldCaseMAP.containsKey(c.Id)){
updatedCases.add(c);
}else if(c.RMA_Ship_To__c == Null && c.RecordTypeId == recordTypeIdRMA && oldCaseMAP.containsKey(c.Id)){
c.ReturnToAddressee__c = Null;
c.ReturnToAddress__c = Null;
c.ReturnToAddress2__c = Null;
c.ReturnToAddress3__c = Null;
c.ReturnToCity__c = Null;
c.ReturnToCountry__c = Null;
c.ReturnToProvince__c = Null;
c.ReturnToState__c = Null;
c.ReturnToZip__c = Null;
c.ReturnCustomerSiteInfo__c = Null;
}   //END IF

}//END FOR
system.debug('****Updated Cases*****'+updatedCases);
if(!updatedCases.isEmpty()){
autoPopulateCaseFieldsInsert(updatedCases);
}//END IF 
system.debug('************'+newCases);
}//END METHOD    */
    /******************************************************************************************************
* Purpose                   : This method is called while Case is updated. Auto populate case fields.
*                             Populate return to address.
******************************************************************************************************/
    
    /* public static void autoPopulateCaseFieldsInsert(LIST<Case> newCases){
Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByName().get('RMA').getRecordTypeId();
LIST<Case> autoPopulateCases = new LIST<Case>();
Set<String> RMAShipToCountries = new Set<String>();
ReturnAddresses__c defaultAddress = new ReturnAddresses__c();
LIST<ReturnAddresses__c> rmaReturnAddress = new LIST<ReturnAddresses__c>();
for(Case c:newCases){
System.debug('*******New Cases******'+newCases);
System.debug('*****RMA Shipt To*****'+c.RMA_Ship_To__c);
System.debug('*****RMA Shipt To Country*****'+c.ShipToCountry__c);
if(c.RMA_Ship_To__c != Null && c.RecordTypeId == recordTypeIdRMA){
autoPopulateCases.add(c);
RMAShipToCountries.add(c.ShipToCountry__c);
}//END IF  
}//END FOR


if(!RMAShipToCountries.isEmpty()){
RMAShipToCountries.add('United States');
System.debug('********RMA Countries*********'+RMAShipToCountries);
rmaReturnAddress = [SELECT Id,Name,Return_to_Zip__c,ReturnToAddress__c,ReturnToAddress2__c,ReturnToAddress3__c,ReturnToCity__c,ReturnToCountry__c,ReturnToProvince__c,ReturnToState__c,ReturnCustomerSiteInfo__c,LookUpCountries__c FROM ReturnAddresses__c where LookUpCountries__c IN :RMAShipToCountries];
}//END IF

if(!autoPopulateCases.IsEmpty()){
for(Case c: autoPopulateCases){
if(c.RMA_Ship_To__c != Null && c.RecordTypeId == recordTypeIdRMA){
System.debug('******RMA Return Addresses*****'+rmaReturnAddress);
if(!rmaReturnAddress.IsEmpty()){
for(ReturnAddresses__c r:rmaReturnAddress){
if(r.LookUpCountries__c == 'United States' && defaultAddress.Id == Null){
defaultAddress = r;
system.debug('***Default Address****'+defaultAddress);
}//END IF

System.debug('***** Inside RMA Shipt To*****'+c.RMA_Ship_To__c);
System.debug('*****Inside RMA Shipt To Country*****'+c.ShipToCountry__c);
System.debug('*********Inside Return Country*******'+r.LookUpCountries__c);
System.debug('********Case Ship to Country*******'+c.ShipToCountry__c);
if(c.ShipToCountry__c == r.LookUpCountries__c){
system.debug('******LookupCountries****'+r.LookUpCountries__c);
c.ReturnToAddressee__c = r.Name;
c.ReturnToAddress__c = r.ReturnToAddress__c;
c.ReturnToAddress2__c = r.ReturnToAddress2__c;
c.ReturnToAddress3__c = r.ReturnToAddress3__c;
c.ReturnToCity__c = r.ReturnToCity__c;
c.ReturnToCountry__c = r.ReturnToCountry__c;
c.ReturnToProvince__c = r.ReturnToProvince__c;
c.ReturnToState__c = r.ReturnToState__c;
c.ReturnToZip__c = r.Return_to_Zip__c;
c.ReturnCustomerSiteInfo__c = r.ReturnCustomerSiteInfo__c;
}//END IF
}//END FOR
}
If(c.ReturnToCountry__c == Null){
system.debug('******Inside Default Return Country****'+c.ReturnToCountry__c);
system.debug('******Inside Default Ship Country****'+c.ShipToCountry__c);
c.ReturnToAddressee__c = defaultAddress.Name;
c.ReturnToAddress__c = defaultAddress.ReturnToAddress__c;
c.ReturnToAddress2__c = defaultAddress.ReturnToAddress2__c;
c.ReturnToAddress3__c = defaultAddress.ReturnToAddress3__c;
c.ReturnToCity__c = defaultAddress.ReturnToCity__c;
c.ReturnToCountry__c = defaultAddress.ReturnToCountry__c;
c.ReturnToProvince__c = defaultAddress.ReturnToProvince__c;
c.ReturnToState__c = defaultAddress.ReturnToState__c;
c.ReturnToZip__c = defaultAddress.Return_to_Zip__c;
c.ReturnCustomerSiteInfo__c = defaultAddress.ReturnCustomerSiteInfo__c;
}//END IF
}//END IF    
}//END FOR
}
system.debug('************'+newCases);
}//END METHOD */
    
    /******************************************************************************************************
* Purpose                   : This method is called while Case is updated and Asset is changed.  
******************************************************************************************************/
    public static void checkAssetOnCaseUpdate(LIST<Case> newCases,MAP<Id,Case> oldCaseMAP){
        LIST<Case> updatedCases = new LIST<Case>();
        for(Case c:newCases){
            if(c.AssetId != null && oldCaseMAP.containsKey(c.Id) && (c.AssetId != oldCaseMAP.get(c.Id).AssetId || c.RecordTypeId != oldCaseMAP.get(c.Id).RecordTypeId) ){
                updatedCases.add(c);
            }//END IF
            
        }//END FOR
        if(!updatedCases.isEmpty()){
            //checkAsset(updatedCases);
        }//END IF 
        system.debug('************'+newCases);
    }//END METHOD
    
    /******************************************************************************************************
* Purpose                   : This method is called while Case is Inserted and also from Update 
*                             for eligible records. Check if asset is already assigned to another RMA or FA case. 
******************************************************************************************************/
    /*
public static void checkAsset(LIST<Case> newCases){

Set<Id> assetID = new Set<ID>();
// Get the Record Type Id from the Utility Class
Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByName().get('RMA').getRecordTypeId();
Id recordTypeIdFA = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FA').getRecordTypeId();
Id recordTypeIdFAInternal = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FA Internal').getRecordTypeId();
Id recordTypeIdFAComponent = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FA Component').getRecordTypeId();    
LIST<id> recordids = new LIST<id>();
recordids.add(recordTypeIdRMA);
recordids.add(recordTypeIdFA);
recordids.add(recordTypeIdFAInternal);
recordids.add(recordTypeIdFAComponent);
MAP<id,Asset> AssetMAP;
string caseNo;
System.debug('****RMA record type*****' +recordTypeIdRMA);
for(Case c :newCases){
if(c.AssetId != null){
assetID.add(c.AssetId);
}//END IF  
}//END FOR
System.debug('****Asset Ids*****' +assetID);
if(!assetID.isEmpty()){
AssetMAP = new MAP<id,Asset>([SELECT id,(SELECT Id,AssetId,CaseNumber,RecordTypeId,Status FROM Cases where RecordTypeId in :recordids and Status != 'Closed' and Status != 'Closed - Invoiced' and Status != 'Closed - Written Off' and Status != 'Cancelled') FROM Asset WHERE id IN :assetID ]);
System.debug('*****Asset MAP****' +AssetMAP);        
if(!AssetMAP.isEmpty()){
for(Case c :newCases){
if(c.AssetId != null && AssetMAP.containsKey(c.AssetId)){
for(Case c1 :AssetMAP.get(c.AssetId).Cases){
if((c.recordtypeid == recordTypeIdRMA)&&
(c1.recordtypeid == recordTypeIdFA ||
c1.recordtypeid == recordTypeIdFAInternal ||
c1.recordtypeid == recordTypeIdFAComponent ||
c1.recordtypeid == recordTypeIdRMA))
{
if(String.isBlank(caseNo)){
caseNo = 'Asset is already assigned to case with Case Number: '+c1.CaseNumber;
}else{
caseNo = caseNo + ' , ' + c1.CaseNumber;  
}

}
else if((c.recordtypeid == recordTypeIdFA ||
c.recordtypeid == recordTypeIdFAInternal ||
c1.recordtypeid == recordTypeIdFAComponent) &&
(c1.recordtypeid == recordTypeIdFA ||
c1.recordtypeid == recordTypeIdFAInternal ||
c1.recordtypeid == recordTypeIdFAComponent))
{
if(String.isBlank(caseNo)){
caseNo = 'Asset is already assigned to Open FA cases with Case Number: '+c1.CaseNumber;
}else{
caseNo = caseNo + ' , ' + c1.CaseNumber;  
} 

}

}//END FOR

if(!Test.isRunningTest()){  
if(!String.isBlank(caseNo)){
c.assetid.addError(caseNo);
}//END IF
}//END IF
}//END IF
}//END FOR 
}//END IF
}//END IF
system.debug('************'+newCases);
}//END METHOD */
    
    //******************************************************************************************************    
    public static void checkAsset(LIST<Case> newCases){
        
        Set<Id> assetID = new Set<ID>();
        /* Get the Record Type Id from the Utility Class */
        Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        Id recordTypeIdFA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('FA').getRecordTypeId();
        Id recordTypeIdFAInternal = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id recordTypeIdFAComponent = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FA Component').getRecordTypeId();    
        LIST<id> recordids = new LIST<id>();
        recordids.add(recordTypeIdRMA);
        recordids.add(recordTypeIdFA);
        recordids.add(recordTypeIdFAInternal);
        recordids.add(recordTypeIdFAComponent);
        List<Case> newAssetCases = new List<Case>();
        System.debug('****RMA record type*****' +recordTypeIdRMA);
        map<id,string> mapAssetWithAllCase = new map<Id,string>();
        map<id,string> mapAssetWithFACases = new map<Id,string>();
        for(Case c :newCases){
            if(c.AssetId != null){
                assetID.add(c.AssetId);
            }//END IF  
        }//END FOR
        
        System.debug('****Asset Ids*****' +assetID);
        if(!assetID.isEmpty()){
            newAssetCases = [SELECT Id,AssetId,CaseNumber,RecordTypeId,Status,RMALineItem__r.ReceivedMismatch__c,(Select Id,ReceivedMismatch__c,Replacement_Return_Flag__c from RMA_Line_Items__r where ReceivedMismatch__c != true and Status__c != 'Closed' and Status__c != 'Closed - Invoiced' and Status__c != 'Closed - Written Off' and Status__c != 'Cancelled') FROM Case where RecordTypeId in :recordids and assetid IN :assetID and Status != 'Closed' and Status != 'Closed - Invoiced' and Status != 'Closed - Written Off' and Status != 'Cancelled' and RMALineItem__r.ReceivedMismatch__c != true]; 
            system.debug('****newAssetCases*****  '+newAssetCases );
            if(!newAssetCases.isEmpty()){
                for(Case c: newAssetCases){
                    system.debug('****c.RMA_Line_Items__r*****  '+c.RMA_Line_Items__r); 
                    system.debug('****c.RMA_Line_Items__r*****  '+c.RMA_Line_Items__r.size());
                    if((c.RecordTypeId == recordTypeIdRMA && c.RMA_Line_Items__r.size() > 0) || c.RecordTypeId == recordTypeIdFA || c.RecordTypeId == recordTypeIdFAInternal || c.RecordTypeId == recordTypeIdFAComponent){
                        if(c.AssetId != null && mapAssetWithAllCase.containsKey(c.AssetId)){
                            String tempString = mapAssetWithAllCase.get(c.AssetId);
                            tempString = tempString + ' , ' + c.CaseNumber;  
                            mapAssetWithAllCase.put(c.AssetId,tempString);
                        }else if(c.AssetId != null && !mapAssetWithAllCase.containsKey(c.AssetId)){
                            mapAssetWithAllCase.put(c.AssetId,c.CaseNumber);
                        }//END IF
                    }//END IF
                    System.debug('****mapAssetWithAllCase***** ' +mapAssetWithAllCase);
                    if(c.RecordTypeId == recordTypeIdFA || c.RecordTypeId == recordTypeIdFAInternal || c.RecordTypeId == recordTypeIdFAComponent){
                        if(c.AssetId != null && mapAssetWithFACases.containsKey(c.AssetId)){
                            String tempString = mapAssetWithFACases.get(c.AssetId);
                            tempString = tempString + ' , ' + c.CaseNumber;  
                            mapAssetWithFACases.put(c.AssetId,tempString);
                        }else if(c.AssetId != null && !mapAssetWithFACases.containsKey(c.AssetId)){
                            mapAssetWithFACases.put(c.AssetId,c.CaseNumber);
                        }//END IF
                        
                    }//END IF
                }//END FOR   
                System.debug('****mapAssetWithAllCase***** ' +mapAssetWithAllCase);
                System.debug('****mapAssetWithFACases***** ' +mapAssetWithFACases);
                if(!mapAssetWithAllCase.isEmpty() || !mapAssetWithFACases.isEmpty()){
                    if(!newCases.IsEmpty()){
                        for(Case c: newCases){
                            System.debug('****inside FOR***** ');
                            if(c.RecordTypeId == recordTypeIdRMA && c.Assetid != null && mapAssetWithAllCase.containsKey(c.AssetId)){
                                System.debug('****inside RMA***** ');
                                c.assetid.addError('Asset is already assigned to case with Case Number: '+mapAssetWithAllCase.get(c.AssetId));          
                            }else if((c.RecordTypeId == recordTypeIdFA || c.RecordTypeId == recordTypeIdFAInternal || c.RecordTypeId == recordTypeIdFAComponent) && c.Assetid != null && mapAssetWithFACases.containsKey(c.AssetId)){
                                System.debug('****inside FA***** ');
                                c.assetid.addError('Asset is already assigned to case with Case Number: '+mapAssetWithFACases.get(c.AssetId));  
                            }//END IF 
                            
                        }//END FOR 
                    }
                }//END IF 
            }//END IF   
        }//END IF
    }//END of Method
    
    //*****************************************************************************************************    
    /******************************************************************************************************
* Purpose                   : This method is called to change FA case status to Cancelled when RMA is Cancelled
******************************************************************************************************/
    public static void CancelFAOnRMA(LIST<case> newcases, MAP<id,case> oldcases)
    {
        LIST<id> ids = new LIST<id>();
        LIST<case> FilteredRMACases = new LIST<case>();
        LIST<case> CasesToUpdate = new LIST<case>();
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        for(case c: newcases)
        {
            if((c.status=='Cancelled' && c.recordtypeid == devRecordTypeId) ||(c.status!= 'Cancelled' && oldcases.get(c.id).status == 'Cancelled' && c.recordtypeid == devRecordTypeId))
            {
                ids.add(c.id);
                FilteredRMACases.add(c);
            }
        }//END FOR
        
        if(!FilteredRMACases.isEmpty())
        {
            MAP<id, case> FACases = new MAP<id, case>([select id,status, (select id, status from cases) from case where id in:ids]);
            for(case c : FilteredRMACases)
            {
                if(!FACases.IsEmpty() && FACases.containskey(c.Id) && !FACases.get(c.Id).cases.IsEmpty()){
                    for(case FACase: FACases.get(c.Id).cases){
                        if(c.status == 'Cancelled')
                        {                           
                            FACase.status = 'Cancelled'; 
                            CasesToUpdate.add(FACase);
                            
                        }//END IF
                        else
                        {
                            FACase.status = 'New'; 
                            CasesToUpdate.add(FACase);
                        }//END ELSE 
                    }
                }
            }//END FOR
            if(!CasesToUpdate.isEmpty())
                update CasesToUpdate;
        }//END IF
        
    }//END METHOD
    
    //*****************************************************************************************************    
    /******************************************************************************************************
* Purpose                   : This method is called to update FA completed field on RMA from Final Approved Date of FA
******************************************************************************************************/
    public static void UpdateFACompletedDate(LIST<case> newcases, MAP<id,case> oldcases)
    {
        SET<Id> RMAcasesIds = new SET<Id>();
        MAP<Id,Case> MapOfRMAwithFACases = new Map<Id,Case>();
        LIST<case> CasesToUpdate = new LIST<case>();
        Id FARecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('FA').getRecordTypeId();
        for(case c: newcases)
        {
            if(c.ParentId != null  && oldcases.get(c.id).FinalApprovedDate__c != c.FinalApprovedDate__c && c.recordtypeid == FARecordTypeId )
            {
                RMAcasesIds.add(c.ParentId);
                MapOfRMAwithFACases.put(c.ParentId,c);
                
            }
        }//END FOR
        
        if(!RMAcasesIds.isEmpty())
        {
            for(case RMAcases : [SELECT id,FA_Completed__c,FA_Completed_Checkbox__c FROM Case WHERE id IN: RMAcasesIds])
            {
                if(MapOfRMAwithFACases.containsKey(RMAcases.id)){
                    RMAcases.FA_Completed__c=MapOfRMAwithFACases.get(RMAcases.id).FinalApprovedDate__c;
                    RMAcases.FA_Completed_Checkbox__c=true;
                    CasesToUpdate.add(RMAcases);
                }
                
            }//END FOR*/
            
            if(!CasesToUpdate.isEmpty())
                update CasesToUpdate;
        }//END IF
        
    }//END METHOD
    /******************************************************************************************************
* Purpose                   : Update rma line item status on rma type return consigned good
******************************************************************************************************/
    public static void UpdateRMALineItemStatusOnConsignedGood(List<case> NewRecords, Map<id, case> OldRecordMap)
    {
        List<id> caseIds = new List<id>();
        List<Rma_Line_Item__c> RMAList = new List<Rma_Line_Item__c>();
        for(Case SingleCase : NewRecords)
        {
            if((SingleCase.RMAType__c != OldRecordMap.get(SingleCase.id).RMAType__c) && SingleCase.RMAType__c == 'Return Consigned Goods')
            {
                caseIds.add(SingleCase.id);
            }//END IF
        }//END FOR
        if(!caseIds.isEmpty())
        {
            RMAList = [select status__c from rma_line_item__c where case__c in: caseIds];
            if(!RMAList.IsEmpty()){
                for(rma_line_item__c RLI : RMAList)
                {
                    RLI.Status__c = 'Closed';   
                }//END FOR
                update RMAList;
            }
        }//END IF
        system.debug('************'+NewRecords);
    }//END METHOD
    /******************************************************************************************************
* Purpose                   : Update rma case owner after sending to sap
******************************************************************************************************/
    public static void UpdateRMACaseOwnerOnSendToSap(List<case> NewRecords, Map<id, case> OldRecordMap)
    {
        System.debug('UpdateRMACaseOwnerOnSendToSap');
        ID RMARecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        List<ID> UpdatedCaseIds = new list<id>();
        map<id, Case> ParentTacCases;
        List<Case> UpdatedCases = new List<case>();
        for(Case SingleCase : NewRecords)
        {
            System.Debug('SingleCase.Owner.Name:'+SingleCase.Owner.Name);
            System.debug('SingleCase.OwnerId:'+SingleCase.OwnerId);
            System.debug('Label.RMASLAutomationQueueId:'+Label.RMASLAutomationQueueId);
            System.debug('SingleCase.Order_Name__c:'+SingleCase.Order_Name__c);
            if((string.valueOf(SingleCase.OwnerId).startsWith('005') && 
                //SingleCase.parentid!= null && 
                SingleCase.RecordTypeId == RMARecordTypeID && 
                SingleCase.Order_Name__c != null && 
                SingleCase.Order_Name__c != 'Error' && 
                SingleCase.Order_Name__c != 'SenttoSAP' && 
                SingleCase.Status == 'Shipped not Received' && 
                SingleCase.Status!= OldRecordMap.get(SingleCase.id).Status)||(SingleCase.RecordTypeId == RMARecordTypeID && 
                                                                              SingleCase.Order_Name__c != null && 
                                                                              SingleCase.Order_Name__c != 'Error' && 
                                                                              SingleCase.Order_Name__c != 'SenttoSAP' && 
                                                                              SingleCase.Status == 'Shipped not Received' && SingleCase.OwnerId==Label.RMASLAutomationQueueId))
            {
                UpdatedCaseIds.add(SingleCase.id);
                UpdatedCases.add(SingleCase);
            }//END IF
        }//END FOR
        System.debug('UpdatedCases:'+UpdatedCases);
        if(!UpdatedCaseIds.isEmpty())
        {
            ParentTacCases = new map<id,case>([select id,parent.ownerid,createdbyId from case where id in : UpdatedCaseIds]);
            If(!UpdatedCases.IsEmpty()){
                for(Case SingleUpdatedCase : UpdatedCases)
                {    
                    System.debug('SingleUpdatedCase :'+SingleUpdatedCase );
                    if(SingleUpdatedCase.ParentId != Null){
                        //SingleUpdatedCase.OwnerId = ParentTacCases.get(SingleUpdatedCase.id).parent.OwnerId;
                        SingleUpdatedCase.OwnerId = Label.Tier2QueueId;
                    }
                    else{
                        //SingleUpdatedCase.OwnerId = ParentTacCases.get(SingleUpdatedCase.id).createdbyId;  
                        SingleUpdatedCase.OwnerId = Label.Tier2QueueId;
                    }
                    
                }//END FOR
                System.debug('updatedCases[0].OwnerId:'+updatedCases[0].OwnerId);
                System.debug('Label.Tier2QueueId:'+Label.Tier2QueueId);
            }
        }//END IF
        system.debug('************'+NewRecords);
    }//END METHOD
    /******************************************************************************************************
* Purpose                   : Update RMA Line Item on Case Reason/Send to SAP Date change
******************************************************************************************************/      
    public static void UpdateRmaLineItemforSLARecalculation(List<case> NewRecords, Map<id, case> OldRecordMap)
    {  
        ID RMARecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        List<ID> UpdatedCaseIds = new list<id>();
        list<RMA_Line_Item__c> RMALineItems;
        for(Case SingleCase : NewRecords)
        {
            if(SingleCase.recordtypeid == RMARecordTypeID && 
               ((SingleCase.Reason != OldRecordMap.get(SingleCase.id).Reason &&
                 SingleCase.Reason != null) || 
                (SingleCase.SentToSAPDate__c != OldRecordMap.get(SingleCase.id).SentToSAPDate__c &&
                 SingleCase.SentToSAPDate__c != null))){
                     UpdatedCaseIds.add(SingleCase.id);
                 }//END IF
        }//END FOR
        if(!UpdatedCaseIds.isEmpty())
        {
            RMALineItems = [select id,Status__c, case__c from RMA_Line_Item__c where case__c in: UpdatedCaseIds];
            if(!RMALineItems.isEmpty()){
                update RMALineItems;         
            }
        }
        system.debug('************'+NewRecords);
    }
    /******************************************************************************************************
* Purpose                   : UpdatE RMA Line Item status on if order name is filled with no errors
******************************************************************************************************/    
    public static void UpdateRmaLineItemStatusToOpenOnSentToSap(List<case> NewRecords, Map<id, case> OldRecordMap)
    {
        ID RMARecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        List<ID> UpdatedCaseIds = new list<id>();
        list<RMA_Line_Item__c> RMALineItems;
        list<RMA_Line_Item__c> FinalRmaList = new list<RMA_Line_Item__c>();
        map<id, list<RMA_Line_Item__c>> RMALineItemMapWithRMACase =new map<id, list<RMA_Line_Item__c>>();
        List<Case> UpdatedCases = new List<case>();
        for(Case SingleCase : NewRecords)
        {
            if(SingleCase.RecordTypeId == RMARecordTypeID && 
               SingleCase.Order_Name__c != null && 
               SingleCase.Order_Name__c != 'Error' && 
               SingleCase.Order_Name__c != 'SenttoSAP' && 
               SingleCase.Status != 'Closed' &&
               SingleCase.Status != 'Closed - Written Off' && 
               SingleCase.Status != 'Closed - Invoiced' &&
               SingleCase.Order_Name__c != OldRecordMap.get(SingleCase.id).Order_Name__c
              )
            {
                UpdatedCaseIds.add(SingleCase.id);
                UpdatedCases.add(SingleCase);
            }//END IF
        }//END FOR
        if(!UpdatedCaseIds.isEmpty())
        {
            RMALineItems = [select id,Status__c, case__c from RMA_Line_Item__c where case__c in: UpdatedCaseIds];
            if(!RMALineItems.IsEmpty()){
                for(RMA_Line_Item__c SingleRMALine: RMALineItems)
                {
                    if(RMALineItemMapWithRMACase.containsKey(SingleRMALine.Case__c))
                        RMALineItemMapWithRMACase.get(SingleRMALine.case__c).add(SingleRMALine);
                    else
                    {
                        list<RMA_Line_Item__c> TempRMALine = new List<RMA_Line_Item__c>();
                        TempRMALine.add(SingleRMALine);
                        RMALineItemMapWithRMACase.put(SingleRMALine.case__c, TempRMALine);
                    }//END ELSE
                    
                }//END FOR
            }
            If(!UpdatedCases.IsEmpty()){
                for(Case SingleRMACase : UpdatedCases)
                {
                    if(RMALineItemMapWithRMACase.containsKey(SingleRMACase.id))
                    {
                        for(RMA_Line_Item__c SingleRMALine : RMALineItemMapWithRMACase.get(SingleRMACase.id))
                        {
                            SingleRMALine.status__c = 'Open';
                            FinalRmaList.add(SingleRMALine);
                        }//END FOR                
                    }//END IF
                }//END FOR
            }
            if(!FinalRmaList.isEmpty())
                update FinalRmaList;
        }//END IF 
        system.debug('************'+NewRecords);
    }//END METHOD
    /******************************************************************************************************
* Purpose                   : This method is used create FA case on modification of Order Name from RMA
******************************************************************************************************/   
    public static void CreateFAOnRma(LIST<case> newcases, MAP<id,case> oldcases)
    {
        /* 
LIST<id> ids = new LIST<id>();
LIST<id> ParentCaseIds = new LIST<id>();
LIST<case> CasesToUpdate = new LIST<case>();
LIST<case> FACasesToInsert = new LIST<case>();
LIST<case> ParentCases = new LIST<case>();
LIST<RMA_LINE_ITEM__c> RMALineItems = new LIST<RMA_LINE_ITEM__c>();
Group FAQueue;
Id devRecordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByName().get('RMA').getRecordTypeId();
Id devRecordTypeIdFA = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FA').getRecordTypeId();
for(case c: newcases)
{
if(c.recordtypeid == devRecordTypeIdRMA && c.Order_Name__c != oldcases.get(c.id).Order_Name__c && oldcases.get(c.id).Order_Name__c == null)
{
ids.add(c.id);
ParentCaseIds.add(c.parentid);
CasesToUpdate.add(c);
}
}

if(CasesToUpdate.size()>0)
{
FAQueue = [select Id from Group where Name = 'FAQueue' and Type = 'Queue'][0];
RMALineItems =[select FMA_Requested__c,Symptom_Code__c,Sub_Symptom_Code__c,Special_FA__c,SCARNumber__c, case__c, id from rma_line_item__C where case__c in: ids];
ParentCases = [select parentid from case where id in: ParentCaseIds];
for(Case c : CasesToUpdate)
{
for(RMA_LINE_ITEM__c RMALineItem : RMALineItems)
{
if(RMALineItem.case__c == c.id)
{
Case FACase = new case(
recordtypeid = devRecordTypeIdFA,
FMARequested__c = RMALineItem.FMA_Requested__c,
SCAR__c = RMALineItem.SCARNumber__c,
Service_Contact__c = c.Service_Contact__c,
accountid = c.accountid,
type= c.type,
ParentId = c.id,
Origin = c.origin,
Assetid = c.assetid,
subject = c.subject,
description = c.Description,
RMALineItem__c = RMALineItem.id,
FARequest__c = RMALineItem.FMA_Requested__c,
Special_FA__c = RMALineItem.Special_FA__c,
ownerid = FAQueue.id

//FA_Received_Date__c= c.CreatedDate
);
for(case ParentCase : ParentCases)
{
if(c.parentid == ParentCase.id)
{
FACase.TACCase__c = ParentCase.id;
break;
}
}
FACasesToInsert.add(FACase);
break;
}
}
}
system.debug('****'+FACasesToInsert);
if(FACasesToInsert.size()>0)
{
try
{
insert FACasesToInsert;
}
catch (Exception e) {
for (case c : newcases) {
c.addError(e.getMessage(), false);
}
}

}


} */
    }
    
    /*************************************************************************************************************************
Purpose:- Set value of FA due date depending on TAC and FA network impact, severity values
*************************************************************************************************************************************/
    
    public static void TACFAPickLISTDependancy(LIST<case> NewRecords, MAP<id,case> OldRecordMAP)
    {
        LIST<id> CaseIds = new LIST<id>();
        LIST<case> NewCases =new LIST<case>();
        MAP<id, case> CaseWithTACDetails;
        LIST<DueDateLogic__c> DueDateLogic = new LIST<DueDateLogic__c>();
        id FARecordID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('FA').getRecordTypeId();
        
        for(case c : NewRecords)
        {       system.debug('@@@@@@@@@@@@@@'+ c.parentid);
         system.debug('@@@@@@@@@@@@@@'+ c.RecordTypeId);
         system.debug( '@@@@@@@@@@@@@@'+c.FA_Received_Date__c);
         if( c.parentid!=null && c.RecordTypeId == FARecordID && c.FA_Received_Date__c !=null)
         {    system.debug( '@@@@@@@@@@@@@@'+c.parentid);
          system.debug( '@@@@@@@@@@@@@@'+c.RecordTypeId);
          system.debug( '@@@@@@@@@@@@@@'+c.FA_Received_Date__c);
          
          CaseIds.add(c.id);
          NewCases.add(c);
         }//END IF
        }//END FOR
        if(!NewCases.isEmpty())
        {
            DueDateLogic = DueDateLogic__c.getAll().values();
            if(!CaseIds.IsEmpty()){
                CaseWithTACDetails = new MAP<id, case>([select  parent.parentid, parent.parent.NetworkImpact__c, parent.parent.Severity__c, FARequest__c from case where id in: CaseIds]);
            }
            for(case RecentCase : NewCases)
            {
                if(CaseWithTACDetails.containsKey(RecentCase.id) && CaseWithTACDetails.get(RecentCase.id).parent.parentid != null)
                {
                    for(DueDateLogic__c DueDate : DueDateLogic)
                    {
                        if((CaseWithTACDetails.get(RecentCase.id).parent.parent.NetworkImpact__c == DueDate.TACServiceImpact__c) && (CaseWithTACDetails.get(RecentCase.id).parent.parent.Severity__c == DueDate.TACSeverity__c) && (RecentCase.FARequest__c == DueDate.FARequest__c))
                            RecentCase.FA_Due_Date__c = RecentCase.FA_Received_Date__c.addDays(Integer.valueOf(DueDate.DueDays__c));      
                    }//END FOR
                }//END IF
                else
                {
                    for(DueDateLogic__c DueDate : DueDateLogic)
                    {
                        if((DueDate.TACServiceImpact__c == 'No Impact') && (DueDate.TACSeverity__c == 'Informational') && (DueDate.FARequest__c == 'Not Requested'))
                            RecentCase.FA_Due_Date__c = RecentCase.FA_Received_Date__c.addDays(Integer.valueOf(DueDate.DueDays__c));      
                    }//END FOR
                }
            }//END FOR
        }//END IF
        system.debug('************'+NewRecords);
    }//end method
    /*************************************************************************************************************************
Purpose:- Set completion date on milestone if owner is changed.
*************************************************************************************************************************************/
    
    /*  public static void SetCompletionDateOnChangeOwner(LIST<case> NewRecords, MAP<id, case> OldRecordMAP)
{
LIST<case> UpdatedRecords = new LIST<case>();
integer v=0;
ID TACCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('TAC').getRecordTypeId();
LIST<id> CaseId = new LIST<id>();
LIST<id> UpdatedCaseIds = new LIST<id>();
LIST<user> users = new LIST<user>();
for(case SingleRecord : NewRecords) 
{
if(SingleRecord.status == 'New' && SingleRecord.Severity__c == 'Critical' && SingleRecord.RecordTypeId == TACCaseId && (SingleRecord.OwnerId != OldRecordMAP.get(SingleRecord.Id).OwnerId))
{
UpdatedRecords.add(SingleRecord);
CaseId.add(SingleRecord.id);
}//END IF            
}//END FOR
if(!CaseId.isEmpty())
{
map<id,case> CaseWithUserAsOwner = new map<id, case>([select id, Owner.Type from case where Owner.Type = 'User' and id in : caseid]);
for(Case SingleCase : UpdatedRecords)
{
if(CaseWithUserAsOwner.containskey(SingleCase.id))
{
UpdatedCaseIds.add(SingleCase.id);
}//END IF 
}//END FOR
if(!UpdatedCaseIds.isEmpty())
{
LIST<CaseMilestone> CaseMilestones = [select CaseId,CompletionDate,isCompleted,milestonetype.name from CaseMilestone where caseid in: UpdatedCaseIds and isCompleted = False and milestonetype.name = 'Critical Case Ownership' ];
for(CaseMilestone ms : CaseMilestones)
{
ms.CompletionDate = System.now();
system.debug('**** Inside under Investigation');
}//END FOR
if(!CaseMilestones.isEmpty())
update CaseMilestones;
}//END IF

}//END IF
system.debug('************'+NewRecords);
}//END METHOD
*/
    
    /*************************************************************************************************************************
Purpose:- Set completion date on milestone on "Under investigation" and "closed" status of case.
*************************************************************************************************************************************/
    
    public static void SetCompletionDateOnMilestone(LIST<Case> NewRecords,Map<id, Case>OldCaseMap )
    {
        LIST<id> CaseIds = new LIST<id>();
        LIST<Case> NewCases = new LIST<Case>();
        MAP<id, List<CaseMilestone>> CaseMilestoneWithCaseMAP = new MAP<id, List<CaseMilestone>>();
        LIST<CaseMilestone> CaseMilestones = new LIST<CaseMilestone>();
        for(Case c: NewRecords)
        {
            if((OldCaseMap.get(c.id).status=='New' &&  c.status == 'In Progress') || c.status == 'Resolved')
            {
                CaseIds.add(c.id);       
                NewCases.add(c);
            }//END IF 
        }//END FOR
        system.debug('&&&&&&&&&&&&&&&'+caseids);
        if(!NewCases.isEmpty())
        {   
            if(!CaseIds.IsEmpty()){
                CaseMilestones = [select id,CaseId,CompletionDate,isCompleted,milestonetype.name from CaseMilestone where caseid in: CaseIds  and isCompleted = False];
            }
            system.debug('--------------------'+[select id,CaseId,CompletionDate,isCompleted,milestonetype.name from CaseMilestone where caseid in: CaseIds]);
            if(!CaseMilestones.IsEmpty()){
                for(CaseMilestone CM : CaseMilestones)
                {
                    List<CaseMilestone> listMilestones = new List<CaseMilestone>();
                    if(CaseMilestoneWithCaseMAP.containsKey(cm.caseId)){
                        listMilestones = CaseMilestoneWithCaseMAP.get(cm.caseId);
                    }//END IF
                    listMilestones.add(cm);
                    CaseMilestoneWithCaseMAP.put(cm.caseid, listMilestones);    
                }//END FOR
            }
            system.debug('---------------'+CaseMilestoneWithCaseMAP);
            List<CaseMilestone> milestonesToUpdate =  new List<CaseMilestone>();
            for(Case c : NewCases)
            {
                if(CaseMilestoneWithCaseMAP.containsKey(c.id)){
                    for(CaseMilestone cm : CaseMilestoneWithCaseMAP.get(c.id)){
                        if((c.status == 'In Progress') && cm.milestonetype.name.contains('Response'))
                        {
                            cm.CompletionDate = System.now();
                            system.debug('**** Inside under Investigation');
                            
                        }//END IF
                        
                        else if(c.status == 'Resolved'  && cm.milestonetype.name.contains('Resolution'))
                        {
                            cm.CompletionDate = System.now();
                            system.debug('**** Inside Resolved');
                        }//END ELSE IF
                        milestonesToUpdate.add(cm);
                    }//END FOR               
                }//END IF
            }//END FOR
            system.debug('**milestonesToUpdate***'+milestonesToUpdate);
            if(milestonesToUpdate!= null && !milestonesToUpdate.isEmpty())
                update milestonesToUpdate;
        }//END IF          
        system.debug('************'+NewRecords);
    }//END METHOD
    
    /************************************************************************************************************************
Purpose:-Check severity and Update milestone
*************************************************************************************************************************/
    public static void SetCompletionDateOnSeverityChange(List<Case> caseList,Map<id, Case>OldCaseMap)
    {
        LIST<id> ListOfCaseIds = new LIST<id>();
        LIST<Case> caseListExtract =new LIST<Case>();
        LIST<CaseMilestone> updateCaseMilestones = new LIST<CaseMilestone>();
        for(Case c:caseList)
        {
            if(OldCaseMap.get(c.Id).Severity__c!=c.Severity__c)
            {
                ListOfCaseIds.add(c.id);
                
            }//END IF 
        }//FOR
        
        if(!ListOfCaseIds.IsEmpty())
        {
            caseListExtract = [select id,(select id,CaseId,CompletionDate,isCompleted,milestonetype.name from CaseMilestones where isCompleted = False) from Case where Id in:ListOfCaseIds];
        }//IF
        
        if(!caseListExtract.IsEmpty())
        {
            for(Case objCase : caseListExtract)
            {
                for(CaseMilestone objCasemilestone:objCase.CaseMilestones)
                {
                    objCasemilestone.CompletionDate=System.now();
                    UpdateCaseMilestones.add(objCasemilestone);
                    
                }
                
            }//END FOR
        }//if
        
        if(updateCaseMilestones!= null && !updateCaseMilestones.isEmpty())
            update updateCaseMilestones;
        
        
    }
    
    /*************************************************************************************************************************
Purpose:- Set default entitlement of selected sold to account on TAC case.
*************************************************************************************************************************************/
    
    public static void SetDefaultEntitlementOnTACCase(LIST<Case> NewRecords, MAP<id, Case> OldRecords)
    {
        ID TacID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TSR').getRecordTypeId();
        LIST<case> TacToUpdate = new LIST<case>();
        LIST<Entitlement> AccountsWithEntitlements = new LIST<Entitlement>();
        //Changes added by Dilowar for SFDCSERV-625: START
        LIST<Entitlement> AccountsWithDefaultEntitlements = new LIST<Entitlement>();
        MAP<id, Entitlement> AccountsWithDefaultEntitlementsMAP = new MAP<id, Entitlement>();
        //Changes added by Dilowar for SFDCSERV-625: END
        MAP<id, Entitlement> AccountsWithEntitlementsMAP = new MAP<id, Entitlement>();
        MAP<id, Entitlement> ProductsWithEntitlementsMAP = new MAP<id, Entitlement>();
        MAP<id, Entitlement> AssetsWithEntitlementsMAP = new MAP<id, Entitlement>();
        Set<id> SoldToAccountIds = new Set<id>();
        Set<id> assetIdSet = new Set<id>();
        Set<Id> productFamilyIdSet = new Set<Id>();//Added by Yogesh(Appirio)I-376185
        for(Case NewRecord : NewRecords)
        {
            if(NewRecord.RecordTypeId == TacID && NewRecord.accountid!=NULL && (NewRecord.ProductId__c !=NULL || NewRecord.assetid !=null)) // OR Condition added by Mukesh I-378931 
            {
                if(NewRecord.ProductId__c != null) // Added by Mukesh I-378931
                productFamilyIdSet.add(NewRecord.ProductId__c);//Added by Yogesh(Appirio)I-376185
                if(NewRecord.assetid != null) // Added by Mukesh I-378931
                assetIdSet.add(NewRecord.assetid); //Added by Mukesh I-378931
                TacToUpdate.add(NewRecord);
                SoldToAccountIds.add(NewRecord.accountid);
            }//END IF
            if(NewRecord.accountid == null)
            {
                NewRecord.EntitlementId = null;
            }//END IF
            
        }//END FOR
        if(!TacToUpdate.isEmpty())
        {   
            if(!SoldToAccountIds.IsEmpty()){
                //Changes added by Dilowar for SFDCSERV-625: START
                AccountsWithDefaultEntitlements = [SELECT id,accountid,DefaultEntitlement__c FROM Entitlement where accountid in: SoldToAccountIds and DefaultEntitlement__c = true and SAPEntitlementId__c = null];
                //Changes added by Dilowar for SFDCSERV-625: END
                AccountsWithEntitlements = [SELECT id,accountid,Product__c,AssetId  FROM Entitlement WHERE AccountId IN: SoldToAccountIds  AND Status = 'Active' AND Type = 'Technical Support' AND (Product__c IN: productFamilyIdSet OR assetid IN : assetIdSet)];//Added by Yogesh(Appirio)I-376185
            }
            //Changes added by Dilowar for SFDCSERV-625: START
            if(!AccountsWithDefaultEntitlements.IsEmpty()){
                for(Entitlement e : AccountsWithDefaultEntitlements)
                {
                    AccountsWithDefaultEntitlementsMAP.put(e.accountid, e);
                }
            }
            //Changes added by Dilowar for SFDCSERV-625: END
            if(!AccountsWithEntitlements.IsEmpty()){
                for(Entitlement e : AccountsWithEntitlements)
                {
                    if(e.Product__c != null) // added by Mukesh I-378931
                    ProductsWithEntitlementsMAP.put(e.Product__c,e);//Added by Yogesh(Appirio)I-376185
                    
                    if(e.assetid != null) // added by Mukesh I-378931
                    AssetsWithEntitlementsMAP.put(e.assetid,e); // added by Mukesh I-378931
                    
                    AccountsWithEntitlementsMAP.put(e.accountid, e);
                }
            }
            system.debug('*****AccountsWithDefaultEntitlementsMAP'+AccountsWithDefaultEntitlementsMAP);
            system.debug('*****ProductsWithEntitlementsMAP'+ProductsWithEntitlementsMAP);
            system.debug('*****AccountsWithEntitlementsMAP'+AccountsWithEntitlementsMAP);
            system.debug('*****AssetsWithEntitlementsMAP'+AssetsWithEntitlementsMAP);
            for(Case c : TacToUpdate)
            {
                
                c.EntitlementId = null;
                if(AccountsWithEntitlementsMAP.containsKey(c.accountid) && ( ProductsWithEntitlementsMAP.containsKey(c.ProductId__c) || AssetsWithEntitlementsMAP.containsKey(c.assetid) )){//Added by Yogesh(Appirio)I-376185) OR Condition added by Mukesh I-378931
                    system.debug('*****inside Entitlement');
                    c.EntitlementID = AccountsWithEntitlementsMAP.get(c.accountid).id;
                    c.Has_Valid_Entitlement__c = true;
                //Changes added by Dilowar for SFDCSERV-625: START
                } else if(AccountsWithDefaultEntitlementsMAP.containsKey(c.accountid)){
                    c.EntitlementID = AccountsWithDefaultEntitlementsMAP.get(c.accountid).id;
                }
                //Changes added by Dilowar for SFDCSERV-625: END
            }//END FOR 
        }//END IF
        system.debug('************'+NewRecords);
    }//END METHOD
    /*************************************************************************************************************************
Purpose:- Populate RMA vendor as per the MAPpings in VendorMAP custom setting
*************************************************************************************************************************************/
    /*    
public static void PopulateRMAVendorOnRma(LIST<case> NewRecords)
{

MAP<string,RMAVendorMAPping__c> VendorMAP = RMAVendorMAPping__c.getAll(); 
Id RMARecordTypeID = Schema.SObjectType.Case.RecordTypeInfosByName.get('RMA').RecordTypeId;
for(Case SingleCase: NewRecords)
{
if(SingleCase.ShipToCountry__c!=null && SingleCase.RecordTypeId == RMARecordTypeID)
{
for(string country: VendorMAP.keySet())
{
if(SingleCase.ShipToCountry__c.equalsIgnoreCase(country))
{
singlecase.RMAVendor__c = VendorMAP.get(country).partner__c;
}//END IF
}//END FOR
}//END IF
}//END FOR
system.debug('************'+NewRecords);
}//END METHOD */
    
    /*************************************************************************************************************************
Purpose:- Populate RMA vendor as per the MAPpings in Return Address object
*************************************************************************************************************************************/    
    /* public static void PopulateRMAVendorOnRma(LIST<case> newCases){
Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByName().get('RMA').getRecordTypeId();
LIST<Case> autoPopulateDepotPartner = new LIST<Case>();
Set<String> RMAShipToCountries = new Set<String>();
LIST<ReturnAddresses__c> rmaReturnAddress = new LIST<ReturnAddresses__c>();
Set<Id> productIds = new Set<Id>();
List<Product2> metroSwedenProductsList = new List<Product2>();
//Set<MSMaterialGroups__c> msMaterialgroup = MSMaterialGroups__c.getall().values();
//Map<String,MSMaterialGroups__c> msMaterialgroup = MSMaterialGroups__c.getAll();
String msMaterialgroup = System.Label.MSMaterialGroups;
Set<Id> metroSwedenProducts = new Set<Id>();
for(Case c: newCases){
System.debug('$$$$New Cases$$$$'+newCases);
System.debug('$$$$RMA Shipt To$$$$'+c.RMA_Ship_To__c);
System.debug('$$$$RMA Shipt To Country$$$$'+c.ShipToCountry__c);
if(c.RMA_Ship_To__c != Null && c.ShipToCountry__c!= null && c.ProductId != Null && c.RecordTypeId == recordTypeIdRMA){
autoPopulateDepotPartner.add(c);
RMAShipToCountries.add(c.ShipToCountry__c);
productIds.add(c.ProductId);
}//END IF  
}//END FOR

if(!RMAShipToCountries.isEmpty()){
System.debug('$$$$RMA Countries*$$$$'+RMAShipToCountries);
rmaReturnAddress = [SELECT Id,Name,LookUpCountries__c,RMAVendor__c,MSDepotPartner__c FROM ReturnAddresses__c where LookUpCountries__c IN :RMAShipToCountries];
}//END IF

if(!productIds.isEmpty()){
System.debug('$$$$ProductIds$$$$'+productIds);
metroSwedenProductsList = [Select Id,Name,MaterialGroup__c from Product2 where Id IN:productIds];
System.debug('$$$$List MS Products$$$$'+metroSwedenProductsList);
}//END IF

if(!metroSwedenProductsList.isEmpty()){
for(Product2 p: metroSwedenProductsList){
if(p.MaterialGroup__c != null && msMaterialgroup != null && msMaterialgroup == p.MaterialGroup__c){
System.debug('$$$$$$ContainsKeyHW-SWE$$$$$$');
metroSwedenProducts.add(p.id);
}

}
System.debug('$$$$Set MS Products$$$$'+metroSwedenProducts);
}//END IF

if(!autoPopulateDepotPartner.isEmpty() && !rmaReturnAddress.isEmpty()){
for(Case c :autoPopulateDepotPartner){
if(c.RMA_Ship_To__c != Null && c.ShipToCountry__c!= null && c.ProductId != Null && c.RecordTypeId == recordTypeIdRMA){
for(ReturnAddresses__c r:rmaReturnAddress){
if(c.ShipToCountry__c == r.LookUpCountries__c){
if(!metroSwedenProducts.isEmpty() && metroSwedenProducts.contains(c.ProductId)){
c.RMAVendor__c = r.MSDepotPartner__c;
}else{
c.RMAVendor__c = r.RMAVendor__c;
}//END IF ELSE                  
}//END IF
}//END FOR ReturnAddresses__c
}//END IF
}//END FOR Case

}//END IF
}//END METHOD    */
    /*************************************************************************************************************************************/    
    public static void CheckUpliftCheckbox(LIST<case> NewRecords,  MAP<id, case> OldRecords)
    {
        LIST<id> EntitlementIds = new LIST<id>();
        LIST<case> TriggerNewRecs = new LIST<case>();
        Map<id, Entitlement> Entitlements;
        MAP<string,EntitlementNewandOldCodes__c> MapofEntitlementCode    =    EntitlementNewandOldCodes__c.getAll();
        MAP<String,string> NewMapofEntitlementCode    =    new MAP<string,string>();
        for(EntitlementNewandOldCodes__c ent:MapofEntitlementCode.values()){
            NewMapofEntitlementCode.put(ent.NewEntitlementCode__c,ent.OldEntitlementCodes__c);
        }
        
        Id RMAId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        for(Case SingleRec: NewRecords)
        {
            if(OldRecords!=null)
            {
                if(SingleRec.RecordTypeId == RMAId && SingleRec.Entitlementid!= null && (SingleRec.Reason != OldRecords.get(SingleRec.id).Reason || SingleRec.EntitlementId != OldRecords.get(SingleRec.id).EntitlementId))
                {
                    TriggerNewRecs.add(SingleRec);  
                    EntitlementIds.add(SingleRec.EntitlementId);                 
                }//END IF
            }
            else
            {
                if(SingleRec.RecordTypeId == RMAId && SingleRec.Entitlementid!= null)
                {
                    TriggerNewRecs.add(SingleRec);  
                    EntitlementIds.add(SingleRec.EntitlementId);             
                }//END IF
            }
        }//END FOR  
        if(!TriggerNewRecs.isEmpty())
        {
            Map<String, RMACaseReasonPriority__c> RMACaseReasonPriorityMap = RMACaseReasonPriority__c.getAll(); 
            Entitlements = new map<id,Entitlement>([select name, id, servicepriority__c from Entitlement where id in: EntitlementIds]);
            for(Case c: TriggerNewRecs)
            {
                if(Entitlements.containsKey(c.EntitlementId))
                {
                    if(c.reason == Entitlements.get(c.EntitlementId).name){
                        c.AllowForUpliftApproval__c = false;
                    }
                    if(c.reason==NewMapofEntitlementCode.get(c.Entitlement.name)) {
                        c.AllowForUpliftApproval__c = false;
                    }   
                    else
                    {
                        if(RMACaseReasonPriorityMap.containsKey(c.reason))
                        {
                            if(RMACaseReasonPriorityMap.get(c.reason).Priority__c < Entitlements.get(c.EntitlementId).servicepriority__c)
                                c.AllowForUpliftApproval__c = true;
                            else
                                c.AllowForUpliftApproval__c = false;
                        }
                    }
                }   
            }  
        }
        system.debug('************'+NewRecords);
    }
    
    /*************************************************************************************************************************
Purpose:- To create a Tasks depending on the records in Activity template object.
*************************************************************************************************************************************/
    
    public static void createaTask(LIST<case> NewRecords, MAP<id,case> OldRecords)
    {   
        id faId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('FA').getRecordTypeId();
        id faInternal =Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        id faComponent= Schema.SObjectType.Case.getRecordTypeInfosByName().get('FA Component').getRecordTypeId();
        LIST<Task> updatedTask=new LIST<Task>();
        LIST<case> UpdatedCases = new LIST<case>();
        LIST<Task> UpdatedInternalTask = new LIST<Task>();
        
        
        LIST<case> UpdatedFACases = new LIST<case>();
        LIST<case> UpdatedFAInternalCases = new LIST<case>();
        LIST<case> UpdatedFAComponentCases = new LIST<case>();
        
        
        set<string> FAPickLISTVals = new set<string>();
        //LIST<ActivityTemplates__c> activityValue = [SELECT name, ActivityType__c,ActivityDescription__c,Sequence__c from ActivityTemplates__c  where name in:FAPickLISTVals ];
        MAP<string, LIST<ActivityTemplates__c>> activityValueMAP = new MAP<string, LIST<ActivityTemplates__c>>();
        MAP<string, LIST<ActivityTemplates__c>> FAInternalValueMap = new MAP<string, LISt <ActivityTemplates__c>>();
        for(Case NewCase: NewRecords)
        {
            if(NewCase.FA_Activity__c != OldRecords.get(NewCase.id).FA_Activity__c)
            { 
                if(NewCase.RecordTypeId == faId)
                    UpdatedFACases.add(NewCase);
                else if(NewCase.RecordTypeId == faInternal || NewCase.RecordTypeId == faComponent)
                    UpdatedFAInternalCases.add(NewCase);
                //else if(NewCase.RecordTypeId == faComponent)
                //    UpdatedFAComponentCases.add(NewCase);
                FAPickLISTVals.add(NewCase.FA_Activity__c);
                UpdatedCases.add(NewCase);
            }
            
        }//END FOR
        system.debug('%%%%%%% List : '+ UpdatedCases);
        system.debug('************ String : '+FAPickLISTVals);
        if(!UpdatedFACases.isEmpty())
        {
            for(ActivityTemplates__c AT:[SELECT name, ActivityType__c,ActivityDescription__c,Sequence__c,Record_Type__c from ActivityTemplates__c  where name in:FAPickLISTVals AND Record_Type__c = 'FA' ] )
            {
                if(activityValueMAP.containsKey(at.name)){
                    activityValueMAP.get(at.name).add(new ActivityTemplates__c(Name=at.name, ActivityType__c = at.ActivityType__c, ActivityDescription__c = at.ActivityDescription__c, Sequence__c = at.Sequence__c ));
                }//END IF
                else{
                    LIST<ActivityTemplates__c> TempATList= new LIST<ActivityTemplates__c>();
                    TempATList.add(new ActivityTemplates__c(Name=at.name, ActivityType__c = at.ActivityType__c,ActivityDescription__c = at.ActivityDescription__c, Sequence__c = at.Sequence__c ));
                    activityValueMAP.put(at.name, TempATList);
                }//END Else
            }//END FOR
        }
        else if(!UpdatedFAInternalCases.isEmpty())
        {
            for(ActivityTemplates__c AT:[SELECT name, ActivityType__c,ActivityDescription__c,Sequence__c,Record_Type__c from ActivityTemplates__c  where name in:FAPickLISTVals AND Record_Type__c = 'Internal Task Templates' ] )
            {
                if(activityValueMAP.containsKey(at.name)){
                    activityValueMAP.get(at.name).add(new ActivityTemplates__c(Name=at.name, ActivityType__c = at.ActivityType__c, ActivityDescription__c = at.ActivityDescription__c, Sequence__c = at.Sequence__c ));
                }//END IF
                else{
                    LIST<ActivityTemplates__c> TempATList= new LIST<ActivityTemplates__c>();
                    TempATList.add(new ActivityTemplates__c(Name=at.name, ActivityType__c = at.ActivityType__c,ActivityDescription__c = at.ActivityDescription__c, Sequence__c = at.Sequence__c ));
                    activityValueMAP.put(at.name, TempATList);
                }//END Else
            }//END FOR    
        }
        for(Case c: UpdatedCases)
        {       
            if(activityValueMAP.containskey(c.FA_Activity__c))
            {     
                for(ActivityTemplates__c AT: activityValueMAP.get(c.FA_Activity__c))
                {
                    //Task objtsk=new Task(subject = c.FA_Activity__c, ActivityDescription__c=at.ActivityDescription__c,ActivityType__c=at.ActivityType__c,OperationSeq__c=at.Sequence__c,whatid = c.id ,OwnerId =Label.FA_Activity_Owner);
                    Task objtsk=new Task(subject = at.ActivityDescription__c ,Activity_Description__c=at.name,ActivityType__c=at.ActivityType__c,OperationSeq__c=at.Sequence__c,whatid = c.id ,OwnerId =Label.FA_Activity_Owner);//c.FA_Activity__c ActivityDescription__c // Updaetd by Mukesh for S-604720
                    updatedTask.add(objtsk);
                }
            }//END IF
        }//END FOR
        if(!updatedTask.isEmpty())
            insert updatedTask;
        
        system.debug('************'+NewRecords);
    }//END METHOD
    
    /*************************************************************************************************************************
Purpose:- To assign service contact to case when case is created from community.
*************************************************************************************************************************************/
    public static void assignServiceContactToCase(LIST<case> NewRecords){
        LIST<ServiceContact__c> serviceContact = new LIST<ServiceContact__c>();
        
        //Variables to get accountid ,SerivecAccount id and ServiceContact id for case
        set<id> contactId = new set<id>();
        MAP<id,id> MAPContactServiceAccount = new MAP<id,id>();
        MAP<id,id> MAPContactAccount = new MAP<id,id>();
        MAP<id,id> MAPContactServiceContact = new MAP<id,id>();
        
        LIST<Contact> conLIST = new LIST<Contact>();
        
        //Get all contacts related to case
        for(case caseRecord : NewRecords){
            contactId.add(caseRecord.Contactid);
        }//END FOR
        
        if(!contactId.IsEmpty()){
            conLIST =[select id ,AccountId,ServiceAccount__c from Contact where id in : contactId];
        }
        
        if(!conLIST.IsEmpty()){
            for(contact CON :conLIST){
                if(CON.AccountId!=null){
                    MAPContactAccount.put(CON.id,CON.AccountId);
                }//End if
                if(CON.ServiceAccount__c!=null){
                    MAPContactServiceAccount.put(CON.id,CON.ServiceAccount__c);
                }//End if
            }//End For
        }//End If
        
        if(!MAPContactServiceAccount.IsEmpty() && !contactId.IsEmpty()){
            serviceContact = [select id, Account__c,Contact__c from ServiceContact__c where Contact__c in : MAPContactServiceAccount.KeySet() and  Account__c in: MAPContactServiceAccount.values() and active__C = true];
        }//END IF
        if(!serviceContact.isEmpty()){
            for(ServiceContact__c SC : serviceContact){
                MAPContactServiceContact.put(SC.Contact__c , SC.id);
            }//END FOR
        }//END IF
        for(case caseRecord : NewRecords){
            caseRecord.Service_Contact__c = MAPContactServiceContact.get(caseRecord.Contactid);
            caseRecord.AccountId = MAPContactAccount.get(caseRecord.Contactid);
            caseRecord.ServiceAccount__c = MAPContactServiceAccount.get(caseRecord.Contactid);
            caseRecord.AccountForCommunityAccess__c = MAPContactServiceAccount.get(caseRecord.Contactid);
        }//END FOR
        system.debug('************'+NewRecords);
    }//END METHOD
    /*************************************************************************************************************************
Purpose:- Prevent changing owner from queue to user if user is not in queue
*************************************************************************************************************************************/
    
    public static void PreventChangeOwnerForQueue(list<case> NewRecords, map<id, case> OldRecordMap)
    {
        //Added validation to bypass validation when owner is getting updated via Twilio functionality
        if(!TwilioHelper.isRunningTwilioProcess){
            list<GroupMember> GroupMemList = new list<GroupMember>();
            map<id, case> UserCaseMap = new Map<id, case>();
            map<id, id> QueueUserIds = new map<id, id>();
            map<id, list<GroupMember>> GroupMems = new map<id, list<GroupMember>>();
            for(Case c : NewRecords)
            {
                if(OldRecordMap.get(c.id).OwnerId != c.ownerid && string.valueOf(OldRecordMap.get(c.id).OwnerId).startsWith('00G') && string.valueOf(c.OwnerId).startsWith('005') && c.status != 'Closed')
                {
                    QueueUserIds.put(c.OwnerId, OldRecordMap.get(c.id).OwnerId);
                    UserCaseMap.put(c.OwnerId, c);
                }//END IF
                
            }//END FOR
            if(!QueueUserIds.values().isEmpty())
            {
                GroupMemList = [Select id, UserOrGroupId, GroupId From GroupMember where GroupId in : QueueUserIds.values() and UserOrGroupId in: QueueUserIds.keyset()];
                
                for(GroupMember SingleGroupMem : GroupMemList)
                {
                    if(!GroupMems.containsKey(SingleGroupMem.GroupId))
                    {
                        list<GroupMember> GroupMemsList = new list<GroupMember>();
                        GroupMemsList.add(SingleGroupMem);
                        GroupMems.put(SingleGroupMem.GroupId,GroupMemsList );
                    }//END IF
                    else
                    {
                        GroupMems.get(SingleGroupMem.GroupId).add(SingleGroupMem);
                    }//END ELSE
                }//END FOR
                for(id UserId : QueueUserIds.keyset())
                {
                    if(!GroupMems.containsKey(QueueUserIds.get(UserId)))
                    {
                        if(!CaseEmergencyContactCtrl.isRunningCseEmergConProcess)
                            UserCaseMap.get(UserId).addError('User is not in assigned Queue');
                    }//END IF
                }//END FOR
            }//END IF
            system.debug('************'+NewRecords);
        }
    }//END METHOD  
    
    public static void AutoPopulateAlternateEmail(list<case> NewRecords){
        //Set of contact id from which we need alternate email
        set<id> setContactId = new set<id>();
        Map<id,contact> mapContactWithAlternateEmail;
        
        if(!NewRecords.isEmpty()){
            for(Case caseRec : NewRecords){
                if((caseRec.alternateEmail__c == '' || caseRec.alternateEmail__c == null) 
                   && caseRec.ContactId != null){
                       setContactId.add(caseRec.ContactId);
                   }//End of if
            }//End of for
        }//End of if
        system.debug(setContactId);
        //Get list of contacts with alternate email not blank
        if(!setContactId.isEmpty()){
            mapContactWithAlternateEmail = new Map<id,contact>([select id ,AlternateEmail__c from contact where id in : setContactId]); 
        }//End of if
        system.debug(mapContactWithAlternateEmail);
        //put value of alternate email on contact to alternate email on case
        if(mapContactWithAlternateEmail!= null && !mapContactWithAlternateEmail.isEmpty()){
            for(Case caseRec : NewRecords){
                if(caseRec.ContactId != null && mapContactWithAlternateEmail.containsKey(caseRec.ContactId)
                   && mapContactWithAlternateEmail.get(caseRec.ContactId).AlternateEmail__c!= Null 
                   && mapContactWithAlternateEmail.get(caseRec.ContactId).AlternateEmail__c != ''){
                       caseRec.AlternateEmail__c = mapContactWithAlternateEmail.get(caseRec.ContactId).AlternateEmail__c;
                   }//End of if
            }//End of for
        }//End of if
        
    }//end of method
    
    public static void PopulatePonNumber(list<Case> NewCases)
    {
        id RMAID=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        List<Case> UpdatedAssetsCases = new List<case>();
        List<Case> UpdateProductsCases = new List<case>();
        List<id> AssetIds = new List<id>();
        Set<Id> ProductIds = new Set<id>();
        for(Case C: NewCases)
        {
            if(C.RecordTypeID == RMAID && c.AssetId!=null)
            {
                UpdatedAssetsCases.add(c);
                AssetIds.add(c.AssetId);
            }else if(C.RecordTypeID == RMAID && c.AssetId == null && c.ProductId != null){
                UpdateProductsCases.add(c);
                ProductIds.add(c.ProductId);
            }
        }
        if(!AssetIds.isEmpty())
        {
            MAP<id, asset> Assets = new MAP<id, asset>([select id , product2.ProductCode from asset where id in: AssetIds]);
            system.debug('****From Assets****'+Assets);
            for(Case C:UpdatedAssetsCases)
            {
                c.ReceivingPartNumber__c = (String) Assets.get(c.AssetId).product2.ProductCode;
            }
        }
        
        if(!ProductIds.isEmpty() && !UpdateProductsCases.isEmpty()){
            MAP<id, Product2> Products = new MAP<id, Product2>([select id , ProductCode from Product2 where id in: ProductIds]);
            system.debug('****From Products****'+Products);
            for(Case C:UpdateProductsCases)
            {
                c.ReceivingPartNumber__c = (String) Products.get(c.ProductId).ProductCode;
            }
        }
    }
    
    public static void DoNotCloseCase(list<case> listNewCase, Map<id,Case> mapOldCase){
        Set<id> setClosingCaseId = new set<id>();
        list<Task> listOpenTask  = new list<Task>();
        set<id> setDoNotCloseCaseId  = new set<id>();    
        
        for(Case c : listNewCase){
            if(c.Status == 'Closed' && c.Status != mapOldCase.get(c.id).status){
                setClosingCaseId.add(c.id);
            }//End of if
        }//End of for
        if(!setClosingCaseId.isEmpty()){
            listOpenTask = [select id,What.recordtype.name from task where Status != 'Completed' and Status != 'Cancelled' and WhatId in : setClosingCaseId];
        }//End of if
        if(!listOpenTask.isEmpty()){
            for(Task T : listOpenTask){
                if(T.What.recordtype.Name == 'Technical Escalation Request'){
                    setDoNotCloseCaseId.add(T.WhatId);
                }
            }
        }//End of if
        if(!setDoNotCloseCaseId.isEmpty()){
            for(Case c : listNewCase){
                if(setDoNotCloseCaseId.contains(c.id)){
                    c.IsClosed.addError(label.CloseCaseValidation);
                }//End of if
            }//End of for
        }//End of if
        
    }
    
      /*************************************************************************************************************************
AssociateTACCaseWithTACCase:- Method to prevent attaching parent case other than TAC case to TAC case
*************************************************************************************************************************************/
    public static void AssociateTACCaseWithTACCase(list<case> listNewCase, Map<id,Case> mapOldCase){
        list<case> listNewCaseData      = new List<case>();
        set<id> setParentCaseId         = new set<id>();
        set<id> setErrorCaseParentId    = new set<id>();
        Id TacCaseRecordType  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TSR').getRecordTypeId();
        //Code change Service desk ticket: #11610: Added by Dilowar on 29/05/2019: START
        Id mwcCaseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('MWC').getRecordTypeId();
        //Code change Service desk ticket: #11610: Added by Dilowar on 29/05/2019: END
        if(!listNewCase.isEmpty()){
            for(case c : listNewCase){
                //For all TAC case get parent case Id
                if(C.recordTypeId == TacCaseRecordType && c.ParentId!= null){
                    //for before update get only those cases for which parent case is changed
                    if(mapOldCase!= null && mapOldCase.containskey(c.id) && c.ParentId != mapOldCase.get(c.id).ParentId ){
                        setParentCaseId.add(c.parentid);
                    }//End of if
                    //For new before insert get all parent case id
                    if(mapOldCase == null){
                        setParentCaseId.add(c.parentId);                    
                    }//End of if 
                }//End of if
            }//End of for
        }//End of if
        
        //get all parent case which are not TAC cases
        if(!setParentCaseId.isEmpty()){
            listNewCaseData = [select id,recordtypeId from case where id in : setParentCaseId];
        }//End of 
        
        //Create set of of prent case id which are not tac cases
        if(!listNewCaseData.isEmpty()){
            for(Case C : listNewCaseData){
                //Code change Service desk ticket: #11610: Added by Dilowar on 29/05/2019: START
                if(c.recordtypeId != TacCaseRecordType && c.recordtypeId !=  mwcCaseRecordType){
                    setErrorCaseParentId.add(c.id);
                }
                //Code change Service desk ticket: #11610: Added by Dilowar on 29/05/2019: END
            }//End of for
        }//End of if
        
        //for new tac case if parent case is not of Recortd type TAC then add error
        if(!setErrorCaseParentId.isEmpty()){
            for(Case c : listNewCase){
                if(C.recordTypeId == TacCaseRecordType && setErrorCaseParentId.contains(c.parentId)){
                    c.ParentId.addError(label.AssociateTACCaseWithParentTACCase);
                }//End of if
            }//End of for
        }//End of if
    }//End of Method
    
    public static void AssignSerializedProductToRMACase(list<case> listNewCase){
        Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        set<id> setAssetId = new set<id>();
        list<asset> listRmaAsset = new list<asset>();
        
        if(!listNewCase.IsEmpty()){
            for(Case c : listNewCase){
                if(c.recordtypeid == recordTypeIdRMA){
                    if(c.AssetId != Null){
                        setAssetId.add(c.AssetId);
                    }//End of if 
                }//End of if
            }//End of for
        }//End of if
        if(!setAssetId.IsEmpty()){
            listRmaAsset = [select id,product2.Serialized__c from asset where id in : setAssetId ];
        }//End of if
        if(!listRmaAsset.IsEmpty()){
            for(Asset a : listRmaAsset){
                if(a.product2.Serialized__c){
                    setAssetId.Remove(a.id);
                }//End of if
            }//End of for
        }//End of if
        if(!setAssetId.IsEmpty()){
            for(Case c : listNewCase){
                if(setAssetId.contains(c.AssetId)){
                    c.AssetId.addError(Label.RmaAssetWithUnserializedProduct);
                }//End of if
            }//End of for
        }//End of if
    }//End of Method
    
    public static void preventTier4CaseClosureForMissingArticles(list<case> listNewCase, Map<id,Case> mapOldCase){
        system.debug('Inside method');
        Id recordTypeIdTier4 = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TER').getRecordTypeId();
        list<Case> casesToValidate = new list<Case>();
        Set<String> tempSrting = new Set<String>();
        map<Id,Set<String>> mapTier4Cases = new map<Id,Set<String>>();
        Map<Id,Id> articleNoToCaseIdMap = new Map<Id,Id>(); // Added by Mukesh
        Map<Id,Set<String>> caseIdToSetOfAddedKnowledgeMap = new Map<Id,Set<String>>();  // Added by Mukesh
        system.debug('listNewCase'+listNewCase);
        
        //List<KnowledgeArticleVersion> getCaseArticles = new List<KnowledgeArticleVersion>();
        map<Id,Set<String>> mapCaseIdArticleTypes = new map<Id,Set<String>>();
        system.debug('listNewCase'+listNewCase);
        
        map<string,Tier4ArticlesValidation__c> tier4ArticleNames = Tier4ArticlesValidation__c.getAll();
        system.debug('>>>>tier4ArticleNames ::'+tier4ArticleNames);
        for(Case newCase: listNewCase){
            if(newCase.RecordTypeId == recordTypeIdTier4 && 
               newCase.DocumentationRequired__c && 
               newCase.DocumentationType__c != null && 
               newCase.Status == 'Closed' && 
               mapOldCase.get(newCase.Id).Status != newCase.Status){
                   system.debug('****Step1***** '+newCase);
                   casesToValidate.add(newCase);  
                   tempSrting.addAll(newCase.DocumentationType__c.split(';'));
                   mapTier4Cases.put(newCase.Id,tempSrting);
               }//End of If
        }//End of FOR
        //------------- Changes done by Mukesh ------------
        if(!mapTier4Cases.isEmpty()){
            system.debug('****Step2***** '+mapTier4Cases);
            //List<KnowledgeArticleVersion> getCaseArticles = [Select Id,ArticleNumber, PublishStatus, SourceId from KnowledgeArticleVersion where SourceId  IN :mapTier4Cases.KeySet() and PublishStatus = 'Online' and Language = 'en_US'];
            List<CaseArticle> CaseArticleList = [SELECT CaseId,Id,KnowledgeArticle.ArticleNumber,KnowledgeArticleId,KnowledgeArticleVersion.PublishStatus,KnowledgeArticleVersion.Language FROM CaseArticle WHERE CaseId IN : mapTier4Cases.KeySet() AND  KnowledgeArticleVersion.PublishStatus = 'Online' AND KnowledgeArticleVersion.Language = 'en_US'];
            
            system.debug('****CaseArticleList****'+CaseArticleList);
            for(CaseArticle ca: CaseArticleList){
                articleNoToCaseIdMap.put(ca.KnowledgeArticleId,ca.CaseId); //KnowledgeArticleId
            }
            //List<Knowledge__kav> KnowledgeList = [SELECT id,ArticleNumber, recordtype.developerName From Knowledge__kav WHERE ArticleNumber IN :articleNoToCaseIdMap.KeySet()];
            
            if(!CaseArticleList.isEmpty()){
                
                system.debug('****Step3 added ***** '+CaseArticleList);
                //system.debug('****articleNoToCaseIdMap.KeySet() ***** '+articleNoToCaseIdMap.KeySet());
                
                for(Knowledge__kav kk: [SELECT id,ArticleNumber,KnowledgeArticleId, recordtype.developerName From Knowledge__kav WHERE KnowledgeArticleId IN :articleNoToCaseIdMap.KeySet() AND PublishStatus = 'Online'AND Language = 'en_US']){
                    if(articleNoToCaseIdMap.keyset().contains(kk.KnowledgeArticleId)){
                        if(caseIdToSetOfAddedKnowledgeMap.keyset().contains(articleNoToCaseIdMap.get(kk.KnowledgeArticleId))){
                            Set<String> tempString = caseIdToSetOfAddedKnowledgeMap.get(kk.ArticleNumber);
                            tempString.add(tier4ArticleNames.get(kk.recordtype.developerName).ArticleLabels__c);
                            caseIdToSetOfAddedKnowledgeMap.put(articleNoToCaseIdMap.get(kk.KnowledgeArticleId),tempString);
                        }
                        else{
                            caseIdToSetOfAddedKnowledgeMap.put(articleNoToCaseIdMap.get(kk.KnowledgeArticleId),new Set<String> {tier4ArticleNames.get(kk.recordtype.developerName).ArticleLabels__c});
                            //System.debug('****** caseIdToSetOfAddedKnowledgeMap***'+caseIdToSetOfAddedKnowledgeMap);
                            
                        }
                        
                    }
                    
                } // Added by Mukesh -->
                //system.debug('****Step3 ***** '+getCaseArticles);
                /* for(KnowledgeArticleVersion kv: getCaseArticles){
if(mapCaseIdArticleTypes.containsKey(kv.SourceId)){
Set<String> tempString = mapCaseIdArticleTypes.get(kv.SourceId);
//tempString.add(tier4ArticleNames.get(kv.ArticleType).ArticleLabels__c);
//mapCaseIdArticleTypes.put(kv.SourceId,tempString);
}else{
//mapCaseIdArticleTypes.put(kv.SourceId,new Set<String> {tier4ArticleNames.get(kv.ArticleType).ArticleLabels__c});
}    
}  */
                system.debug('****Step4 ***** '+caseIdToSetOfAddedKnowledgeMap);
                if(!caseIdToSetOfAddedKnowledgeMap.isEmpty()){
                    for(Case thisCase: casesToValidate){
                        if(mapTier4Cases.containsKey(thisCase.Id) && caseIdToSetOfAddedKnowledgeMap.containsKey(thisCase.Id)){
                            if(!caseIdToSetOfAddedKnowledgeMap.get(thisCase.Id).containsAll(mapTier4Cases.get(thisCase.Id))){
                                //system.debug('****mapTier4Cases*** '+mapTier4Cases);
                                //system.debug('****caseIdToSetOfAddedKnowledgeMap*** '+caseIdToSetOfAddedKnowledgeMap); 
                                thisCase.addError('Please Create & Publish the required Articles!!!');
                            }
                        }
                    }
                } 
                
            }else{
                
                for(Case c :casesToValidate){
                    
                    c.addError('Please Create & Publish the required Articles!!!');
                    
                }
            }
        }
        
        //------------- Changes done by Mukesh end ------------      
    }//End of Method
    
    
    //Update Parent RMA case Fields-Quality Exclusion, Quality Exclusion Reason
    public static void UpdateParentRMACaseFields(MAp<ID,Case> mapofNewCase, Map<id,Case> mapOldCase){
        try{
            //Sets used to store FA Case IDs
            Set<ID> FACaseID                    =new Set<ID>();
            //List used to update Parent RMA Case
            List<Case> ParentCaseList           =new List<Case>();
            //Map Variables to store Case
            Map<id,Case> MapRMACaseForUpdate    =new Map<id,Case>();
            Map<ID,Case> mapOfCase              =new map<ID,Case>();
            Map<ID,ID> mapOfID                  =new map<ID,ID>();
            Map<id,Case> MapFACase;
            //Variables to storeRecordtype IDs for FA and RMA Case
            ID FACaseRecordTypeId               =Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('FA').getRecordTypeID();
            ID RMACaseRecordTypeId              =Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeID();
            //Getting values from Custom Label and adding it to Set
            Set<string> Setlabel                =new set<string>();
            String RootCauseCategory            =Label.Root_Cause_Category;
            Setlabel.addAll(RootCauseCategory.split(','));
            //Create a Set of Case if Record Type is FA AND
            //Recommended Adjustment is Checked and Root Cause Category or Root Cause Sub Category is not blank  OR
            //Recommended Adjustment is Checked and Root Cause Category or Root Cause Sub Category is not blank  and Root Cause Category or Root Cause Sub Category is updated
            if(!mapofNewCase.isEmpty()){
                for(Case c:mapofNewCase.values()){
                    if(c.RecordTypeid==FACaseRecordTypeId 
                       
                       &&(
                           (
                               mapOldCase!=null && 
                               (c.Root_Cause_Category__c!=mapOldCase.get(c.id).Root_Cause_Category__c || 
                                c.Root_Cause_Sub_Category__c!=mapOldCase.get(c.id).Root_Cause_Sub_Category__c ||
                                c.Recommended_Adjustment__c != mapOldCase.get(c.id).Recommended_Adjustment__c) 
                           )
                           || mapOldCase==null
                       )
                      ){
                          System.debug('****Step1 Nikhil****');
                          FACaseID.add(c.id);
                          mapOfID.put(c.id,c.parentid);
                      }//End of if
                }//End of For
            }//End of if
            //Create  a Map of FA Cases with required values
            if(!FACaseID.IsEmpty()){
                MapFACase = new Map<id,Case>([SELECT ID,parent.recordtype.name,Root_Cause_Category__c,Root_Cause_Sub_Category__c,Recommended_Adjustment__c,RecordType.name,Quality_Exclusion_Reason__c,Quality_Exclusion__c,Parentid,parent.Quality_Exclusion__c,parent.Quality_Exclusion_Reason__c From Case WHERE (id in:FACaseID )
                                              AND Parent.RecordTypeid=:RMACaseRecordTypeId   ]);
                System.debug('****Step3 Nikhil****'+MapFACase); 
            }
            
            if(MapFACase!= null && !MapFACase.IsEmpty()){
                for(Case c: MapFACase.values()){
                    if(mapofNewCase.containskey(c.id) && FACaseID.contains(c.id)){
                        System.debug('****Step4 Nikhil****'+MapRMACaseForUpdate); 
                        if(MapRMACaseForUpdate.containsKey(c.Parentid)){
                            if(c.Parent.Quality_Exclusion__c != true && c.Recommended_Adjustment__c){
                                MapRMACaseForUpdate.get(c.Parentid).Quality_Exclusion__c=true;
                                System.debug('****Step5.1 Nikhil****');  
                            }
                            if(c.Root_Cause_Sub_Category__c != null 
                               && c.Parent.Quality_Exclusion_Reason__c != c.Root_Cause_Category__c + ' ' + c.Root_Cause_Sub_Category__c
                               && c.Recommended_Adjustment__c){
                                   MapRMACaseForUpdate.get(c.Parentid).Quality_Exclusion_Reason__c = c.Root_Cause_Category__c + ' ' + c.Root_Cause_Sub_Category__c;
                                   System.debug('****Step5.2 Nikhil****');  
                               }
                            else if(c.Root_Cause_Sub_Category__c == null 
                                    && c.parent.Quality_Exclusion_Reason__c != c.Root_Cause_Category__c
                                    && c.Recommended_Adjustment__c){
                                        System.debug('****Step5.3 Nikhil****');  
                                        MapRMACaseForUpdate.get(c.Parentid).Quality_Exclusion_Reason__c = c.Root_Cause_Category__c ;
                                    }
                            else if(c.Root_Cause_Category__c == null 
                                    && c.parent.Quality_Exclusion_Reason__c != ''){
                                        System.debug('****Step5.4 Nikhil****');  
                                        MapRMACaseForUpdate.get(c.Parentid).Quality_Exclusion_Reason__c = '';
                                    }
                            if(c.Root_Cause_Category__c == null 
                               && c.parent.Quality_Exclusion__c != false){
                                   System.debug('****Step5.5 Nikhil****');  
                                   MapRMACaseForUpdate.get(c.Parentid).Quality_Exclusion__c = false;
                               }
                            if(!c.Recommended_Adjustment__c && Setlabel.contains(c.Root_Cause_Category__c) 
                               && c.parent.Quality_Exclusion_Reason__c != c.Root_Cause_Category__c){
                                   System.debug('****Step5.6 Nikhil****'); 
                                   MapRMACaseForUpdate.get(c.Parentid).Quality_Exclusion_Reason__c = c.Root_Cause_Category__c;
                               }
                            else if(!c.Recommended_Adjustment__c && !Setlabel.contains(c.Root_Cause_Category__c) 
                                    && c.parent.Quality_Exclusion_Reason__c != ''){
                                        System.debug('****Step5.7 Nikhil****'); 
                                        MapRMACaseForUpdate.get(c.Parentid).Quality_Exclusion_Reason__c = '';
                                    }
                            if(!c.Recommended_Adjustment__c && !Setlabel.contains(c.Root_Cause_Category__c) 
                               && c.parent.Quality_Exclusion__c != false){
                                   System.debug('****Step5.8 Nikhil****'); 
                                   MapRMACaseForUpdate.get(c.Parentid).Quality_Exclusion__c = false;
                               }
                            else if(!c.Recommended_Adjustment__c && Setlabel.contains(c.Root_Cause_Category__c) 
                                    && c.parent.Quality_Exclusion__c != true){
                                        System.debug('****Step5.9 Nikhil****');
                                        MapRMACaseForUpdate.get(c.Parentid).Quality_Exclusion__c = true;
                                    }
                            
                        }
                        if(!MapRMACaseForUpdate.containsKey(c.Parentid)){
                            Case cs=new Case();
                            cs.id = c.Parentid;
                            System.debug('****Step7 Nikhil****');  
                            if(c.Parent.Quality_Exclusion__c != true && c.Recommended_Adjustment__c){
                                System.debug('****Step7.1 Nikhil****');
                                cs.Quality_Exclusion__c=true;
                                MapRMACaseForUpdate.put(c.Parentid,cs); 
                            }
                            if(c.Root_Cause_Sub_Category__c != null 
                               && c.Parent.Quality_Exclusion_Reason__c != c.Root_Cause_Category__c + ' ' + c.Root_Cause_Sub_Category__c
                               && c.Recommended_Adjustment__c){
                                   System.debug('****Step7.2 Nikhil****');
                                   cs.Quality_Exclusion_Reason__c = c.Root_Cause_Category__c + ' ' + c.Root_Cause_Sub_Category__c;
                                   MapRMACaseForUpdate.put(c.Parentid,cs); 
                               }
                            else if(c.Root_Cause_Sub_Category__c == null 
                                    && c.parent.Quality_Exclusion_Reason__c != c.Root_Cause_Category__c
                                    && c.Recommended_Adjustment__c){
                                        System.debug('****Step7.3 Nikhil****');
                                        cs.Quality_Exclusion_Reason__c = c.Root_Cause_Category__c ;
                                        MapRMACaseForUpdate.put(c.Parentid,cs); 
                                    }
                            else if(c.Root_Cause_Category__c == null 
                                    && c.parent.Quality_Exclusion_Reason__c != ''){
                                        System.debug('****Step7.4 Nikhil****');
                                        cs.Quality_Exclusion_Reason__c = '';
                                        MapRMACaseForUpdate.put(c.Parentid,cs); 
                                    }
                            if(c.Root_Cause_Category__c == null 
                               && c.parent.Quality_Exclusion__c != false){
                                   System.debug('****Step7.5 Nikhil****');
                                   cs.Quality_Exclusion__c = false;
                                   MapRMACaseForUpdate.put(c.Parentid,cs); 
                               }
                            if(!c.Recommended_Adjustment__c && Setlabel.contains(c.Root_Cause_Category__c) 
                               && c.parent.Quality_Exclusion_Reason__c != c.Root_Cause_Category__c){
                                   System.debug('****Step7.6 Nikhil****');
                                   cs.Quality_Exclusion_Reason__c = c.Root_Cause_Category__c;
                                   MapRMACaseForUpdate.put(c.Parentid,cs); 
                               }
                            else if(!c.Recommended_Adjustment__c && !Setlabel.contains(c.Root_Cause_Category__c) 
                                    && c.parent.Quality_Exclusion_Reason__c != null){
                                        System.debug('****Step7.7 Nikhil****'+c.parent.Quality_Exclusion_Reason__c);
                                        cs.Quality_Exclusion_Reason__c = '';
                                        MapRMACaseForUpdate.put(c.Parentid,cs); 
                                    }
                            if(!c.Recommended_Adjustment__c && !Setlabel.contains(c.Root_Cause_Category__c) 
                               && c.parent.Quality_Exclusion__c != false){
                                   System.debug('****Step7.8 Nikhil****');
                                   cs.Quality_Exclusion__c = false;
                                   MapRMACaseForUpdate.put(c.Parentid,cs); 
                               }
                            else if(!c.Recommended_Adjustment__c && Setlabel.contains(c.Root_Cause_Category__c) 
                                    && c.parent.Quality_Exclusion__c != true){
                                        System.debug('****Step7.9 Nikhil****');
                                        cs.Quality_Exclusion__c = true;
                                        MapRMACaseForUpdate.put(c.Parentid,cs); 
                                    }
                        }
                    }
                }
            }
            
            //Update parent RMA Case
            if(!MapRMACaseForUpdate.isEmpty()){    
                ParentCaseList.addAll(MapRMACaseForUpdate.values());
                System.debug('****Step11 Nikhil****'+ParentCaseList);
                update ParentCaseList;
            }//End of if
        }
        catch(Exception e){
            System.debug('-----Exception --->'+e);
        }
    }//End of Method
    public static void PopulateOldServiceAccount(List<Case> TacCaseList, Map<id,Case> mapOldCase){
        system.debug(TacCaseList);
        system.debug(mapOldCase);
        ID TACCaseRecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TSR').getRecordTypeID();
        Set<id> SetofID=new Set<id>();
        Set<id> SetofConID=new Set<id>();
        Set<id> setOfAccID=new Set<id>();
        list<Case> listTACCases = new list<Case>();
        for(Case c:TacCaseList){
            if(c.RecordTypeID == TACCaseRecordTypeId){
                if(c.ServiceAccount__c !=null && mapOldCase.get(c.id).ServiceAccount__c != null && c.ServiceAccount__c!=mapOldCase.get(c.id).ServiceAccount__c){
                    SetofID.add(mapOldCase.get(c.id).ServiceAccount__c);
                    listTACCases.add(c);
                }//End of if
                else if(mapOldCase.get(c.id).Service_Contact__c != null && c.Service_Contact__c != mapOldCase.get(c.id).Service_Contact__c){
                    SetofConID.add(mapOldCase.get(c.id).Service_Contact__c);
                    listTACCases.add(c);
                }//End of else if
            }//End of if
        }//End of for
        system.debug('*****1'+SetofID);
        system.debug('*****2'+SetofConID);
        if(!SetofConID.isEmpty()){
            List<ServiceContact__c> ServiceContactList = [SELECT id,name,Account__c FROM ServiceContact__c WHERE id in:SetofConID];
            system.debug('*****3'+ServiceContactList);
            if(!ServiceContactList.isEmpty()){
                for(ServiceContact__c cs:ServiceContactList){
                    setOfAccID.add(cs.Account__c);
                }
            }
            if(!setOfAccID.isEmpty()){
                SetofID.addAll(setOfAccID);
                system.debug('*****4'+SetofID);
            }
        }
        if(!SetofID.isEmpty()){
            Map<ID,Account> mapofSA= new Map<ID,Account>([SELECT id, Name from Account WHERE id in:SetofID]);
            system.debug('*****5'+mapofSA);
            if(!listTACCases.isEmpty()){
                for(Case c: listTACCases){
                    if(!mapofSA.isEmpty()){
                        if(mapofSA.containskey(mapOldCase.get(c.id).ServiceAccount__c)){
                            system.debug('*****6'+mapOldCase.get(c.id).ServiceAccount__c);
                            system.debug('*****7'+mapofSA.get(mapOldCase.get(c.id).ServiceAccount__c).name);
                            c.PreviousServiceAccount__c  = mapOldCase.get(c.id).ServiceAccount__c;
                            c.PreviousServiceAccountName__c = mapofSA.get(mapOldCase.get(c.id).ServiceAccount__c).name;
                        }//End of if
                    }//End of if
                }//End of for
            }//End of if   
        }   
    }///End of method
    /*    
public static void AutoPopulateRMAWarrantyOnRMACase(list<case> newCases){
ID RMACaseRecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('RMA').getRecordTypeID();
set<id> setRMACaseAsset = new set<id>();
List<case> ListRMACase = new List<case>();
list<entitlement> listEntitlement = new list<entitlement>();
map<id,list<ContractLineItem>> mapAssetWithWarrenty = new map<id,list<ContractLineItem>>();
for(Case c: newCases){
if(c.recordtypeid == RMACaseRecordTypeId && c.assetid != null 
&& c.status != 'Closed'){
setRMACaseAsset.add(c.Assetid);
ListRMACase.add(c);
}
}
system.debug(setRMACaseAsset);
if(!setRMACaseAsset.IsEmpty()){
listEntitlement =[select id,assetid,ContractLineItemId,ContractLineItem.PricebookEntry.Product2Id,ContractLineItem.PricebookEntry.Product2.MaterialGroup__c,ContractLineItem.StartDate, ContractLineItem.EndDate from entitlement where assetid in :setRMACaseAsset and status ='Active'];
}
if(!listEntitlement .IsEmpty()){
for(Entitlement e :listEntitlement  ){
if(e.ContractLineItemId != null && e.ContractLineItem.PricebookEntry.Product2.MaterialGroup__c != null){
ContractLineItem CLI = new ContractLineItem();
CLI.Description = e.ContractLineItem.PricebookEntry.Product2.MaterialGroup__c;
CLI.startdate = e.ContractLineItem.StartDate;
CLI.enddate = e.ContractLineItem.EndDate;
if(!mapAssetWithWarrenty.containskey(e.assetId)){
List<ContractLineItem> CLIList = new List<ContractLineItem>();
CLIList.add(CLI);
mapAssetWithWarrenty.put(e.assetId, CLIList);
}
else{
mapAssetWithWarrenty.get(e.assetId).add(CLI);
}
}
}
}

if(!ListRMACase.IsEmpty()){
for(Case c: ListRMACase ){
if(mapAssetWithWarrenty.containsKey(c.assetId)){
for(ContractLineItem CLI : mapAssetWithWarrenty.get(c.assetId)){
//date check - RMA CaseCreatedDate__c is in between CLI start date and CLI end date
if(CLI.StartDate <= system.now() && CLI.EndDate >= system.now()){
if(cli.Description.startswithignorecase('H') && cli.Description.EndsWithignorecase('ORIG')){
c.HardwareWarranty__c = cli.Description;    
}
else if((c.HardwareWarranty__c == NULL || !(c.HardwareWarranty__c.startswithignorecase('H') && 
c.HardwareWarranty__c.EndsWithignorecase('ORIG')))
&& cli.Description.startswithignorecase('H') && cli.Description.EndsWithignorecase('EXT')){
c.HardwareWarranty__c = cli.Description;    
}
else if(c.HardwareWarranty__c == NULL || (!(c.HardwareWarranty__c.startswithignorecase('H') && 
c.HardwareWarranty__c.EndsWithignorecase('ORIG'))
&& !(c.HardwareWarranty__c.startswithignorecase('H') && 
c.HardwareWarranty__c.EndsWithignorecase('EXT')))){
c.HardwareWarranty__c = cli.Description;
}
}
/*else if(c.HardwareWarranty__c == Null || c.HardwareWarranty__c == ''){
c.HardwareWarranty__c = 'Not Determined';
}

}
}
else if(!mapAssetWithWarrenty.containsKey(c.assetId) && (c.HardwareWarranty__c == Null || c.HardwareWarranty__c == '')){
C.HardwareWarranty__c = 'Not Determined';
}
}
}
}*/
    public static void populateCaseFieldsOnServiceCon(List<Case> newCaseList,Map<id,Case> oldCaseMap){
        
        Set<ID> SerConIDSet = new Set<ID>();
        List<ServiceContact__c> serConList = new List<ServiceContact__c>();
        map<id,ServiceContact__c> mapOfSerCon = new map<id, ServiceContact__c>();
        if(!newCaseList.isEmpty()){
            for(Case newCase:newCaseList){
                if((oldCaseMap!=null && newCase.Service_Contact__c!=oldCaseMap.get(newCase.id).Service_Contact__c) || oldCaseMap==null){
                    SerConIDSet.add(newCase.Service_Contact__c);
                }//End of if
            }//End of for
        }//End of if
        if(!SerConIDSet.isEmpty()){
            serConList= [SELECT id, Contact__c, Account__c,ServiceContact__c.Account__r.ParentID,ServiceContact__c.Account__r.Parent.Sales_Team_Email_Alias__c,
                                ServiceContact__c.Contact__r.OtherPhone,ServiceContact__c.Contact__r.Email,ServiceContact__c.Contact__r.AlternateEmail__c,
                                Case_Account_Id__c,Case_Reseller_Account_Id__c
                                 from ServiceContact__c Where ID in: SerConIDSet];
        }//End of if
        for(ServiceContact__c sc:serConList){
            mapOfSerCon.put(sc.id,sc);
        }
        for(Case newCase:newCaseList){
            if(mapOfSerCon.containsKey(newCase.Service_Contact__c) && mapOfSerCon.get(newCase.Service_Contact__c).Account__r.Parentid != null){
                newCase.ServiceAccount__c=mapOfSerCon.get(newCase.Service_Contact__c).Account__c;
                newCase.AccountID=mapOfSerCon.get(newCase.Service_Contact__c).Case_Account_Id__c;
                newCase.ContactId=mapOfSerCon.get(newCase.Service_Contact__c).Contact__c;
                newCase.ResellerAccount__c=mapOfSerCon.get(newCase.Service_Contact__c).Case_Reseller_Account_Id__c;
                if(mapOfSerCon.get(newCase.Service_Contact__c).Account__r.Parent.Sales_Team_Email_Alias__c != null){
                    newCase.AccountTeamEmailId__c=mapOfSerCon.get(newCase.Service_Contact__c).Account__r.Parent.Sales_Team_Email_Alias__c;
                }
                
            }//End of if
            
        }//End of for
        
    }//End of method
    
    public static void updateSubject(List<Case> newCaseList, Map<id,Case> oldCaseMap){
        List<Case> CaseList    =     new List<Case>();
        Set<ID> CaseIDSet    =    new Set<ID>();
        ID TACCaseRecordTypeId    =    Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TSR').getRecordTypeID();
        Map<id, Case> caseSerAccMap =new Map<id, Case>();
        for(Case c:newCaseList){
            if( c.RecordTypeid    ==    TACCaseRecordTypeId    &&  
               c.status    !=    oldCaseMap.get(c.id).status    &&
               ((c.Status    ==    'Under Investigation'    &&
               oldCaseMap.get(c.id).status    ==    'New') || //Added by Yogesh(Appirio)I-376111
                (c.Status    ==    'New'    && 
                 oldCaseMap.get(c.id).status    ==    'Draft') ||
                 (c.Status    ==    'In Progress'    && 
                 oldCaseMap.get(c.id).status    ==    'New') ||
                 (c.Status    ==    'In Progress'    && 
                 oldCaseMap.get(c.id).status    ==    'Draft') )){
                   CaseIDSet.add(c.id);   
                   CaseList.add(c);
                   
               }//End if
        }//End of for
        if(!CaseIDSet.isEmpty()){
            caseSerAccMap    =    new Map<id, case>([Select id, ServiceAccount__r.name from Case Where id in: CaseIDSet]);
        }
        if(!CaseList.isEmpty() && !caseSerAccMap.isEmpty()){
            for(Case c:CaseList){
                if(caseSerAccMap.containsKey(c.id))
                {
                    if(c.CustomerReference__c    !=    null ){
                        // string sub    =    c.subject;
                        //  system.debug('sub***'+sub);
                        string subject    =     c.CaseNumber +' / '+ 
                            caseSerAccMap.get(c.id).ServiceAccount__r.Name+' / '+ 
                            c.Severity__c+' / '+ 
                            c.CustomerReference__c+' / '+
                            c.subject;
                        c.subject    =    subject;
                        system.debug('Inside without*******************');
                        system.debug('c.subject&&&&'+c.subject);
                    }//End of if
                    
                    
                    if(c.CustomerReference__c==null    ||    c.CustomerReference__c==''){
                        string subject    =     c.CaseNumber +' / '+ 
                            caseSerAccMap.get(c.id).ServiceAccount__r.Name+' / '+ 
                            c.Severity__c+' / '+ 
                            c.Subject;
                        c.subject    =    subject;
                        system.debug('Inside with*******************');
                        system.debug('c.subject&&&&'+c.subject);
                        
                    }//End of if
                    
                    
                    system.debug('subject*****'+c.Subject);
                    
                }//End of if
            }//End of for
        }//End of if
        isRecursion=false;
        
    }//End of method
    
    // This Method prevent creation of RMA Case if Asset is marked as Gray market
    public static void validateIfGrayMarket(List<Case> newCases, Map<ID, Case> oldCaseMap){
        
        Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        List<Case> updateRMACase    =    new List<Case>();
        List<Asset> ListAsset    =    new List<Asset>();
        Set<Id> AssetID    =    new Set<Id>();
        Map<ID,Asset> MapOfAsset;
        for(Case newCase:newCases){
            if(newCase.RecordTypeID==recordTypeIdRMA && newCase.AssetId!=null){
                AssetId.add(newCase.AssetID); 
                updateRMACase.add(newCase);
            }//End of if
            system.debug('newCases##############'+newCases); 
            
        }//End of for
        if(!AssetId.isEmpty()){
            MapOfAsset       = new  Map<ID,Asset> ([SELECT id,GrayMarket__c from Asset WHERE id in:AssetId ]); 
            
            for(Case newCase:updateRMACase){
                if(MapOfAsset.containsKey(newCase.AssetID)){
                    if(MapOfAsset.get(newCase.AssetID).GrayMarket__c){
                        newCase.addError(Label.ErrorMessageForGrayMarketAsset);
                    }//End of if
                }//End of if
            }//End of for
        }//End of if          
    }//End of method
    
    public static void validateEndOfService(List<Case> newCases, Map<ID, Case> oldCaseMap){
        Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        List<Case> updateRMACaseWithProduct    =    new List<Case>();
        List<Case> updateRMACaseWithAsset    =    new List<Case>();
        List<Asset> ListAsset    =    new List<Asset>();
        List<Product2> ListProduct    =    new List<Product2>();
        Set<Id> setAssetID    =    new Set<Id>();
        Set<Id> setProductId    =    new Set<Id>();
        Map<ID, Product2> mapOfProduct;
        Map<ID,Asset> mapOfAsset;
        system.debug('newCases@@@@@@@@@@@'+newCases);
        for(Case newCase:newCases){
            if(newCase.RecordTypeID==recordTypeIdRMA && newCase.AssetId!=null){
                setAssetID.add(newCase.AssetId); 
                updateRMACaseWithAsset.add(newCase);
            }//End of if
            else if(newCase.RecordTypeID==recordTypeIdRMA && newCase.ProductID!=null && newCase.AssetID==null){
                setProductId.add(newCase.ProductID); 
                updateRMACaseWithProduct.add(newCase);
            }//End of if
        }//End of for
        if(!setAssetID.isEmpty()){
            
            mapOfAsset    =    new Map<ID,Asset>([SELECT id, Product2.End_of_Service__c from Asset Where Id in:setAssetID]);
            system.debug('@@@@@@@@@@@@@@@@@@'+mapOfAsset    );
            if(!mapOfAsset.isEmpty()){
                for(Case newCase:updateRMACaseWithAsset){
                    if(mapOfAsset.containsKey(newCase.AssetID)){
                        if(mapOfAsset.get(newCase.AssetID).Product2.End_of_Service__c < System.Today()){
                            newCase.addError(Label.EndOfServiceErrorAsset);
                        }//End of if
                    }//End of if
                }//End of for
            }//End of if
        }//End of if
        if(!setProductId.isEmpty()){
            mapOfProduct    =    new Map<id,Product2>([SELECT ID,End_of_Service__c From Product2 WHERE ID in:setProductId AND End_of_Service__c!=null]);
            
            system.debug('@@@@@@@@@@@'+mapOfProduct   );
            if(!mapOfProduct.isEmpty()){
                for(Case newCase:updateRMACaseWithProduct){
                    if(mapOfProduct.containsKey(newCase.ProductID)){
                        if(mapOfProduct.get(newCase.ProductId).End_of_Service__c    <    System.Today()){
                            newCase.addError(Label.EndOfServiceErrorProduct);
                            system.debug('RMA Case cant be created');
                        }//End of if
                    }//End of if
                }//End of for
                
            }//End of if
        }//End of if
    }//End of method
    public static void validateEntitlements(List<Case> newCases, Map<ID, Case> oldCaseMap){
        Set<ID> entitlementIDSet    =    new Set<ID>();
        Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        List<Entitlement> entitlementList    =    new List<Entitlement>();
        Map<ID,Entitlement> entitlementMap    =    new Map<ID, Entitlement>();
        for(Case newCase:newCases){
            if(newCase.RecordTypeID==recordTypeIdRMA && newCase.EntitlementID!=null){
                entitlementIDSet.add(newCase.EntitlementId);
            }//End of if
        }//End of for
        if(!entitlementIDSet.isEmpty()){
            entitlementList    =    [select id,Name, AccountID,Status,DefaultEntitlement__c,ServicePriority__c,AssetId,Asset.AccountId  from Entitlement WHERE Id in :entitlementIDSet];
            
            
            if(!entitlementList.isEmpty()){
                for(Entitlement ent:entitlementList){
                    entitlementMap.put(ent.ID,ent);
                }//End of for
                if(!entitlementMap.isEmpty()){
                    for(Case newCase:newCases){
                        if(entitlementMap.containsKey(newCase.EntitlementID)){
                            if(entitlementMap.get(newCase.EntitlementID).Status!='Active'){
                                newCase.addError(Label.ActiveEntitlementErrorMessage);
                            }//End of if
                            if(entitlementMap.get(newCase.EntitlementID).DefaultEntitlement__c==True){
                                newCase.addError(Label.MPAEntitlementErrorMessage);
                            }//End of if
                            if(entitlementMap.get(newCase.EntitlementID).ServicePriority__c==99 ||entitlementMap.get(newCase.EntitlementID).ServicePriority__c==null){
                                newCase.addError(Label.ServicePriorityError);
                            }//End of if
                            if(entitlementMap.get(newCase.EntitlementID).AssetId != null && entitlementMap.get(newCase.EntitlementID).Asset.AccountId != entitlementMap.get(newCase.EntitlementID).AccountID  && entitlementMap.get(newCase.EntitlementID).Name!=Label.Bypass){
                                newCase.addError(Label.SoldToErrorMessage);
                            }//End of if
                        }//End of if
                    }//End of for
                }//End of if
            }//End of if
        }//End of if
    }//End of method
    public static void updateRMALineItems(List<Case> ListCase){
        Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        List<RMA_Line_Item__c> ListRMALineItem = new List<RMA_Line_Item__c>();
        Set<Id> SetCaseId = new Set<Id>();
        for(Case objCase:ListCase){
            if(objCase.RecordTypeId==recordTypeIdRMA && objCase.Reason=='Adv. Replacement - Scheduled'){
                SetCaseId.add(objCase.id);
            }
        }
        if(!SetCaseId.isEmpty()){
            for(Case objCase:[SELECT Id,Reason,ScheduledDeliveryDateTime__c,Customer_TZ__c,(SELECT Id,Case__c,ScheduledDeliveryDateTime__c,Customer_TZ__c FROM RMA_Line_Items__r) FROM Case WHERE Id IN: SetCaseId]){
                
                for(RMA_Line_Item__c objRMALineItem:objCase.RMA_Line_Items__r ){    
                    objRMALineItem.ScheduledDeliveryDateTime__c = objCase.ScheduledDeliveryDateTime__c;
                    objRMALineItem.Customer_TZ__c = objCase.Customer_TZ__c;
                    ListRMALineItem.add(objRMALineItem);     
                }
                
            }
            if(!ListRMALineItem.isEmpty()){
             update ListRMALineItem;
            }
        }
    }// END of method
    
    public static void sendDummyRequestToAzure(list<Case> caseList){
        list<id> caseIdsTosendReq = new list<id>();
        Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        for(Case c : caseList){
            if(c.RecordTypeId==recordTypeIdRMA){
                //             System.debug('**Case c=='+c);
                //             System.debug('c.SLP_Order_Status__c='+c.SLP_Order_Status__c);
                System.debug('c.SLP_Acknowledgement__c='+c.SLP_Acknowledgement__c);
                System.debug('c.slp_order_status_date__c='+c.slp_order_status_date__c); 
                if(c.SLP_Order_Status__c == 'Confirmed' && c.SLP_Acknowledgement__c != '' && c.SLP_Acknowledgement__c != null && c.slp_order_status_date__c == null){               
                    caseIdsTosendReq.add(c.Id);
                }
            }
        }// end of for loop
        if(caseIdsTosendReq.size() > 0){
            DummyReqCreator.createDummyReq(caseIdsTosendReq);
        }
        
    }
    
    public static void AutoSetNBDReviewRequired(List<Case> caseList){
        id RMARecordTypeId          = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        
        for(Case objCase: caseList){
            System.debug('objCase:'+objCase);
            System.debug('objCase.Will_Call__c:'+objCase.Will_Call__c );
            System.debug('objCase.NBD_Review_Rqd__c:'+objCase.NBD_Review_Rqd__c );
            System.debug('objCase.NBDReviewComments__c:'+objCase.NBDReviewComments__c);
            if(!String.Isblank(objCase.reason)){
                if(objCase.RecordTypeId == RMARecordTypeId && objCase.Reason.containsIgnoreCase('NBD') && objCase.Will_Call__c ){
                    if(!objCase.NBD_Review_Rqd__c  ){
                        objCase.NBD_Review_Rqd__c = TRUE;
                        if(!String.isBlank(objCase.NBDReviewComments__c) ){
                            objCase.NBDReviewComments__c = 'Will-call required+'+objCase.NBDReviewComments__c;
                        }else{
                            objCase.NBDReviewComments__c = 'Will-call required';
                        }
                    }
                    
                }
            }
            
        }
    }// End of method
    
    /*
******************************************************************************************************************
** Method name:         updateJiraCreationDate
** Method description:  Modified code for ticket # 304255: Automatically populate the current date/time into the 
**                      "Jira Creation Date" field when the "Jira ID" field is set.
** @Param:              List<Case> newCases, Map<Id,Case> oldCaseMap
** @return:             None.
**
******************************************************************************************************************
*/
    /* public static void updateJiraCreationDate(List<Case> newCases, Map<Id,Case> oldCaseMap){

for(Case cs:newCases){
if(cs.JiraID__c != null){
cs.Jira_Creation_Date__c=system.now();
}
}
}

*/
    
    /*************************************************************************************************
**
Method Description: This method shows error message while creating RMA case on below conditions.
1. If RMA Case Type is "Return Consigned Goods".
2. If selected Asset is with status "Loaner".

@Param:             List<case>

@Return:            None
*************************************************************************************************/
    public static void blockRMAForSpecialStockAsset (List<case> newCases){
        List<Asset> lstAsset = new List<Asset>();
        Map<id, case> mapCaseAsset = new Map<Id, Case>();
        Id devRecordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        try{
            for(Case cs: newCases){
                if(cs.recordTypeId == devRecordTypeIdRMA && cs.RMAType__c != 'Return Consigned Goods'){
                    mapCaseAsset.put(cs.AssetId, cs);
                }
            }
            if(mapCaseAsset != NULL){
                lstAsset = [select id, name, Status from Asset where id in :mapCaseAsset.keySet() and Status = 'Loaner'];
                if(!lstAsset.isEmpty()){
                    for(Asset ass: lstAsset){
                        mapCaseAsset.get(ass.id).addError('Select Asset is a Consigned Good Unit, please select RMA Type as Return Consigned Goods');
                    }
                }
            }
        }catch(Exception e){
            System.debug('e.getLineNumer()=='+e.getLineNumber());
        }   
    }
    /*************************************************************************************************
**
Method Description: This method updates a TAC case field, ReceivedFeedback__c to FALSE, if the 
TAC case status gets changed any value from "Resolved".

@Param:             List<case>, Map<Id, Case>

@Return:            None
*************************************************************************************************/
    public static void updateCaseReceivedFeedback (List<Case> lstCase, Map<Id, Case> oldCaseMap){
        List<case> lstCases = new List<Case>();
        List<case> lstCaseUpdate = new List<Case>();
        Set<id> caseIds = new Set<Id>();
        for(Case cs: lstCase){
            if(cs.Status != 'Resolved' && cs.Status != oldCaseMap.get(cs.Id).Status
               && oldCaseMap.get(cs.Id).ReceivedFeedback__c == true){
                   caseIds.add(cs.id);
               }
        }
        if(!caseIds.isEmpty()){
            lstCases = [select id, ReceivedFeedback__c, Feedback_Survey_View_Count__c from Case where id in :caseIds];
            for(Case cse: lstCases){
                cse.ReceivedFeedback__c = false;
                lstCaseUpdate.add(cse);
            }
        }
        if(!lstCaseUpdate.isEmpty()){
            update lstCaseUpdate;
        }
    }
    
/*************************************************************************************************************************
Purpose:- Check & Create Repair Case has to be created for HRR Or FA
*************************************************************************************************************************************/
    public static void createRepairForHrrOrFA(Map<id,case> newCasesMap){
        List<Case> hrrCaseList = new List<Case>();
        Id recordTypeIdHRR = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        for(case cs : [SELECT ParentId,RecordTypeId,Severity__c,FASubType__c,PCBAPartNumber__c,PCBASerialNumber__c,ComponentPN__c,Reference_Designator__c,SupplierVendorName__c,ActualRecievedSerialNumber__c,AssetId,RMAType__c,ProductId,Service_Contact__r.ContactEmail__c,asset.product2Id,Asset.Product2.Service_Override__c,Asset.Product2.Product_Status__c FROM Case 
                       WHERE id IN :newCasesMap.keySet() AND RecordTypeId = :recordTypeIdHRR])
        {
            if(cs.ProductId !=NULL && cs.Service_Contact__r.ContactEmail__c !=NULL && cs.RMAType__c != 'Multi Vendor' && cs.asset.product2Id != NULL && (cs.Asset.Product2.Service_Override__c=='Always Perform' 
               ||(cs.Asset.Product2.Product_Status__c =='G1' || cs.Asset.Product2.Product_Status__c =='G2' || cs.Asset.Product2.Product_Status__c =='G3' || cs.Asset.Product2.Product_Status__c =='G4' || cs.Asset.Product2.Product_Status__c =='G5'))){
                   
               }
            else{
                hrrCaseList.add(cs);
            }
        }
        if(hrrCaseList.size()>0){
            createRepairCase(hrrCaseList);
        }
    }
    
/*************************************************************************************************************************
Purpose:- Create Child Repair Case For HRR Or FA Case
*************************************************************************************************************************************/
    public static void createRepairCase(LIST<case> caseList){
        List<Case> repairCaseList = new List<Case>();
        Id recordTypeIdRepair = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        for(Case cs : caseList){
                case repairCase = new Case();
                repairCase.ParentId = cs.id;
                repairCase.RecordTypeId = recordTypeIdRepair;
                repairCase.Severity__c = cs.Severity__c;
                repairCase.PCBAPartNumber__c = cs.PCBAPartNumber__c;
                repairCase.PCBASerialNumber__c = cs.PCBASerialNumber__c;
                repairCase.ComponentPN__c = cs.ComponentPN__c;
                repairCase.Reference_Designator__c = cs.Reference_Designator__c;
                repairCase.SupplierVendorName__c = cs.SupplierVendorName__c;
                repairCase.ActualRecievedSerialNumber__c = cs.ActualRecievedSerialNumber__c;
                repairCaseList.add(repairCase);
        }
        if(repairCaseList.size()>0){
            insert repairCaseList;
        }
    }
    
/*************************************************************************************************************************
Purpose:- Populate RMA vendor as per the MAPpings in Return Address object
*************************************************************************************************************************************/    
    public static void populateRMADetails(LIST<case> newCases){
        Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        LIST<Case> updateCaseDetails = new LIST<Case>();
        Set<String> RMAShipToCountries = new Set<String>();
        LIST<ReturnAddresses__c> rmaReturnAddress = new LIST<ReturnAddresses__c>();
        Map<Id,Id> caseProductIds = new Map<Id,Id>();
        List<Product2> productList  = new List<Product2>();
        Map<Id,Product2> mapProductFamily = new Map<Id,Product2>();
        Set<ID> accountIds = new set<Id>();
        String msMaterialgroup = System.Label.MSMaterialGroups;
        Set<Id> metroSwedenProducts = new Set<Id>();
        set<string> productFamilies = new set<String>();
        for(Case c: newCases){
            System.debug('$$$$New Cases$$$$'+newCases);
            System.debug('$$$$RMA Shipt To$$$$'+c.RMA_Ship_To__c);
            System.debug('$$$$RMA Shipt To Country$$$$'+c.ShipToCountry__c);
            if(c.RMA_Ship_To__c != Null && c.ShipToCountry__c!= null && c.ProductId != Null && c.RecordTypeId == recordTypeIdRMA){
                updateCaseDetails.add(c);
                RMAShipToCountries.add(c.ShipToCountry__c);
                accountIds.add(c.accountId);
                caseProductIds.put(c.Id,c.ProductId);
            }//END IF  
        }//END FOR
        
        if(!RMAShipToCountries.isEmpty()){
            RMAShipToCountries.add('United States');
            
            if(caseProductIds != null){
                System.debug('$$$$ProductIds$$$$'+caseProductIds);
                productList = [Select Id,Name,ProductFamily__c,MaterialGroup__c from Product2 where Id IN:caseProductIds.values()];
                
                if(!productList.isEmpty()){
                    for(product2 thisObj: productList){
                        mapProductFamily.put(thisObj.Id,thisObj);
                        productFamilies.add(thisObj.ProductFamily__c);
                    }
                    system.debug('*********mapProductFamily'+mapProductFamily);
                }
                System.debug('$$$$List Products$$$$'+productList);
            }
            
            
            System.debug('$$$$RMA Countries*$$$$'+RMAShipToCountries);
            rmaReturnAddress = [SELECT Id,Name,LookUpCountries__c,Vendor_Code__c,Return_to_Zip__c,ReturnToAddress__c,ReturnToAddress2__c,ReturnToAddress3__c,ReturnToCity__c,ReturnToCountry__c,ReturnToProvince__c,ReturnToState__c,ReturnCustomerSiteInfo__c,RMAVendor__c,Material_Group__c,Customer__c,Product_Family__c FROM ReturnAddresses__c where LookUpCountries__c IN :RMAShipToCountries OR Customer__c IN :accountIds OR Product_Family__c IN :productFamilies];
            
            
            for(Case thisCase: updateCaseDetails){
                for(ReturnAddresses__c thisAddr: rmaReturnAddress){                 
                    if(thisCase.accountId == thisAddr.Customer__c){
                        system.debug('******InsideCustomer*****');
                        if(thisAddr.Product_Family__c == mapProductFamily.get(thisCase.ProductId).ProductFamily__c){
                        system.debug('******InsideCustomerFamily*****');
                            thisCase = mapRMALineItems(thisCase,thisAddr);  
                            break;
                        }else if(thisAddr.Material_Group__c != null && thisAddr.Material_Group__c == mapProductFamily.get(thisCase.ProductId).MaterialGroup__c){
                        system.debug('******InsideCustomerMaterialGroup*****');
                            thisCase = mapRMALineItems(thisCase,thisAddr);
                            break;
                        }else if(thisAddr.Material_Group__c == null && thisAddr.Product_Family__c == NULL){
                        system.debug('******InsideCustomerFinal*****');
                            thisCase = mapRMALineItems(thisCase,thisAddr);
                            break;
                        }
                        
                    }else if(thisCase.ShipToCountry__c == thisAddr.LookUpCountries__c  && thisAddr.Material_Group__c != null){
                        if(thisAddr.Material_Group__c == mapProductFamily.get(thisCase.ProductId).MaterialGroup__c){
                        system.debug('******InsideCountryMatch*****');
                            thisCase = mapRMALineItems(thisCase,thisAddr);
                            break;
                        }else if(thisAddr.Material_Group__c == 'ALL'){
                        system.debug('******InsideMaterialGroupMatch*****');
                            thisCase = mapRMALineItems(thisCase,thisAddr);         
                        }else if(thisAddr.Material_Group__c == NULL && thisAddr.Product_Family__c == NULL){
                            system.debug('******InsideUSAddressMatch*****');
                            thisCase = mapRMALineItems(thisCase,thisAddr);                          
                        }//END OF IF
                    }else if(thisAddr.Product_Family__c == mapProductFamily.get(thisCase.ProductId).ProductFamily__c){          
                            system.debug('******InsideUSAddressMatch*****');
                            thisCase = mapRMALineItems(thisCase,thisAddr);                  
                    }
                }//END OF FOR
            }//END OF FOR
        }//END IF
    }//END OF METHOD    
    
public static Case mapRMALineItems(Case thisCase,ReturnAddresses__c thisAddr){
    
    thisCase.ReturnToAddressee__c = thisAddr.Name;
    thisCase.ReturnToAddress__c = thisAddr.ReturnToAddress__c;
    thisCase.ReturnToAddress2__c = thisAddr.ReturnToAddress2__c;
    thisCase.ReturnToAddress3__c = thisAddr.ReturnToAddress3__c;
    thisCase.ReturnToCity__c = thisAddr.ReturnToCity__c;
    thisCase.ReturnToCountry__c = thisAddr.ReturnToCountry__c;
    thisCase.ReturnToProvince__c = thisAddr.ReturnToProvince__c;
    thisCase.ReturnToState__c = thisAddr.ReturnToState__c;
    thisCase.ReturnToZip__c = thisAddr.Return_to_Zip__c;
    thisCase.ReturnCustomerSiteInfo__c = thisAddr.ReturnCustomerSiteInfo__c;
    thisCase.RMAVendor__c = thisAddr.RMAVendor__c;
    thisCase.LSP_Code__c = thisAddr.Vendor_Code__c;    
    
    return thisCase;  
}    
    
    /************************************************************************************************************************************
Purpose:- Populate Return Address as per the Mappings in Return Address object on changes to Ship to Address on RMA Case
*************************************************************************************************************************************/    
    public static void populateRMADetailsUpdate(LIST<case> newCases, Map<Id,Case> oldCaseMap){ 
        List<Case> listCaseUpdates = new List<Case>();
        for(Case thisCase: newCases){
            if(thisCase.RMA_Ship_To__c != null && thisCase.RMA_Ship_To__c != oldCaseMap.get(thisCase.Id).RMA_Ship_To__c){
                listCaseUpdates.add(thisCase);
            }//END OF IF
        }//END OF FOR
        
        if(!listCaseUpdates.isEmpty()){
            populateRMADetails(listCaseUpdates);
        }//END OF IF
    }//END OF METHOD
    // Method added to prevent changing the owner to any other queue except call center queue by any user except TAC manager or TAC engineer profile
    public static void preventChangeOwnerOtherThanCallCenterQueue(List<Case> newList, Map<Id,Case> oldMap){
        Set<String> groupSet = new Set<String>();
        for(Group grp : [select Id, DeveloperName from Group where  Type = 'Queue' AND DeveloperName in ('Call_Center_Queue', 'Technical_Support_Queue')]){
            groupSet.add(grp.Id);
        }
        //Group callCenterQueue = [select Id from Group where  Type = 'Queue' AND NAME = 'Call Center Queue'];
        Id recordTypeIdTAC = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TSR').getRecordTypeId();
        system.debug('<<>>'+UserInfo.getProfileId()+Label.TAC_Manager_Profile_ID+Label.TAC_Engineer_Profile_ID);
        for(Case c: newList){
            String ownerString = String.valueof(c.OwnerId);
             //Condition updated by Shresth(Appirio) Added(c.Origin != 'Email')
            if(ownerString.startsWith('00G') && c.RecordTypeId == recordTypeIdTAC  && oldmap.get(c.id).OwnerId != c.OwnerId && 
               !groupSet.contains(c.OwnerId) && UserInfo.getProfileId() != Label.TAC_Manager_Profile_ID && UserInfo.getProfileId() != Label.TAC_Engineer_Profile_ID &&
               UserInfo.getProfileId() != Label.Call_Center_Profile_Id && c.Origin != 'Email'){
                   c.addError('Please assign this to the call center queue.');
               }//END IF
        }//END FOR
    }//END METHOD
    //Method added to prevent adding HRR case if any HRR case is already added to the parent of this case with same serial nos
    public static void preventHRRCaseCreation(List<Case> newList){
        Id recordTypeIdRMA = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        Set<Id> parentCaseIdSet =  new Set<Id>();
        Set<Id> parentCaseIdWithHRRCaseSet = new Set<Id>();
        Set<String> serialNumberSet = new Set<String>();
        List<Case> hrrCaseList = new List<Case>();
        for(Case newCase : newList){
            if(newCase.RecordTypeId == recordTypeIdRMA && newCase.ParentId != null && newCase.Serial_Number_Customer__c != null){
                parentCaseIdSet.add(newCase.ParentId);
                hrrCaseList.add(newCase);
                serialNumberSet.add(newCase.Serial_Number_Customer__c);
            }
        }
        for(Case hrrCase :[SELECT Id, ParentId
                           FROM Case 
                           WHERE ParentId IN: parentCaseIdSet 
                           AND RecordTypeId = :recordTypeIdRMA 
                           AND Serial_Number_Customer__c IN: serialNumberSet]){
                               parentCaseIdWithHRRCaseSet.add(hrrCase.ParentId);
                           }
        if(parentCaseIdWithHRRCaseSet.size()>0){
            for(Case c: hrrCaseList){
                if(parentCaseIdWithHRRCaseSet.contains(c.ParentId)){
                    c.addError('There is already a Hardware Replacement Request for this serial number.');
                }
            }
        }
    }
    
    public static void updateOwnerToAutomationQueue(List<Case> newList){
        System.debug('>>> Inside updateOwnerToAutomationQueue :');
        Id recordTypeIdTAC = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TSR').getRecordTypeId();
        Map<id,boolean> serviceAccMap = new Map<Id,Boolean>();
        Set<Id> entitlementIdSet = new Set<id>();
        Map<Id,String> entIdToStatusMap = new Map<Id,String>();
        List<String> queueList = new List<String>();
        //queueList.add('Automation Queue');
        queueList.add('Call Center Automation Queue'); // Added by Mukesh(Appirio) I-378931
        queueList.add('Exception Queue');
        List<Group> QueueIDList = [select Id,Name from Group where  Type = 'Queue' AND NAME IN: queueList ORDER BY Name];
        //Group exceptionQueue = [select Id from Group where  Type = 'Queue' AND NAME = 'Exception Queue'];
        System.debug('>>> QueueIDList :'+QueueIDList);
        for(Case newC :newList){
            System.debug('>>> newC.ServiceAccount__c :'+newC.ServiceAccount__c);
            if(newC.recordtypeId == recordTypeIdTAC && newC.ServiceAccount__c != null ){
                serviceAccMap.put(newC.ServiceAccount__c,false); 
                entitlementIdSet.add(newC.EntitlementId);
                System.debug('>>> Inside first for :');
            }
        }
        if(serviceAccMap.size()>0){
            for(Account c :[SELECT id,Apply_To_Automation_Queue__c FROM Account WHERE Id IN: serviceAccMap.keySet()]){
                if(c.Apply_To_Automation_Queue__c){
                    serviceAccMap.put(c.id,true);
                }
            }
            if(entitlementIdSet.size()>0){
                for(Entitlement ent: [SELECT Id,Status FROM Entitlement WHERE Id IN: entitlementIdSet]){
                    entIdToStatusMap.put(ent.id, ent.status);
                    
                }
                //System.debug('>>> serviceAccMap.containsKey(c.ServiceAccount__c) :'+serviceAccMap.containsKey(c.ServiceAccount__c));
                //System.debug('>>> serviceAccMap.get(c.ServiceAccount__c) :'+serviceAccMap.get(c.ServiceAccount__c));
                System.debug('>>> entIdToStatusMap :'+entIdToStatusMap);
                
                for(Case c: newList){
                    System.debug('>>> c.ServiceAccount__c :'+c.ServiceAccount__c);
                    System.debug('>>> serviceAccMap.containsKey(c.ServiceAccount__c) :'+serviceAccMap.containsKey(c.ServiceAccount__c));
                    System.debug('>>> serviceAccMap.get(c.ServiceAccount__c) :'+serviceAccMap.get(c.ServiceAccount__c));
                    System.debug('>>> c.Severity__c :'+c.Severity__c);
                    System.debug('>>> c.Has_Valid_Entitlement__c :'+c.Has_Valid_Entitlement__c);
                    
                    if(c.ServiceAccount__c != null && serviceAccMap.containsKey(c.ServiceAccount__c) && serviceAccMap.get(c.ServiceAccount__c) && c.Severity__c == 'Critical' && c.Has_Valid_Entitlement__c){  //c.Severity__c == 'Critical' && c.Has_Valid_Entitlement__c added by Mukesh(Appirio) I-378931 
                        System.debug('>>> First Id :');
                        if(c.EntitlementId != null && entIdToStatusMap.containsKey(c.EntitlementId) && entIdToStatusMap.get(c.EntitlementId) == 'Active'){
                            c.OwnerId = QueueIDList[0].id;
                            System.debug('>>> Assigned to Queue :'+QueueIDList[0].id);
                        }
                        else{
                            c.OwnerId = QueueIDList[1].id;
                        }
                    }
                }
            }
        }
    }
    
    /*
Method Name - updateSpecialInstructions
Description - This method is used to autopopulate the ROHS Shipment message on the Special Instructions field on the Hardware
Replacement Case
*/
    public static void updateSpecialInstructions(list<Case> listCases){
        List<Case> updateCases = new List<Case>();
        Set<Id> assetIds = new Set<Id>();
        Map<Id,Asset> mapAssets;
        Id HRRRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HRR').getRecordTypeId();
        for(Case thisCase :listCases){
            if(thisCase.RecordTypeId == HRRRecordTypeID && thisCase.AssetId != null && thisCase.ShipToCountry__c != 'United States'){
                updateCases.add(thisCase);
                assetIds.add(thisCase.AssetId);
            }//END OF IF
        }//END OF FOR
        if(!assetIds.isEmpty() && !updateCases.isEmpty()){
            mapAssets = new Map<Id,Asset>([Select Id,SerialNumber,Name,ROHS_Compliant__c from Asset where Id IN:assetIds]);         
            if(mapAssets != null){
                for(Case thisRec :updateCases){
                    if(mapAssets.containsKey(thisRec.assetId) && mapAssets.get(thisRec.assetId).ROHS_Compliant__c){
                        thisRec.Special_Instruction__c = system.label.ROHSMessage;
                    }//END OF IF
                }//END OF FOR
            }//END OF IF
        }//END OF IF
    }//END OF METHOD    

    /************************************************************************************************************************************
Purpose:- Handle Case status and owner assignment with respect to entitlement
*************************************************************************************************************************************/
    public static void checkValidEntitlementForCase(List<Case> newCaseList,Map<id,case> oldCaseMap){
        List<String> queueNameList =new List<String>{'Exception Queue','Call Center Queue'};
        Map<String,id> queueMap = new Map<String,id>();
        for(Group gp:[SELECT id,Name FROM Group WHERE Name IN :queueNameList]){
            queueMap.put(gp.Name,gp.id);
        }
        Id recordTypeIdTAC = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TSR').getRecordTypeId();
        for(Case cs:newCaseList){
            if(cs.RecordTypeId == recordTypeIdTAC){
                if((!String.isBlank(cs.EntitlementId) && oldCaseMap == null) || (oldCaseMap != null && !String.isBlank(cs.EntitlementId) && oldCaseMap.get(cs.id).EntitlementId!=cs.EntitlementId )){
                    cs.Has_Valid_Entitlement__c = True;
                    cs.Status = 'New';
                }
                else{
                    if((String.isBlank(cs.EntitlementId) && oldCaseMap == null) || (String.isBlank(cs.EntitlementId) && oldCaseMap != null && oldCaseMap.get(cs.id).EntitlementId!=cs.EntitlementId)){
                        cs.Has_Valid_Entitlement__c = False;
                        cs.Status = 'Draft';
                    }
                }
            }
            
        }
        
    }

    /****************************************************************************************
Method Name:        SetCompletionDateOnTERcaseMilestone
**
Method description: This method updates the milestone completion date for TER cases on 
                    status change. 
**
@Param:             LIST<Case> NewRecords,
                    Map<id, Case>OldCaseMap
@Return             void
/****************************************************************************************/ 
    public static void SetCompletionDateOnTERcaseMilestone(LIST<Case> NewRecords,Map<id, Case>OldCaseMap ){
        LIST<id> CaseIds = new LIST<id>();
        LIST<Case> NewCases = new LIST<Case>();
        MAP<id, List<CaseMilestone>> CaseMilestoneWithCaseMAP = new MAP<id, List<CaseMilestone>>();
        LIST<CaseMilestone> CaseMilestones = new LIST<CaseMilestone>();
        Id terCaseRecordType  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TER').getRecordTypeId();
        for(Case c: NewRecords){
            if((OldCaseMap.get(c.id).status=='New' &&  c.status == 'Assigned' && c.recordtypeId == terCaseRecordType) 
                || (c.recordtypeId == terCaseRecordType && c.status == 'In Progress'  && OldCaseMap.get(c.id).status=='Assigned') 
                || (c.recordtypeId == terCaseRecordType && c.status == 'Resolved' && OldCaseMap.get(c.id).status=='In Progress')
                || (c.recordtypeId == terCaseRecordType && c.status == 'Closed' && OldCaseMap.get(c.id).status=='Resolved')){
                    CaseIds.add(c.id);       
                    NewCases.add(c);
            }   
        }
        system.debug('&&&&&&&&&&&&&&&'+caseids);
        if(!NewCases.isEmpty()){   
            if(!CaseIds.IsEmpty()){
                CaseMilestones = [select id,CaseId,CompletionDate,isCompleted,milestonetype.name from CaseMilestone where caseid in: CaseIds  and isCompleted = False];
            }
            system.debug('--------------------'+[select id,CaseId,CompletionDate,isCompleted,milestonetype.name from CaseMilestone where caseid in: CaseIds]);
            if(!CaseMilestones.IsEmpty()){
                for(CaseMilestone CM : CaseMilestones){
                    List<CaseMilestone> listMilestones = new List<CaseMilestone>();
                    if(CaseMilestoneWithCaseMAP.containsKey(cm.caseId)){
                        listMilestones = CaseMilestoneWithCaseMAP.get(cm.caseId);
                    }//END IF
                    listMilestones.add(cm);
                    CaseMilestoneWithCaseMAP.put(cm.caseid, listMilestones);    
                }//END FOR
            }
            system.debug('---------------'+CaseMilestoneWithCaseMAP);
            List<CaseMilestone> milestonesToUpdate =  new List<CaseMilestone>();
            for(Case c : NewCases){
                if(CaseMilestoneWithCaseMAP.containsKey(c.id)){
                    for(CaseMilestone cm : CaseMilestoneWithCaseMAP.get(c.id)){
                        if((c.status == 'Assigned') && cm.milestonetype.name.contains('Assignment')){
                            cm.CompletionDate = System.now();
                            system.debug('**** Inside Assignment'); 
                            milestonesToUpdate.add(cm); 
                        }
                        else if(c.status == 'In Progress'  && (cm.milestonetype.name.contains('Investigation Started'))){
                            cm.CompletionDate = System.now();
                            milestonesToUpdate.add(cm);
                            system.debug('**** Inside In Progress');
                        }else if (c.status == 'Resolved' && (cm.milestonetype.name.contains('Resolution'))){
                            cm.CompletionDate = System.now();
                            milestonesToUpdate.add(cm);
                            system.debug('**** Inside Resolved');                                                                                                                                                                                         
                        }else if(c.status == 'Closed' && (cm.milestonetype.name.contains('Closure'))){
                            cm.CompletionDate =System.now();
                            milestonesToUpdate.add(cm);
                            system.debug('**** Inside Closure');
                        }                                                                                                                                                                                                                                                                                                                  
                        
                    }//END FOR               
                }//END IF
            }//END FOR
            system.debug('**milestonesToUpdate***'+milestonesToUpdate);
            if(milestonesToUpdate!= null && !milestonesToUpdate.isEmpty()){
                update milestonesToUpdate;
            }
        }//END IF          
        
    }//END METHOD

    /****************************************************************************************
Method Name:        updateTERstatusOnOwnerChange
**
Method description: This method updates the staus of TER case to Assigned from New, if the owner 
                    gets changed.
**
@Param:             LIST<Case> NewRecords,
                    Map<id, Case>OldRecordMAP
@Return             void
/****************************************************************************************/ 

public static void updateTERstatusOnOwnerChange(LIST<case> NewRecords, MAP<id, case> OldRecordMAP){
    LIST<case> UpdatedRecords = new LIST<case>();
    ID TERCaseIds = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TER').getRecordTypeId();
    for(case SingleRecord : NewRecords) {
        if(SingleRecord.status == 'New' && SingleRecord.RecordTypeId == TERCaseIds && String.valueOf(SingleRecord.OwnerId).startsWith('005')
            && OldRecordMAP != NULL && String.valueOf(OldRecordMAP.get(SingleRecord.Id).OwnerId).startsWith('00G')){
                SingleRecord.status = 'Assigned';
        }//END IF            
    }//END FOR
    
}//END METHOD

/************************************************************************************************************************************
Purpose:- Populate Default Entitlement On Case Type TER(Implemented by shresth appirio)
*************************************************************************************************************************************/    
    public static void populateDefaultEntitlement(LIST<case> newCases, MAP<id, case> oldCaseMAP){
        Id recordTypeIdTER = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TER').getRecordTypeId();
        Entitlement defaultTEREntitlement  = new Entitlement();
        try{
            defaultTEREntitlement = [SELECT Id FROM Entitlement WHERE Name = :Label.Default_TER_Entitlement LIMIT 1];
        }
        catch(Exception e){
            System.debug('QueryException : '+e.getMessage());
        }
        if(!String.isBlank(defaultTEREntitlement.id)){
            for(Case cs:newCases){
                if(cs.RecordTypeId == recordTypeIdTER){
                    if(cs.EntitlementId != defaultTEREntitlement.id){
                        cs.EntitlementId = defaultTEREntitlement.id;
                    }
                }
            }
        }
    }  
    
}//END CLASS;