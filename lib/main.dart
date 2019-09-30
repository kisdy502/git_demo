import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:git_demo/i10n/i18n.dart';
import 'package:git_demo/routes/HomeRoute.dart';
import 'package:git_demo/routes/LanguageRoute.dart';
import 'package:git_demo/routes/LoginRoute.dart';
import 'package:git_demo/routes/ThemeChangeRoute.dart';
import 'package:git_demo/routes/router_manger.dart';
import 'package:git_demo/widgets/MyDrawer.dart';
import 'package:oktoast/oktoast.dart';
import 'common/Global.dart';
import 'package:git_demo/common/Global.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(MyApp()));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiProvider(
        providers: <SingleChildCloneableWidget>[
          ChangeNotifierProvider.value(value: ThemeModel()),
          ChangeNotifierProvider.value(value: UserModel()),
          ChangeNotifierProvider.value(value: LocaleModel()),
        ],
        child: Consumer2<ThemeModel, LocaleModel>(
          builder:
              (BuildContext context, themeModel, localeModel, Widget child) {
            return MaterialApp(
              theme: ThemeData(
                primarySwatch: themeModel.theme,
              ),
              onGenerateTitle: (context) {
                return S.of(context).title;
              },
              home: new HomeRoute(),
              //应用主页
              locale: localeModel.getLocale(),
              localizationsDelegates: const [
                S.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              supportedLocales: S.delegate.supportedLocales,
              //我们只支持美国英语和中文简体
              localeResolutionCallback:
                  (Locale _locale, Iterable<Locale> supportedLocales) {
                if (localeModel.locale != null) {
                  //如果已经选定语言，则不跟随系统
                  return localeModel.getLocale();
                } else {
                  Locale locale;
                  //APP语言跟随系统语言，如果系统语言不是中文简体或美国英语，
                  //则默认使用美国英语
                  if (supportedLocales.contains(_locale)) {
                    locale = _locale;
                  } else {
                    locale = Locale('en', 'US');
                  }
                  return locale;
                }
              },
              initialRoute: RouteName.home,
              onGenerateRoute: Router.generateRoute,
              // 注册命名路由表
              routes: <String, WidgetBuilder>{
                "login": (context) => new LoginRoute(),
                "themes": (context) => new ThemeChangeRoute(),
                "language": (context) => new LanguageRoute(),
              },
            );
          },
        ),
      ),
    );
  }
}
