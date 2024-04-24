import { LightningElement, track, api } from 'lwc';

export default class Pagination extends LightningElement {
    
    tableData=[];
    @track page = 1;
    numberOfPages = 0;
    @api perpage = 5;
    @track pages = [];
    set_size = 5;

    @api
    setFirstPage(){
        this.page = 1;
    }
    
    renderedCallback(){
      this.renderButtons();
      this.handlePagination();   
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

     @api
     set currentPageData(data){
        if(data){
            this.tableData = data;
            this.setPages(this.tableData);
        }
     }
    
    pageData = ()=>{
        let page = this.page;
        let perpage = this.perpage;
        let startIndex = (page*perpage) - perpage;
        let endIndex = (page*perpage);

        return this.tableData.slice(startIndex,endIndex);
     }

    setPages = (data)=>{
        this.numberOfPages = Math.ceil(data.length / this.perpage);
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

    handlePagination(){
        this.dispatchEvent(new CustomEvent('paginate', { 
            detail:{ 
                records:this.currentPageData
            }
        }));
    }
}
