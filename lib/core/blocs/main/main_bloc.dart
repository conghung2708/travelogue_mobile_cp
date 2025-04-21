import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  int currentScreen = 0;

  MainBloc() : super(MainInitial()) {
    on<MainEvent>((event, emit) async {
      if (event is OnChangeIndexEvent) {
        if (event.indexChange == 3) {
          if (UserLocal().getAccessToken.isEmpty) {
            Navigator.of(event.context).pushNamed(LoginScreen.routeName);
            return;
          }
        }
        currentScreen = event.indexChange;
        emit(_getMainDone);
      }
    });
  }

  // Function private
  MainDone get _getMainDone => MainDone(currentScreen: currentScreen);
}
