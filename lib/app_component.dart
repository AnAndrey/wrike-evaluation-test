// Copyright (c) 2017, admin. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/angular2.dart';

import 'contact_service/contact_lib.dart';
import 'table_demo/table_directives.dart';


@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  directives: const [TABLE_DIRECTIVES],
  providers: const [ContactService],
)
class AppComponent implements OnInit {
  final ContactService contactService;
  List contacts;

  AppComponent (this.contactService);

  ngOnInit() async {
    try {
      await contactService.getContacts();
      contacts = contactService.contacts;

    } catch (arrr) {
      print('Error initializing contacts: $arrr');
    }
  }
}

