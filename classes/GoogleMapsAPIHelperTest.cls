@isTest
private class GoogleMapsAPIHelperTest {
    @isTest
    static void getUserCurrentLocationBasedOnCoordinates_PositiveTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleMapsHTTPCalloutMock(false,'CurrentLocation'));
        String location = GoogleMapsAPIHelper.getUserCurrentLocationBasedOnCoordinates('90.5','90.7');
        Test.stopTest();
        Assert.areEqual('1098 Las Angels', location);
    }
    @isTest
    static void getUserCurrentLocationBasedOnCoordinates_WhenCoordinatesNullPositiveTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleMapsHTTPCalloutMock(false,'CurrentLocation'));
        String location = GoogleMapsAPIHelper.getUserCurrentLocationBasedOnCoordinates(null,null);
        Test.stopTest();
        Assert.areEqual('', location);
    }
    
    @isTest
    static void getUserCurrentLocationBasedOnCoordinates_WhenStatuscodeIs400_NegativeTest(){
        String errorMessage;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleMapsHTTPCalloutMock(true,'CurrentLocation'));
        try {
            GoogleMapsAPIHelper.getUserCurrentLocationBasedOnCoordinates('90.5','90.7');
        }catch(Exception objException) {
            errorMessage = objException.getMessage();
            Assert.isTrue(errorMessage.contains('Callout Failed'));
        }
        Test.stopTest();
        Assert.isNotNull(errorMessage);
    }
    
    @isTest
    static void getDirectionsFromTwoLocationsTest_Positive() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleMapsHTTPCalloutMock(false,'LocationsDirection'));
        GoogleMapWrapper.DirectionsWrapper  objWrapper = GoogleMapsAPIHelper.getDirectionsFromTwoLocations('Dallas','Las Angels');
        Test.stopTest();
        Assert.areEqual(objWrapper.start_address, 'Dallas');
        Assert.areEqual(objWrapper.end_address, 'Las Angels');
        Assert.areEqual(objWrapper.travelMode, 'DRIVING');
        Assert.areEqual(objWrapper.calculatedRate, 90.0);
    }
    
    @isTest
    static void getDirectionsFromTwoLocationsTest_WhenStatusis400_Negative() {
        String errorMessage;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleMapsHTTPCalloutMock(true,'LocationsDirection'));
        try {
            GoogleMapWrapper.DirectionsWrapper  objWrapper = GoogleMapsAPIHelper.getDirectionsFromTwoLocations('Dallas','Las Angels');
        }catch(Exception objException) {
            errorMessage = objException.getMessage();
            Assert.isTrue(errorMessage.contains('Callout Failed'));
        }
        Test.stopTest();
        Assert.isNotNull(errorMessage);
    }
    
    @isTest
    static void getAddressDetailsBasedOnSourceAndDestination_PositiveTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleMapsHTTPCalloutMock(false,'sourceDestinationAPI'));
        List<GoogleMapWrapper.SuggestionWrapper>  objWrapper = GoogleMapsAPIHelper.getAddressDetailsBasedOnSourceAndDestination('Dallas');
        Test.stopTest();
        Assert.isNotNull(objWrapper);
    }
    
    @isTest
    static void getAddressDetailsBasedOnSourceAndDestination_WhenSearchStringisBlankPositiveTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleMapsHTTPCalloutMock(false,'sourceDestinationAPI'));
        List<GoogleMapWrapper.SuggestionWrapper>  objWrapper = GoogleMapsAPIHelper.getAddressDetailsBasedOnSourceAndDestination('');
        Test.stopTest();
        Assert.isNotNull(objWrapper);
    }
    
    @isTest
    static void getAddressDetailsBasedOnSourceAndDestination_WhenExceptionNegative() {
        String errorMessage;
        Test.startTest();
        try {
            Test.setMock(HttpCalloutMock.class, new GoogleMapsHTTPCalloutMock(true,'sourceDestinationAPI'));
            
            List<GoogleMapWrapper.SuggestionWrapper>  objWrapper = GoogleMapsAPIHelper.getAddressDetailsBasedOnSourceAndDestination('Dallas');
        }catch(Exception objException) {
            errorMessage = objException.getMessage();
            Assert.isTrue(errorMessage.contains('Callout Failed')); 
            
        }
        Test.stopTest();
        Assert.isNotNull(errorMessage);
    }
}