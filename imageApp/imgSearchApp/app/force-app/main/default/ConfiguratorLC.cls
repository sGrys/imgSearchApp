public with sharing class ConfiguratorLC {
    
    public static String ENDPOINT = 'https://jsonplaceholder.typicode.com/photos';

    public static List<Image_schema.Image> getImagesFromWeb(){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('GET');
        Http http = new Http();
        HTTPResponse response = http.send(request);
        return (List<Image_schema.Image>) JSON.deserialize(response.getBody(),List<Image_schema.Image>.class);
    }

    @auraEnabled
    public static void sendEmail(String id){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { '0033E00001Ds2zWQAR' };
        message.optOutPolicy = 'FILTER';
        message.subject = 'Image';
        message.plainTextBody = 'This is the message body.';
        //todo add attachements
        Messaging.SingleEmailMessage[] messages = 
            new List<Messaging.SingleEmailMessage> {message};
                 Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: '
                  + results[0].errors[0].message);
        }
    }

    @auraEnabled
    public static List<Image_schema.Image> getImagesFromDB() {
        List<Image_schema.Image> images = new List<Image_schema.Image>();
        try{
            List<Image__c> imagesInDb = [SELECT 
                id__c,
                albumId__c,
                title__c,
                url__c,
                thumbnailUrl__c,
                isSelected__c FROM Image__c LIMIT 100]; //limit to 100 for faster development
            
            for(Image__c i : imagesInDb) {
                images.add(mapSObjectToSchema(i));
            }
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
        return images;
    }

    @auraEnabled
    public static List<Image_schema.Image> searchEngine(String searchText) {
        List<Image_schema.Image> images = new List<Image_schema.Image>();
        try{
            List<Image__c> imagesInDb = [SELECT 
                id__c,
                albumId__c,
                title__c,
                url__c,
                thumbnailUrl__c,
                isSelected__c FROM Image__c
                WHERE id__c = :searchText LIMIT 100];
            
            if(searchText == ''){
                images = getImagesFromDB();
            }
            for(Image__c i : imagesInDb) {
                images.add(mapSObjectToSchema(i));
            }
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
        return images;
    }
    public static void addImagesToDB() {
        try{
            List<Image_schema.Image> images = getImagesFromWeb();
            List<Image__c> sObjectList = new List<Image__c>();
            for(Image_schema.Image image : images){
                sObjectList.add(mapSchemaToSObject(image));
            }
            insert sObjectList;
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

    public static Image__c mapSchemaToSObject(Image_schema.Image image){
        Image__c obj = new Image__c();

        obj.id__c = image.id;
        obj.albumId__c = image.albumId;
        obj.title__c = image.title;
        obj.url__c =image.url;
        obj.thumbnailUrl__c = image.thumbnailUrl;
        obj.isSelected__c = image.isSelected;

        return obj;
    }

    public static Image_schema.Image mapSObjectToSchema(Image__c obj){
        Image_schema.Image image = new Image_schema.Image();

        image.id = obj.id__c;
        image.albumId = obj.albumId__c;
        image.title = obj.title__c;
        image.url = obj.url__c;
        image.thumbnailUrl = obj.thumbnailUrl__c;
        image.isSelected = obj.isSelected__c;

        return image;
    }
}