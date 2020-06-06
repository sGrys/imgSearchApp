global class Image_schema {
    global class Image {
        @AuraEnabled global String albumId;
        @AuraEnabled global String id;
        @AuraEnabled global String title;
        @AuraEnabled global String url;
        @AuraEnabled global String thumbnailUrl;
        @AuraEnabled global Boolean isSelected;
    }
}
