import { LightningElement, api, wire, track } from 'lwc';

import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { registerListener, unregisterAllListeners, fireEvent } from 'c/pubsub';
import { reduceErrors } from 'c/ldsUtils';

import { getRecord } from 'lightning/uiRecordApi';
import getContactById from '@salesforce/apex/ContactController.getContactById';

const fields = [
    'Contact.Id',
    'Contact.Name',
    'Contact.Title',
    'Contact.Phone',
    'Contact.Email'
];

const EVENT_NAME = 'recordUpdated';

export default class WireGetRecordDynamicContact extends LightningElement {
    @api recordId;

    @wire(CurrentPageReference) pageRef;
    @track contact;

    @wire(getContactById, { recordId: '$recordId', fields })
    wireRecord(data) {
        if (data) {
            this.contact = data;
            fireEvent(
                this.pageRef,
                'contactSelected',
                this.recordId
            );
        }
    }

    get name() {
        return this.contact.data.fields.Name.value;
    }

    get title() {
        return this.contact.data.fields.Title.value;
    }

    get phone() {
        return this.contact.data.fields.Phone.value;
    }

    get email() {
        return this.contact.data.fields.Email.value;
    }

    connectedCallback() {
        registerListener(EVENT_NAME, this.handleContactSelected, this);
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    handleContactSelected(contactId) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'wireGetRecordDynamicContact',
                message: EVENT_NAME + ': ' + contactId,
                variant: 'info'
            })
        );
    }
}
