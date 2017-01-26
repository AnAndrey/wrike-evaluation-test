import 'filter_set.dart';

class FilterComposite{

  List filterColumns = ['gender', 'department', 'address.city'];

  List<FilterSet> filters = new List<FilterSet>();

  FilterComposite( List filterableData){

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
}
