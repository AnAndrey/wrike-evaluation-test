import "package:angular2/core.dart";
import 'filter_composite.dart';

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
''',
  providers: const [FilterComposite],
)
class FilterDemoComponent{

  List filterableData;
  FilterComposite filterComposite;

  FilterDemoComponent(this.filterComposite){
  }

  @Input() set sourceData(List data) {
    if(data!=null) {
      filterableData = data;
      filterComposite.init(filterableData);
    }
  }

  void toggleCheckBox(String filterValue, String filterCategory, bool isChecked)
  {
    //print('toggleCheckBox ' + filterValue + ' ' + filterCategory + ' ' + isChecked.toString());
    filterComposite.setFilterState(filterValue, filterCategory, isChecked);

    if(isChecked == true) {
      hideRows(filterValue, filterCategory);
    }
    else    {
      showRows();
    }

    filterComposite.refreshFilter(filterableData);
  }

  void hideRows(String filterValue, String filterCategory){
    filterableData.where((r) {return r.getFieldValue(filterCategory) == filterValue;})
        .forEach((c) {c.isShown = false;});
  }

  void showRows()
  {
    // Get all rows with specific filterValue
    var allHiddenRows = filterableData.where((r) {return r.isShown ;});
    allHiddenRows.forEach((r) {filterComposite.maybeShouldEnable(r);});
  }
}