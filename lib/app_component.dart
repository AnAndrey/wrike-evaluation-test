// Copyright (c) 2017, admin. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/angular2.dart';
import 'package:angular2/common.dart';
import 'package:angular2/platform/browser.dart';

import 'package:angular2_components/angular2_components.dart';
import 'name_service.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  //template: '<demo-table></demo-table>',
  directives: const [materialDirectives, DemoTable, CORE_DIRECTIVES ],
  providers: const [NameService],
)
class AppComponent implements OnInit {
  final NameService nameService;
  List names;
  List heroes = ['qwe', 'dsfs', 'fdgdsg'];

  AppComponent(this.nameService);

  ngOnInit() async {
    try {
      await nameService.readyThePirates();
      names = nameService.names;
      //on success
    } catch (arrr) {
      print('Error initializing pirate names: $arrr');
    }
  }
}


@Component(
    selector: 'demo-table',
    templateUrl: 'demo_table.html'
)
class DemoTable  {

  var data;
  var filterQuery = "";
  var rowsOnPage = 10;
  var sortBy = "email";
  var sortOrder = "asc";
}