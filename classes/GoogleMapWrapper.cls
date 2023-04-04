public class GoogleMapWrapper {
    public List<Results> results;
	public String status;
	public class Results {
		public String formatted_address;
		public String place_id;
	}
    public class DirectionsWrapper {
        @AuraEnabled
        public Integer distance;
        @AuraEnabled
        public String duration;
		@AuraEnabled
        public String end_address;
        @AuraEnabled
        public Double calculatedRate;
        @AuraEnabled
        public String start_address;
        @AuraEnabled
        public String travelMode;
    }
    
    public class SuggestionWrapper {
        @AuraEnabled
        public String AddComplete{get;set;}
        @AuraEnabled
        public String placeId{get;set;}
        
        public SuggestionWrapper(string AddComplete,String placeId){
            this.AddComplete = AddComplete;
            this.placeId = placeId;
        }
    }
}