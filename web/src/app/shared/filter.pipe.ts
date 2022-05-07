import { EventListenerFocusTrapInertStrategy } from '@angular/cdk/a11y';
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
    name: 'filter'
})
export class FilterPipe implements PipeTransform{
    transform(value: any[], filterString: string, propName: string): any[]{
        const result:any=[];
        if(!value || filterString==='' || propName===''){
            return value;
        }
        value.forEach((a:any)=>{
            if(a.name.trim().toLowerCase().includes(filterString.toLowerCase())){
                result.push(a);
            }
            else if(a.category.trim().toLowerCase().includes(filterString.toLowerCase())){
                result.push(a);
            }
            else if(a.description.trim().toLowerCase().includes(filterString.toLowerCase())){
                result.push(a);
            }
            else if(a.model.trim().toLowerCase().includes(filterString.toLowerCase())){
                result.push(a);
            };

        });
        return result;
    }
}