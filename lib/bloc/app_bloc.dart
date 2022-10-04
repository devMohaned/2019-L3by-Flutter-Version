import 'login_bloc.dart';
import 'reg_bloc.dart';

class AppBloc {
  LoginBloc _loginBloc;
  RegisterationBloc _registerationBloc;


  AppBloc()
      :_loginBloc = LoginBloc(),
        _registerationBloc = RegisterationBloc();

  LoginBloc get loginBloc => _loginBloc;
  RegisterationBloc get registerBloc => _registerationBloc;
}