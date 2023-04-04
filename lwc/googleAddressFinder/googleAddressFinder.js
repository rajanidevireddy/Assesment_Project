import { LightningElement,wire } from 'lwc';
import getUserCurrentLocationBasedOnBrowerLocation from '@salesforce/apex/GoogleMapsAPIHelper.getUserCurrentLocationBasedOnCoordinates';
import getAddressDetailsBasedOnSourceAndDestination from '@salesforce/apex/GoogleMapsAPIHelper.getAddressDetailsBasedOnSourceAndDestination';
import getDirectionsFromTwoLocations from '@salesforce/apex/GoogleMapsAPIHelper.getDirectionsFromTwoLocations';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const ERROR_VARIANT = 'error';

export default class GoogleAddressFinder extends LightningElement {
		isRendered;
		latitude;
		longitude;
		isLoading;
		selectedSourcePlaceId;
		selectedDestinationPlaceId;
		selectedSourceName;
		selectedLDestinationName;
		doneTypingInterval = 1000;
		typingTimer;
		evtSource;
		addressRecommendations = [];
		addressDirections={};
		hasAddressDirections = false;

		connectedCallback() {
				this.isLoading = true;
				if (!this.isRendered) {
						this.getLocationFromBrowser();
				}
				this.isRendered = true;
		}

		//gets current user location when latitude or longitude changes
		@wire(getUserCurrentLocationBasedOnBrowerLocation, {latitude: '$latitude', longitude: '$longitude'})
		wiredLocationJSON({error, data}) {
				if (data) {
						console.log(data);
						this.selectedSourceName = data;
				} else if (error) {
						console.log(error);
					this.showToast(error,ERROR_VARIANT);
				}
				this.isLoading = false;
		}

		// Gets the current location from the Browser and sets the origin on page load
		getLocationFromBrowser() {
				if (navigator.geolocation) {
						navigator.geolocation.getCurrentPosition(position => {
								this.latitude = position.coords.latitude;
								this.longitude = position.coords.longitude;
						});
				}
		}

		setSourceAddress(event) {
				this.searchAddressSuggestions('fromaddress',event.target.value);
		}

		setDestinationAddress(event) {
				this.searchAddressSuggestions('toaddress',event.target.value);

		}
		
	//Common method to search the addresses based on the key
	// This will have a capability of Debouncing.it will call server after a second if no input from user until 1 sec.
		searchAddressSuggestions(source,searchTerm) {
				//Using Debouncing logic to call server after 1 seconds
				try{
						clearTimeout(this.typingTimer);
						this.typingTimer = setTimeout(() => {
								if(searchTerm){
										getAddressDetailsBasedOnSourceAndDestination({ searchKey: searchTerm }).then((response) => {
												let addressRecommendations = [];
												response.forEach(prediction => {
														addressRecommendations.push({
																addressName: prediction.AddComplete,
																place_id: prediction.placeId,
														});
												});
												this.addressRecommendations = addressRecommendations;
												this.evtSource = source;
										})
								}
						}, this.doneTypingInterval);
				}catch(error) {
						this.showToast(error,ERROR_VARIANT);
				}
		}
		
		//This method will fire when event from child drivingDetails.js is fired
		//sets selected source and destination details.
		handleAddressRecommendationSelection(event) {
				if(event.detail.eventSource =='fromaddress') {
						this.selectedSourcePlaceId = event.detail.placeId;
						this.selectedSourceName = event.detail.Name;
				}else {
						this.selectedDestinationPlaceId = event.detail.placeId;
						this.selectedLDestinationName= event.detail.Name;
				}
				this.addressRecommendations = [];
		}
	
		//getter method to display search results
		get hasRecommendations() {
				return (this.addressRecommendations !== null && this.addressRecommendations.length);
		}
		
		/*
		 * This method will fetches the Directions based on source and destinations
		 * source and destination should be selecteed
		 * Source and destinationi should not be same
		 */
		getDirections(event) {
				this.isLoading = true;
				if(this.selectedLDestinationName && this.selectedSourceName) {
						getDirectionsFromTwoLocations({ originAddress:this.selectedSourceName,
																					 destinationAddress:this.selectedLDestinationName}
																				 ).then((response) => {
								this.addressDirections = response;
								this.hasAddressDirections = true;
						}).catch((error) => {
								console.log(error);
								this.showToast(error,ERROR_VARIANT);
						});
				} else {
						this.showToast("Orgin and Destination should be selected and it should not be same!!",ERROR_VARIANT);
				}
				this.isLoading = false;
		}
		// generic method to fire tost events
		showToast(title,variant){
				const toast = new ShowToastEvent({
						title:title ,
						variant: variant,
				});
				this.dispatchEvent(toast);	
		}
}