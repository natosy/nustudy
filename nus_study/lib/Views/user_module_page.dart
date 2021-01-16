import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Database/database_cache_interface.dart';
import 'package:nus_study/Rules/Account.dart';
import 'package:nus_study/Components/module_card.dart';
import 'package:nus_study/Views/module_study_session_page.dart';
import 'package:nus_study/components/header.dart';
import 'package:nus_study/Rules/Module.dart';

///Here user can view all the modules that the user has and can press on any of
///the modules to see the active study session available. Comes under the Tabs.
class UserModulePage extends StatefulWidget {
  final Account account = Cache.account;

  @override
  _UserModulePageState createState() => _UserModulePageState();
}

class _UserModulePageState extends State<UserModulePage>
    with AutomaticKeepAliveClientMixin<UserModulePage> {
  ///Basically keeps the tab alive so that the state is saved when navigating between tabs
  ///Required method for AutomaticKeepAliveClientMixin.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    List<Module> userModules = widget.account.modules;
    bool showSpinner = false;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          children: <Widget>[
            Header(title: 'My Modules'),
            //TODO: Use listviewbuilder to dynamically use users modules list, use cards for each module button
            Expanded(
              child: ListView.builder(
                itemCount: userModules.length,
                itemBuilder: (BuildContext cntxt, int index) {
                  return ModuleCard(
                    module: userModules[index],
                    function: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      print(userModules[index].toString());
                      Cache.moduleStudySessions = await DataInterface.getModuleActiveStudySessions(userModules[index]);
                      setState(() {
                        showSpinner = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModuleStudySessions(
                              module: userModules[index],
                            ),
                          )).then((value) => setState(() {}));
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
