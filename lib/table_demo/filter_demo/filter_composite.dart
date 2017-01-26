import 'filter_set.dart';
import 'package:angular2/core.dart';

@Injectable()
class FilterComposite{
  static const List filterColumns = const['gender', 'department', 'address.city'];

  List<FilterSet> filters = new List<FilterSet>();

  void init( List filterableData){
    filterColumns.forEach((n) {
      var filter = new FilterSet(n);
      filterableData.forEach((d){
        filter.AddFilterKey(d.getFieldValue(n));
      });
      filters.add(filter);
    });
  }

  void maybeShouldEnable(dynamic r) {
    bool showRow = true;
    filters.forEach((f) {
      var value = r.getFieldValue(f.name);
      if(f.data[value] != null && f.data[value].checked) {
        showRow = false;
        return;
      }
    });
    r.isShown = showRow;
  }

  void setFilterState(String filterValue, String filterCategory, bool isChecked)
  {
    filters.where((f){
      return f.name == filterCategory;
    }).first.data[filterValue].checked = isChecked;
  }

  void refreshFilter(List filterableData){
    // Filter with hidden categories
    var hiddenRows = filterableData.where((c) { return !c.isShown; }).toList();
    FilterComposite rebuiltFilter = new FilterComposite();
    rebuiltFilter.init(hiddenRows);

    for(int t=0; t<filters.length; t++ )
    {
      filters[t].data.keys.forEach((k){
        if(filters[t].data[k].checked){
          rebuiltFilter.filters[t].data[k] = filters[t].data[k];
        }
      });
    }

    filters = rebuiltFilter.filters;
  }
}
