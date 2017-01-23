part of table_directives;

@Component(
    selector: 'table-demo',
    template: '''
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
  <tr *ngFor="let item of rowsAux">
      <td>{{item['name']}}</td>
      <td class="text-right">{{item['age']}}</td>
      <td >{{item['gender']}}</td>
      <td >{{item['department']}}</td>
      <td >{{item['address']['city']}}, {{item['address']['street']}}</td>
  </tr>
  </tbody>
</table>
''')
class TableDemo {
  List _rows;

  @Input() set rows(List rows) {
    if(rows != null) {
      _rows = rows;
      rowsAux = rows.toList();
    }
  }
  List rowsAux;

  @Output() EventEmitter tableChanged = new EventEmitter();

  List<ColumnDemo> columns = [];

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
        var comparison = getData(r1, column.fieldName).compareTo(
            getData(r2, column.fieldName));
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

  /// Gets the data from the value of the row with the specified field name.
  String getData(dynamic row, dynamic fieldsName, [String delimiter = ', ']) {
    var res = fieldsName.split('.')
                        .fold(row, (prev, String curr) =>
                            prev[curr])
                        .toString();
    return res;
  }
}