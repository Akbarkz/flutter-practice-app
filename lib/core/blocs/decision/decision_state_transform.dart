
import 'package:recharge_app/core/bloc_helpers/bloc_state_transform_base.dart';
import 'package:recharge_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:recharge_app/core/blocs/authentication/authentication_state.dart';
import 'package:recharge_app/core/pages/authentication_page.dart';
import 'package:recharge_app/core/pages/home_page.dart';

import 'decision_state_action.dart';

///
/// Business Logic related to the DecisionPage
/// 
/// based on the AuthenticationState
///
class DecisionStateTransform
    extends BlocStateTransformBase<DecisionStateAction, AuthenticationState> {
  DecisionStateTransform({
    DecisionStateAction initialAction,
    AuthenticationBloc blocIn,
  })  : assert(blocIn != null),
        super(initialState: initialAction, blocIn: blocIn);

  //
  // Take initial action, based on the authentication status
  //
  factory DecisionStateTransform.init(AuthenticationBloc blocIn) {
    AuthenticationState authenticationState = blocIn.lastState;
    DecisionStateAction action = authenticationState == null || !authenticationState.isAuthenticated
        ? DecisionStateAction.routeToPage(AuthenticationPage())
        : DecisionStateAction.routeToPage(HomePage());

    return DecisionStateTransform(
      initialAction: action,
      blocIn: blocIn,
    );
  }

  ///
  /// Business Logic
  ///
  @override
  Stream<DecisionStateAction> stateHandler(
      {DecisionStateAction currentState, AuthenticationState newState}) async* {
    DecisionStateAction action = DecisionStateAction.doNothing();

    if (newState.isAuthenticated) {
      action = DecisionStateAction.routeToPage(HomePage());
    } else if (newState.isAuthenticating || newState.hasFailed) {
      // do nothing
    } else {
      action = DecisionStateAction.routeToPage(AuthenticationPage());
    }

    yield action;
  }
}
