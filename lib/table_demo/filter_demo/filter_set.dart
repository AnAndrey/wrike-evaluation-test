import "dart:collection";
import 'filter_item.dart';

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