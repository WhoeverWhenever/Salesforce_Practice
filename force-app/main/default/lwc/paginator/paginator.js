import { LightningElement, track, api, wire } from 'lwc';
import { MessageContext, subscribe, publish } from 'lightning/messageService';
import PaginationChannel from '@salesforce/messageChannel/paginationChannel__c';

export default class Paginator extends LightningElement {

    @track page = 1;
    totalRecords = 0;
    numberOfPages = 0;
    @api perpage = 5;
    @track pages = [];
    set_size = 5;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.handleSubscribe();
    }
 
    handleSubscribe() {
        if (this.subscription) {
            return;
        }
        this.subscription = subscribe(this.messageContext, PaginationChannel, (message) => {
            this.handlePaginationMessage(message);           
        });
    }

    handlePaginationMessage(message){
        switch (message.action) {
            case 'sendNumberOfRecords':
                this.totalRecords = message.actionData.totalRecords;
                this.setPages();
                this.sendRecordsPerPage();
                break;
            case 'sendFilterSelected':
                this.page = 1;
                this.sendCurrentPage();
                break;
        }
    }

    sendRecordsPerPage(){
        const message = {
            action: "sendRecordsPerPage",
            actionData: {recordsPerPage: this.perpage}
        }
        publish(this.messageContext, PaginationChannel, message);
    }

    sendCurrentPage(){
        const message = {
            action: "sendCurrentPage",
            actionData: {currentPage: this.page}
        }
        publish(this.messageContext, PaginationChannel, message);
    }
    
    renderedCallback(){
        this.renderButtons();
    }

    renderButtons = ()=>{
        this.template.querySelectorAll('button').forEach((but)=>{
            but.style.backgroundColor = this.page===parseInt(but.dataset.id,10)?'yellow':'white';
         });
    }
    
    get pagesList(){
        let mid = Math.floor(this.set_size/2) + 1 ;
        if(this.page > mid){
            return this.pages.slice(this.page-mid, this.page+mid-1);
        } 

        return this.pages.slice(0,this.set_size);
     }

    setPages = ()=>{
        this.numberOfPages = Math.ceil(this.totalRecords/this.perpage);
        this.pages = [];
        for (let index = 1; index <= this.numberOfPages; index++) {
            this.pages.push(index);
        }
     }  
    
    get hasPrev(){
        return this.page > 1;
    }
    
    get hasNext(){
        return this.page < this.pages.length
    }

    onNext = ()=>{
        ++this.page;
        this.sendCurrentPage();
    }

    onPrev = ()=>{
        --this.page;
        this.sendCurrentPage();
    }

    onPageClick = (e)=>{
        this.page = parseInt(e.target.dataset.id,10);
        this.sendCurrentPage();
    }
}