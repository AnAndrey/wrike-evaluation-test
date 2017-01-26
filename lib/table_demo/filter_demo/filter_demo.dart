import "package:angular2/core.dart";
import 'filter_composite.dart';
//import 'package:angular2/angular2.dart';

@Component(
    selector: 'filter-demo',
    template: '''
<div *ngIf="filterComposite != null && filterComposite.filters != null">
  <div *ngFor="let filterItem of filterComposite.filters" style="display: inline;">
    <div class="dropdown" >
        <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" >{{filterItem.name}}
            <span class="caret"></span></button>
        <ul class="dropdown-menu">
            <li *ngFor="let item of filterItem.data.keys">
              <a href="#"><input type="checkbox" (click)="toggleCheckBox(item, filterItem.name, \$event.target.checked)" [(ngModel)]="filterItem.data[item].checked">{{item}}({{filterItem.data[item].count}})</a>
            </li>
        </ul>
    </div>
  </div>
</div>
''')
class FilterDemo{

  List filterableData;
  FilterComposite filterComposite;

  @Input() set sourceData(List data) {
    if(data!=null) {
      filterableData = data;
      filterComposite = new FilterComposite( filterableData);
    }
  }

  void toggleCheckBox(String filterValue, String filterCategory, bool isChecked)
  {
    print('toggleCheckBox ' + filterValue + ' ' + filterCategory + ' ' + isChecked.toString());

    filterComposite.filters.where((f){
      return f.name == filterCategory;
    }).first.data[filterValue].checked = isChecked;

    if(isChecked == true) {
      filterableData.where((r) {return r.getFieldValue(filterCategory) == filterValue;})
          .forEach((c) {c.isShown = !isChecked;});
    }
    else
    {
      // Get all rows with specific filterValue
      var allHiddenRows = filterableData.where((r) {return r.isShown ;});
      allHiddenRows.forEach((r) {filterComposite.maybeShouldEnable(r);});
    }

    refreshFilter();
  }

  void refreshFilter(){
    // Filter with hidden categories
    var r = filterableData.where((c) { return !c.isShown; }).toList();
    var rebuiltFilter = new FilterComposite(r);

    for(int t=0; t<filterComposite.filters.length; t++ )
    {
      filterComposite.filters[t].data.keys.forEach((k){
        if(filterComposite.filters[t].data[k].checked){
          rebuiltFilter.filters[t].data[k] = filterComposite.filters[t].data[k];
        }
      });
    }
    filterComposite = rebuiltFilter;
  }

}