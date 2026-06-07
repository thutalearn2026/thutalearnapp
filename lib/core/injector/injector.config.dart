// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/onboarding/data/data_sources/remote/i_onboarding_client.dart'
    as _i865;
import '../../features/onboarding/data/repo/i_onboarding_repo.dart' as _i827;
import '../../features/onboarding/domain/domain.dart' as _i634;
import '../../features/onboarding/domain/usecases/onboarding_usecase.dart'
    as _i706;
import '../../features/onboarding/onboarding.dart' as _i478;
import '../../features/onboarding/presentation/blocs/onboarding/onboarding_bloc.dart'
    as _i1023;
import '../api/config.dart' as _i474;
import '../api/dio_provider.dart' as _i92;
import '../core.dart' as _i351;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final dioProvider = _$DioProvider();
  gh.factory<_i1023.OnboardingBloc>(() => _i1023.OnboardingBloc());
  gh.factory<_i474.IConfig>(() => _i474.AppConfig());
  gh.singleton<_i361.Dio>(() => dioProvider.dio(gh<_i351.IConfig>()));
  gh.factory<_i478.OnboardingClient>(
    () => _i865.IOnboardingClient(
      dio: gh<_i361.Dio>(),
      config: gh<_i351.IConfig>(),
    ),
  );
  gh.factory<_i634.OnboardingRepo>(
    () => _i827.IOnboardingRepo(client: gh<_i634.OnboardingClient>()),
  );
  gh.factory<_i706.OnboardingUseCase>(
    () => _i706.OnboardingUseCase(onboardingRepo: gh<_i634.OnboardingRepo>()),
  );
  return getIt;
}

class _$DioProvider extends _i92.DioProvider {}
