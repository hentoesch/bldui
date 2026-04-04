import 'package:flutter/material.dart';
//import 'package:uilib/common/globals.dart' as sysglob;
import 'package:uilib/common/setenv.dart';
import 'package:bldui/common/routes.dart' as rt;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uilib/bloc/bloc.dart';

// GoRouter configuration
final _router = rt.getRoutes();

void main() {
  setEnv(mnd: 'jsa', app: 'bldui');
  runApp(MultiBlocProvider(providers: [
    /// ????
    BlocProvider<AppBloc>(
      //create: (context) => AppBloc()..add(AppEventInit(mnd: 'dir', app: 'cdm')),
      create: (context) =>
          AppBloc()..add(AppEventInit(mnd: 'jsa', app: 'bldui')),
    ),
    //BlocProvider<DataBloc>(create: (context) => DataBloc()),
    BlocProvider<MenuBloc>(create: (context) => MenuBloc()..add(LoadMenu())),
  ], child: const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  //static const String kMessage = '"Talk less. Smile more." - A. Burr';

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
