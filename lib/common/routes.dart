import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uilib/wgt/menu/menu.dart';
import 'package:uilib/wgt/page/dialogpage.dart';
import 'package:uilib/wgt/form/form_handler.dart' as frm;
import 'package:uilib/wgt/page/page.dart' as pg;
import 'package:bldui/wgt/design_handler.dart' as dgn;
//import 'package:uilib/common/globals.dart';
import 'package:uilib/common/types.dart';
import 'package:dartlib/node.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

getRoutes() {
  return GoRouter(
    routes: [
      ///
      /// entry point
      ///
      GoRoute(
        path: '/',
        builder: (context, state) => PdMenu(),
      ),

      GoRoute(
        path: '/page/:page',
        builder: (context, state) {
          return Card(
            child: pg.PageHandler(
              page: state.pathParameters['page']!,
              key: Key("pg_${state.pathParameters['page']}"),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          );
        },
      ),
      GoRoute(
        path: '/form/:form/:id',
        name: 'formDialog',
        pageBuilder: (context, state) => DialogPage(
            barrierColor: Colors.black12,
            builder: (_) {
              return //Dialog(
                  Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  frm.FormHandler(
                    formName: state.pathParameters['form']!,
                    id: int.parse(state.pathParameters['id']!),
                    formMode: state.extra as FormMode,
                    //formBuilder: state.extra as fb.UiFormBuilder,
                  ),
                ],
              );
              //);
            },
            key: UniqueKey()),
      ),
      GoRoute(
        path: '/tree/:target',
        pageBuilder: (context, state) => DialogPage(
            barrierColor: Colors.black12,
            builder: (_) {
              return //Dialog(
                  Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  dgn.DesignHandler(
                      designTarget: state.pathParameters['target']!,
                      node: state.extra as TreeEntry<Node>),
                ],
              );
              //);
            },
            key: UniqueKey()),
      ),
    ],
  );
}
