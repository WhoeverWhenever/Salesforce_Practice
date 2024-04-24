import { LightningElement, track, api, wire } from 'lwc';
import { MessageContext, subscribe } from 'lightning/messageService';
import PaginationChannel from '@salesforce/messageChannel/paginationChannel__c';

export default class Paginator extends LightningElement {
    // tableData=[
    //     {Name: 'Data1'},{Name: 'Data2'},{Name: 'Data3'},{Name: 'Data4'},{Name: 'Data5'},{Name: 'Data6'},
    //     {Name: 'Data7'},{Name: 'Data8'},{Name: 'Data9'},{Name: 'Data10'},{Name: 'Data11'},{Name: 'Data12'},
    //     {Name: 'Data13'},{Name: 'Data14'},{Name: 'Data15'},{Name: 'Data16'}
    // ];
    @track page = 1;
    totalRecords = 0;
    numberOfPages = 0;
    @api perpage = 5;
    @track pages = [];
    set_size = 5;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        console.log("Connected callback");
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
        if (message.action != 'sendNumberOfRecords') {
            return;
        }
        this.totalRecords = message.actionData.totalRecords;
        console.log("Total records assigned " + this.totalRecords);
        this.setPages();
    }

    setFirstPage(){
        this.page = 1;
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
    
    pageData = ()=>{
        let page = this.page;
        let perpage = this.perpage;
        let startIndex = (page*perpage) - perpage;
        let endIndex = (page*perpage);

        return this.tableData.slice(startIndex,endIndex);
     }

    setPages = ()=>{
        console.log("Total records");
        console.log(this.totalRecords);
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
    }

    onPrev = ()=>{
        --this.page;
    }

    onPageClick = (e)=>{
        this.page = parseInt(e.target.dataset.id,10);
    }

    get currentPageData(){
        return this.pageData();
    }
}