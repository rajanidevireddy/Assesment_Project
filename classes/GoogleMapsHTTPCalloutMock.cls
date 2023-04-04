@isTest
public class GoogleMapsHTTPCalloutMock implements HttpCalloutMock {
    public Boolean isError;
    public String apiType;
    public GoogleMapsHTTPCalloutMock(Boolean isError,String apiType) {
        this.isError =isError;
        this.apiType = apiType;
        
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        if(apiType == 'CurrentLocation') {
            GoogleMapWrapper objWrapper = new GoogleMapWrapper();
            GoogleMapWrapper.Results objResults= new GoogleMapWrapper.Results();
            objResults.formatted_address = '1098 Las Angels';
            objWrapper.results = new List<GoogleMapWrapper.Results>{objResults};
            objWrapper.status = '200';
            res.setBody(JSON.serialize(objWrapper));
            res.setStatusCode(isError ? 400 : 200);
        }else if (apiType == 'LocationsDirection') {
            GoggleMapsDirectionsWrapper objWrapper = new GoggleMapsDirectionsWrapper();
            
            //Create Distance
            GoggleMapsDirectionsWrapper.Distance distance = new GoggleMapsDirectionsWrapper.Distance();
            distance.text = '9.6 kms';
            distance.value = 9687;
            //create steps
            GoggleMapsDirectionsWrapper.Steps steps = new  GoggleMapsDirectionsWrapper.Steps();
            steps.distance = distance;
            steps.duration = distance;
            steps.travel_mode = 'DRIVING';
            
            //create Legs
            GoggleMapsDirectionsWrapper.Legs legs = new GoggleMapsDirectionsWrapper.Legs();
            legs.distance = distance;
            legs.duration = distance;
            legs.end_address = 'Las Angels';
            legs.start_address = 'Dallas';
            legs.steps = new List<GoggleMapsDirectionsWrapper.Steps>{steps};
             
            //create Routes
            GoggleMapsDirectionsWrapper.Routes routes = new GoggleMapsDirectionsWrapper.Routes();
            routes.legs = new List<GoggleMapsDirectionsWrapper.Legs>{legs};
                
            objWrapper.routes = new List<GoggleMapsDirectionsWrapper.Routes>{routes};
            objWrapper.status = isError ? '400' : '200';
            
            res.setBody(JSON.serialize(objWrapper));
            Integer resCode = isError ? 400 : 200;
            res.setStatusCode(isError ? 400 : 200);
        }else if(apiType == 'sourceDestinationAPI') {
            GoggleMapsSuggestionWrapper suggestions = new GoggleMapsSuggestionWrapper();
            //create predictions
            GoggleMapsSuggestionWrapper.Predictions predictions = new GoggleMapsSuggestionWrapper.Predictions();
            predictions.place_id = 'placeid';
            predictions.description = 'Las Angeles';
            suggestions.predictions = new List<GoggleMapsSuggestionWrapper.Predictions>{predictions};
            res.setBody(JSON.serialize(suggestions));
            res.setStatusCode(isError ? 400 : 200);
            System.debug(res.getStatusCode());
        }
        
        return res;
    }
}