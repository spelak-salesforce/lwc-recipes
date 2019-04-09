public with sharing class ContactController {

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [SELECT Id, Name, Title, Phone, Email, Picture__c FROM Contact WHERE Picture__c != null LIMIT 10];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> findContacts(String searchKey) {
        if (String.isBlank(searchKey)) {
            return new List<Contact>();
        }
        String key = '%' + searchKey + '%';
        return [SELECT Id, Name, Title, Phone, Email, Picture__c FROM Contact WHERE Name LIKE :key AND Picture__c != null LIMIT 10];
    }

    @AuraEnabled(cacheable=true)
    public static Contact getSingleContact(){
        return [SELECT Id, Name, Title, Phone, Email, Picture__c FROM Contact LIMIT 1];
    }



    public class ResponseField {
        @AuraEnabled public Object value;

        public ResponseField(Object value) {
            this.value = value;
        }
    }

    public class ResponseFields {
        @AuraEnabled public ResponseField Id, Name, Title, Phone, Email;
    }

    public class ResponseData {
        @AuraEnabled public ResponseFields fields;
    }

    public class ResponseContact {
        @AuraEnabled public ResponseFields fields;

        public ResponseContact(Contact contact) {
            this.fields = new ResponseFields();
            this.fields.Id = new ResponseField(contact.Id);
            this.fields.Name = new ResponseField(contact.Name);
            this.fields.Title = new ResponseField(contact.Title);
            this.fields.Phone = new ResponseField(contact.Phone);
            this.fields.Email = new ResponseField(contact.Email);
        }
    }

    @AuraEnabled(cacheable=true)
    public static ResponseContact getContactById(Id recordId){
        return new ResponseContact([
            SELECT Id, Name, Title, Phone, Email, Picture__c 
            FROM Contact 
            WHERE Id = :recordId
            LIMIT 1
        ][0]);
    }

}