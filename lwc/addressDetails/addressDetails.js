import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class AddressDetails extends LightningElement {
		@api
		addressRecommendations
		@api
		evtSource;

		handleAddressRecommendationSelect(event) {
				try{
						const addressSelectEvent = new CustomEvent('addressselect', {
								detail: {
										placeId: event.currentTarget.dataset.value,
										Name:event.currentTarget.dataset.name,
										eventSource:this.evtSource
								}
						});
						this.dispatchEvent(addressSelectEvent);
				}catch(error) {
						const toast = new ShowToastEvent({
								title:error ,
								variant: "error",
						});
						this.dispatchEvent(toast);	
				}
		}
}