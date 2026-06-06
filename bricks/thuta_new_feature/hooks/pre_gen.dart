import 'package:mason/mason.dart';

Future run(HookContext context) async {
  final stateManagement =
      context.vars['state_management'].toString().toLowerCase();
  final isBloc = stateManagement == 'bloc';
  final isCubit = stateManagement == 'cubit';

  context.vars = {
    ...context.vars,
    'isBloc': isBloc,
    'isCubit': isCubit,
  };
}
