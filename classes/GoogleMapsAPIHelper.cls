/*Author : Rajani
* Createddae : 04/01/2023
* Description : Class to support Google Address search 

*/ 

public class GoogleMapsAPIHelper {
    public static final String BASE_URL = System.Label.GoogleAPIEndPoint;
    public static final String API_KEY = System.Label.GoogleAPIKey;
    public static final String vHash = 'UmFqYW5p';
    
    // https://developers.google.com/maps/documentation/distance-matrix/distance-matrix
    // As per the above link Google is only supporting four modes i.e Driving,Walking,Cycling,Transit
    @AuraEnabled(Cacheable = true)
    public static  GoogleMapWrapper.DirectionsWrapper getDirectionsFromTwoLocations(String originAddress,String destinationAddress) {
        GoogleMapWrapper.DirectionsWrapper directionsDetails = new GoogleMapWrapper.DirectionsWrapper();
        try  {
            String URL = BASE_URL+'directions/json?origin='+EncodingUtil.urlEncode(originAddress, 'UTF-8');
            URL+='&destination='+EncodingUtil.urlEncode(destinationAddress,'UTF-8')+'&mode=transit|Driving&'+getAPIKey();
            HttpResponse response = getResponse(url);
            if(response.getStatusCode() != 200) {
                 throw new CustomException('Callout Failed:'+response.getStatus());
            }
            GoggleMapsDirectionsWrapper wrapper = (GoggleMapsDirectionsWrapper)JSON.deserialize(response.getBody(), GoggleMapsDirectionsWrapper.class);
            directionsDetails.start_address = wrapper?.routes[0]?.legs[0]?.start_address;
            directionsDetails.end_address = wrapper?.routes[0]?.legs[0]?.end_address;
            directionsDetails.distance = wrapper?.routes[0]?.legs[0]?.distance?.value;
            Integer distanceInMeters = directionsDetails?.distance;
            Integer distanceInKMS = distanceInMeters != null && distanceInMeters != 0? distanceInMeters/1000:0;
            directionsDetails.distance = distanceInKMS;
            directionsDetails.duration = wrapper?.routes[0]?.legs[0]?.duration?.text;
            directionsDetails.travelMode = wrapper?.routes[0]?.legs[0]?.steps[0]?.travel_mode;
            directionsDetails.calculatedRate = 0.0;
            if(Mode_Of_Transport__mdt.getInstance(directionsDetails.travelMode) != null) {
                directionsDetails.calculatedRate = Mode_Of_Transport__mdt.getInstance(directionsDetails.travelMode)?.Rate__c * distanceInKMS;
            }
            
        }catch(Exception objException) {
            throw new CustomException(objException.getMessage());
        }
        
        return directionsDetails;
    }
        /*Author : Rajani
        * Createddae : 04/01/2023
        * Description : Method to search Address based on search Term
        * @input params : searchKey
        * @response String
        */ 
    
    @AuraEnabled(Cacheable = true)
    public static List<GoogleMapWrapper.SuggestionWrapper> getAddressDetailsBasedOnSourceAndDestination(String searchKey) {
        List<GoogleMapWrapper.SuggestionWrapper> suggestions = new List<GoogleMapWrapper.SuggestionWrapper>();
        
        if(String.isEmpty(searchKey)) {
            return suggestions; 
        }
        
        try {
            String url = BASE_URL+'place/autocomplete/json?'
                + 'input=' + EncodingUtil.urlEncode(searchKey, 'UTF-8')+ getAPIKey();
            
            HttpResponse response = getResponse(url);
            if(response.getStatusCode() != 200) {
                 throw new CustomException('Callout Failed:'+response.getStatus());
            }
            GoggleMapsSuggestionWrapper wrapper = (GoggleMapsSuggestionWrapper)JSON.deserialize(response.getBody(), GoggleMapsSuggestionWrapper.class);
            for(GoggleMapsSuggestionWrapper.Predictions eachPrediction : wrapper.Predictions){
                if(string.isNotBlank(eachPrediction.description)){
                    suggestions.add(new GoogleMapWrapper.SuggestionWrapper(eachPrediction.description.replaceAll(',', ' '),eachPrediction.place_id));
                }
            }
        }catch(Exception objException) {
            throw new CustomException(objException.getMessage());
        }
        
        return suggestions;
    }
    
    /*Author : Rajani
* Createddae : 04/01/2023
* Description : Method to get current location address
* @input params : latitude and longitude
* @response String
*/ 
    @AuraEnabled(Cacheable = true)
    public static String getUserCurrentLocationBasedOnCoordinates(String latitude,String longitude) {
        if(latitude == null || longitude == null) {
            return '';
        }
        String returnresponse = '';
        String GEOCODING_URL = BASE_URL+'geocode/json?latlng='+latitude+','+longitude+getAPIKey();
        try {
            HttpResponse response =  getResponse(GEOCODING_URL);
            if(response.getStatusCode() != 200) {
                 throw new CustomException('Callout Failed:'+response.getStatus());
            }
            GoogleMapWrapper wrapper = (GoogleMapWrapper)JSON.deserialize(response.getBody(), GoogleMapWrapper.class);
            //considering first recommondation from the list
            for(GoogleMapWrapper.Results rs: wrapper.results) {
                returnresponse = rs.formatted_address;
                break;
            } 
        }catch(Exception objException) {
            throw new CustomException(objException.getMessage());
        }
        return returnresponse;
    }
    
    // Method to perform HTTP Callout
    // Input Params: strURL
    // Return type HTTPResponse
    private static HttpResponse getResponse(string strURL) {
        Http httpRequest = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint(strURL);
        req.setTimeout(120000);
        return httpRequest.send(req);
    }
    
    //This will return the API Key
    private static string getAPIKey(){
        String apiKey = '&key=' + API_KEY;
        return apiKey;
    }
    
}