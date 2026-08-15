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

import '../../features/authentication/authentication.dart' as _i845;
import '../../features/authentication/data/data_sources/remote/i_authentication_client.dart'
    as _i402;
import '../../features/authentication/data/repo/i_authentication_repo.dart'
    as _i998;
import '../../features/authentication/domain/usecases/authentication_usecase.dart'
    as _i573;
import '../../features/authentication/presentation/blocs/account_setup/account_set_up_bloc.dart'
    as _i430;
import '../../features/authentication/presentation/blocs/forgot_password/forgot_password_bloc.dart'
    as _i965;
import '../../features/authentication/presentation/blocs/login/login_bloc.dart'
    as _i413;
import '../../features/authentication/presentation/blocs/register/register_bloc.dart'
    as _i236;
import '../../features/home/data/data_sources/remote/i_home_client.dart'
    as _i33;
import '../../features/home/data/repo/i_home_repo.dart' as _i1030;
import '../../features/home/domain/domain.dart' as _i487;
import '../../features/home/domain/usecases/home_usecase.dart' as _i207;
import '../../features/home/home.dart' as _i905;
import '../../features/learn/data/data_sources/remote/i_learn_client.dart'
    as _i664;
import '../../features/learn/data/repo/i_learn_repo.dart' as _i92;
import '../../features/learn/domain/usecases/learn_usecase.dart' as _i891;
import '../../features/learn/learn.dart' as _i592;
import '../../features/learn/presentation/blocs/course_detail/course_detail_bloc.dart'
    as _i678;
import '../../features/learn/presentation/blocs/courses/courses_bloc.dart'
    as _i335;
import '../../features/onboarding/data/data_sources/remote/i_onboarding_client.dart'
    as _i865;
import '../../features/onboarding/data/repo/i_onboarding_repo.dart' as _i827;
import '../../features/onboarding/domain/domain.dart' as _i634;
import '../../features/onboarding/domain/usecases/onboarding_usecase.dart'
    as _i706;
import '../../features/onboarding/onboarding.dart' as _i478;
import '../../features/onboarding/presentation/blocs/onboarding/onboarding_bloc.dart'
    as _i1023;
import '../../features/profile/data/data_sources/remote/i_profile_client.dart'
    as _i850;
import '../../features/profile/data/repo/i_profile_repo.dart' as _i915;
import '../../features/profile/domain/usecases/profile_usecase.dart' as _i996;
import '../../features/profile/presentation/blocs/change_password/change_password_bloc.dart'
    as _i393;
import '../../features/profile/presentation/blocs/edit_profile/edit_profile_bloc.dart'
    as _i1033;
import '../../features/profile/presentation/blocs/logout/logout_bloc.dart'
    as _i987;
import '../../features/profile/presentation/blocs/profile/profile_bloc.dart'
    as _i349;
import '../../features/profile/profile.dart' as _i315;
import '../../features/search/data/data_sources/remote/i_search_client.dart'
    as _i24;
import '../../features/search/data/repo/i_search_repo.dart' as _i217;
import '../../features/search/domain/domain.dart' as _i686;
import '../../features/search/domain/usecases/search_usecase.dart' as _i1053;
import '../../features/search/search.dart' as _i725;
import '../../features/splash/data/data_sources/remote/i_splash_client.dart'
    as _i363;
import '../../features/splash/data/repo/i_splash_repo.dart' as _i183;
import '../../features/splash/domain/domain.dart' as _i502;
import '../../features/splash/domain/usecases/splash_usecase.dart' as _i178;
import '../../features/splash/splash.dart' as _i827;
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
  gh.factory<_i592.LearnClient>(
    () => _i664.ILearnClient(dio: gh<_i361.Dio>(), config: gh<_i351.IConfig>()),
  );
  gh.factory<_i905.HomeClient>(
    () => _i33.IHomeClient(dio: gh<_i361.Dio>(), config: gh<_i351.IConfig>()),
  );
  gh.factory<_i845.AuthenticationClient>(
    () => _i402.IAuthenticationClient(
      dio: gh<_i361.Dio>(),
      config: gh<_i351.IConfig>(),
    ),
  );
  gh.factory<_i827.SplashClient>(
    () =>
        _i363.ISplashClient(dio: gh<_i361.Dio>(), config: gh<_i351.IConfig>()),
  );
  gh.factory<_i478.OnboardingClient>(
    () => _i865.IOnboardingClient(
      dio: gh<_i361.Dio>(),
      config: gh<_i351.IConfig>(),
    ),
  );
  gh.factory<_i315.ProfileClient>(
    () =>
        _i850.IProfileClient(dio: gh<_i361.Dio>(), config: gh<_i351.IConfig>()),
  );
  gh.factory<_i725.SearchClient>(
    () => _i24.ISearchClient(dio: gh<_i361.Dio>(), config: gh<_i351.IConfig>()),
  );
  gh.factory<_i487.HomeRepo>(
    () => _i1030.IHomeRepo(client: gh<_i487.HomeClient>()),
  );
  gh.factory<_i502.SplashRepo>(
    () => _i183.ISplashRepo(client: gh<_i502.SplashClient>()),
  );
  gh.factory<_i686.SearchRepo>(
    () => _i217.ISearchRepo(client: gh<_i686.SearchClient>()),
  );
  gh.factory<_i178.SplashUseCase>(
    () => _i178.SplashUseCase(splashRepo: gh<_i502.SplashRepo>()),
  );
  gh.factory<_i634.OnboardingRepo>(
    () => _i827.IOnboardingRepo(client: gh<_i634.OnboardingClient>()),
  );
  gh.factory<_i315.ProfileRepo>(
    () => _i915.IProfileRepo(client: gh<_i315.ProfileClient>()),
  );
  gh.factory<_i1053.SearchUseCase>(
    () => _i1053.SearchUseCase(searchRepo: gh<_i686.SearchRepo>()),
  );
  gh.factory<_i845.AuthenticationRepo>(
    () => _i998.IAuthenticationRepo(client: gh<_i845.AuthenticationClient>()),
  );
  gh.factory<_i592.LearnRepo>(
    () => _i92.ILearnRepo(client: gh<_i592.LearnClient>()),
  );
  gh.factory<_i573.AuthenticationUseCase>(
    () => _i573.AuthenticationUseCase(
      authenticationRepo: gh<_i845.AuthenticationRepo>(),
    ),
  );
  gh.factory<_i207.HomeUseCase>(
    () => _i207.HomeUseCase(homeRepo: gh<_i487.HomeRepo>()),
  );
  gh.factory<_i891.LearnUseCase>(
    () => _i891.LearnUseCase(learnRepo: gh<_i592.LearnRepo>()),
  );
  gh.factory<_i996.ProfileUseCase>(
    () => _i996.ProfileUseCase(profileRepo: gh<_i315.ProfileRepo>()),
  );
  gh.factory<_i706.OnboardingUseCase>(
    () => _i706.OnboardingUseCase(onboardingRepo: gh<_i634.OnboardingRepo>()),
  );
  gh.factory<_i678.CourseDetailBloc>(
    () => _i678.CourseDetailBloc(learnUseCase: gh<_i592.LearnUseCase>()),
  );
  gh.factory<_i335.CoursesBloc>(
    () => _i335.CoursesBloc(learnUseCase: gh<_i592.LearnUseCase>()),
  );
  gh.factory<_i430.AccountSetUpBloc>(
    () => _i430.AccountSetUpBloc(
      authenticationUseCase: gh<_i845.AuthenticationUseCase>(),
    ),
  );
  gh.factory<_i965.ForgotPasswordBloc>(
    () => _i965.ForgotPasswordBloc(
      authenticationUseCase: gh<_i845.AuthenticationUseCase>(),
    ),
  );
  gh.factory<_i413.LoginBloc>(
    () => _i413.LoginBloc(
      authenticationUseCase: gh<_i845.AuthenticationUseCase>(),
    ),
  );
  gh.factory<_i236.RegisterBloc>(
    () => _i236.RegisterBloc(
      authenticationUseCase: gh<_i845.AuthenticationUseCase>(),
    ),
  );
  gh.factory<_i987.LogoutBloc>(
    () => _i987.LogoutBloc(
      authenticationUseCase: gh<_i845.AuthenticationUseCase>(),
    ),
  );
  gh.factory<_i393.ChangePasswordBloc>(
    () => _i393.ChangePasswordBloc(profileUseCase: gh<_i315.ProfileUseCase>()),
  );
  gh.factory<_i1033.EditProfileBloc>(
    () => _i1033.EditProfileBloc(profileUseCase: gh<_i315.ProfileUseCase>()),
  );
  gh.factory<_i349.ProfileBloc>(
    () => _i349.ProfileBloc(profileUseCase: gh<_i315.ProfileUseCase>()),
  );
  return getIt;
}

class _$DioProvider extends _i92.DioProvider {}
