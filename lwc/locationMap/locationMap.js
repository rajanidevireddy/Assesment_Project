import { LightningElement } from 'lwc';
export default class LocationMap extends LightningElement {
		mapMarkers = [];
		get showMap() {
				return this.mapMarkers.length > 0;
		}
}