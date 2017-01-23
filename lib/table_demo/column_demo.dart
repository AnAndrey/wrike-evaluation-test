part of table_directives;

@Directive(selector: 'column-demo')
class ColumnDemo implements OnInit {

  @Input() String sort;

  @Input() String fieldName;

  @Input() String header;

  ColumnDemo(this._tableComponent);

  TableDemo _tableComponent;

  @override
  ngOnInit() {
    _tableComponent.columns.add(this);
  }
}