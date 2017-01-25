part of table_directives;

@Component(
    selector: 'table-demo',
    template: '''
<div *ngIf="ff != null && ff.filters != null">
  <div *ngFor="let filterItem of ff.filters" style="display: inline;">
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

<table class="table table-striped table-bordered dataTable"
       role="grid" style="width: 100%;">
  <thead>
  <tr role="row">
    <th *ngFor="let column of columns" (click)="toggleSort(column, \$event)">
      <a href="#">{{column.header}}</a>
      <i *ngIf="column.sort != null" class="pull-right fa"
        [ngClass]="{\'fa-chevron-down\': column.sort == \'DES\', \'fa-chevron-up\': column.sort == \'ASC\'}"></i>
    </th>
  </tr>
  </thead>
  <tbody>
  <tr *ngFor="let item of rowsAux" id="{{item.id}}" [hidden]="item.isHidden">
      <td>{{item.name}}</td>
      <td class="text-right">{{item.age}}</td>
      <td >{{item.gender}}</td>
      <td >{{item.department}}</td>
      <td >{{item.address.city}}, {{item.address.street}}</td>
  </tr>
  </tbody>
</table>
''')
class TableDemo {
  List _rows;

  bool isHidden(dynamic item){
    return item.isHidden;
  }
  @Input() set rows(List rows) {
    if(rows != null) {

      _rows = rows;
      rowsAux = rows.toList();
      ff = new FilterComposite(filterColumns,rowsAux);
    }
  }
  List rowsAux;
  FilterComposite ff;
  @Output() EventEmitter tableChanged = new EventEmitter();

  List<ColumnDemo> columns = [];
  List filterColumns = ['gender', 'department', 'address.city'];
  FilterSet testFilter;

  List<FilterSet> getFilters(){
    return ff == null? new List<FilterSet>() : ff.filters;
  }
  TableDemo(){

  }

  void toggleCheckBox(String filterValue, String filterCategory, bool isChecked)
  {
    print('toggleCheckBox ' + filterValue + ' ' + filterCategory + ' ' + isChecked.toString());

    ff.filters.where((f){
      return f.name == filterCategory;
    }).first.data[filterValue].checked = isChecked;

    rowsAux = _rows.toList();


    rowsAux.where((r) {return r.getFieldValue( filterCategory) == filterValue;})
           .forEach((c){ c.isHidden = !isChecked; });

    // Filter with hidden categories
    var r = rowsAux.where((c) { return !c.isHidden; }).toList();
    var rebuiltFilter = new FilterComposite(filterColumns,r );
    for(int t=0; t<ff.filters.length; t++ )
    {
      ff.filters[t].data.keys.forEach((k){
        if(ff.filters[t].data[k].checked){
          rebuiltFilter.filters[t].data[k] = ff.filters[t].data[k];
        }
      });

    }
    ff = rebuiltFilter;
  }

  void toggleSort(ColumnDemo column, MouseEvent event) {
    event.preventDefault();


    switch (column.sort) {
      case 'ASC':
        column.sort = 'DES';
        break;
      case 'DES':
        column.sort = 'ASC';
        break;
      default:
        column.sort = 'ASC';
        break;
    }
    if (column.sort != 'NONE') {
      rowsAux.sort((r1, r2) {
        var comparison = r1.getFieldValue(column.fieldName).compareTo(
            r2.getFieldValue(column.fieldName));
        return column.sort == 'ASC' ? comparison : -comparison;
      });
    } else {
      rowsAux = _rows.toList();
    }

    columns.forEach((c) {
      if (c.fieldName != column.fieldName && c.sort != 'NO_SORTABLE')
        c.sort = 'NONE';
    });
  }

  bool isExclude(){
    return false;
  }
}
class FilterItem
{
  bool checked = false;
  int count =1;
}
class FilterSet{
  String name;
  SplayTreeMap<String, FilterItem> data;

  FilterSet(this.name){
    this.data = new SplayTreeMap<String, FilterItem>();
  }

  void AddFilterKey(String s) {
    if(data.containsKey(s)){
      data[s].count++;
    }
    else{
      data[s] = new FilterItem();
    }
  }
}

class FilterComposite{

  List<FilterSet> filters = new List<FilterSet>();

  FilterComposite(List<String> names, List filterableData){

    names.forEach((n) {
      var filter = new FilterSet(n);
      filterableData.forEach((d){
        filter.AddFilterKey(d.getFieldValue(n));
      });
      filters.add(filter);
    });
  }
}