// Copyright (c) 2017, admin. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/angular2.dart';
import 'package:angular2/common.dart';

import 'package:angular2_components/angular2_components.dart';
import 'contact_service.dart';
import 'table_demo/table_directives.dart';


@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  directives: const [materialDirectives, CORE_DIRECTIVES , TABLE_DIRECTIVES],
  providers: const [ContactService],
)
class AppComponent implements OnInit {
  final ContactService contactService;
  List contacts;

  AppComponent (this.contactService)
  {
    //getNames();
  }

  ngOnInit() async {
    try {
      await contactService.getContacts();
      contacts = contactService.contacts;

    } catch (arrr) {
      print('Error initializing names: $arrr');
    }
  }
}

