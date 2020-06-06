/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable no-console */
import { LightningElement, api } from 'lwc';
import getImagesFromDB from '@salesforce/apex/ConfiguratorLC.getImagesFromDB';
import searchEngine from '@salesforce/apex/ConfiguratorLC.searchEngine';
import sendEmail from '@salesforce/apex/ConfiguratorLC.sendEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const SEARCH_TIMEOUT = 400;

export default class ImageDisplayComponent extends LightningElement {
    
    @api images;
    isLoading = true;
    selectedIds = new Set();
    selected = [];
    connectedCallback() {
        this.init();
    }
    async init() {
        this.isLoading = true;
        try {
            this.images = await getImagesFromDB();
        } catch (exception) {
        const event = new ShowToastEvent({
            title: 'Error while loading products',
            message: exception.body.message,
            variant: 'error',
        });
        this.dispatchEvent(event);
        } finally {
            this.isLoading = false;
        }
    }
    async handleImageSelect(event) {
        const { detail } = event;
        const { id } = detail;

        // if(this.selectedIds.has(id)) {
        //     this.selectedIds.delete(id);
        // } else {
        //     this.selectedIds.add(id);
        // }

        // let result = this.selected.map(image => (
        //     {...image, selected : this.selectedIds.has(image.id)}
        // ));

        // this.selected = result;
        await sendEmail({id});
    }

    handleSearch({target}) {
        clearTimeout(this.searchTimeout);

        this.searchTimeout = setTimeout(async () => {
            const { value: searchText } = target;

            this.images = await searchEngine({
                searchText,
            });
        }, SEARCH_TIMEOUT);
    }
}