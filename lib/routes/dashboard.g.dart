// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $dashboardRoute,
    ];

RouteBase get $dashboardRoute => GoRouteData.$route(
      path: '/',
      factory: $DashboardRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'sign_in',
          factory: $SignInRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'schools',
          factory: $SchoolsListRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'create',
              factory: $SchoolCreateRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'edit/:school_id',
              factory: $SchoolEditRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: ':school_id',
              factory: $SchoolInfoRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'users',
              factory: $UsersListRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'create/:school_id',
                  factory: $UserCreateRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'edit/:user_id',
                  factory: $UserEditRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: ':user_id',
                  factory: $UserInfoRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    );

extension $DashboardRouteExtension on DashboardRoute {
  static DashboardRoute _fromState(GoRouterState state) =>
      const DashboardRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SignInRouteExtension on SignInRoute {
  static SignInRoute _fromState(GoRouterState state) => const SignInRoute();

  String get location => GoRouteData.$location(
        '/sign_in',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SchoolsListRouteExtension on SchoolsListRoute {
  static SchoolsListRoute _fromState(GoRouterState state) => SchoolsListRoute();

  String get location => GoRouteData.$location(
        '/schools',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SchoolCreateRouteExtension on SchoolCreateRoute {
  static SchoolCreateRoute _fromState(GoRouterState state) =>
      SchoolCreateRoute();

  String get location => GoRouteData.$location(
        '/schools/create',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SchoolEditRouteExtension on SchoolEditRoute {
  static SchoolEditRoute _fromState(GoRouterState state) => SchoolEditRoute(
        school_id: int.parse(state.pathParameters['school_id']!),
      );

  String get location => GoRouteData.$location(
        '/schools/edit/${Uri.encodeComponent(school_id.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SchoolInfoRouteExtension on SchoolInfoRoute {
  static SchoolInfoRoute _fromState(GoRouterState state) => SchoolInfoRoute(
        school_id: int.parse(state.pathParameters['school_id']!),
      );

  String get location => GoRouteData.$location(
        '/schools/${Uri.encodeComponent(school_id.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UsersListRouteExtension on UsersListRoute {
  static UsersListRoute _fromState(GoRouterState state) => UsersListRoute(
        school_id: int.parse(state.uri.queryParameters['school_id']!),
      );

  String get location => GoRouteData.$location(
        '/schools/users',
        queryParams: {
          'school_id': school_id.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UserCreateRouteExtension on UserCreateRoute {
  static UserCreateRoute _fromState(GoRouterState state) => UserCreateRoute(
        school_id: int.parse(state.pathParameters['school_id']!),
      );

  String get location => GoRouteData.$location(
        '/schools/users/create/${Uri.encodeComponent(school_id.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UserEditRouteExtension on UserEditRoute {
  static UserEditRoute _fromState(GoRouterState state) => UserEditRoute(
        user_id: int.parse(state.pathParameters['user_id']!),
      );

  String get location => GoRouteData.$location(
        '/schools/users/edit/${Uri.encodeComponent(user_id.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UserInfoRouteExtension on UserInfoRoute {
  static UserInfoRoute _fromState(GoRouterState state) => UserInfoRoute(
        user_id: int.parse(state.pathParameters['user_id']!),
      );

  String get location => GoRouteData.$location(
        '/schools/users/${Uri.encodeComponent(user_id.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
