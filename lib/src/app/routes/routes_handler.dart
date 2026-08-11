import 'package:get/get.dart';

import '../bindings/app_bindings.dart';
import 'routes.dart';
import 'routes_config.dart';

List<GetPage> routesHandler = [
  GetPage(
    name: BaseRoute.root,
    page: () => RoutesConfig.splash,
    binding: SplashBinding(),
  ),

  GetPage(
    name: BaseRoute.splash,
    page: () => RoutesConfig.splash,
    binding: SplashBinding(),
  ),

  GetPage(name: BaseRoute.welcome, page: () => RoutesConfig.welcome),

  GetPage(
    name: BaseRoute.signIn,
    page: () => RoutesConfig.signIn,
    binding: SignInBinding(),
  ),

  GetPage(
    name: BaseRoute.twoFactorAuth,
    page: () => RoutesConfig.twoFactorAuth,
    binding: TwoFactorAuthBinding(),
  ),

  GetPage(
    name: BaseRoute.email,
    page: () => RoutesConfig.email,
    binding: EmailBinding(),
  ),

  GetPage(
    name: BaseRoute.verifyEmail,
    page: () => RoutesConfig.verifyEmail,
    binding: VerifyEmailBinding(),
  ),

  GetPage(
    name: BaseRoute.forgotPassword,
    page: () => RoutesConfig.forgotPassword,
    binding: ForgotPasswordBinding(),
  ),

  GetPage(
    name: BaseRoute.resetPassword,
    page: () => RoutesConfig.resetPassword,
    binding: ResetPasswordBinding(),
  ),

  GetPage(
    name: BaseRoute.forgotPasswordPinVerification,
    page: () => RoutesConfig.forgotPasswordPinVerification,
    binding: ForgotPasswordPinVerificationBinding(),
  ),

  GetPage(
    name: BaseRoute.navigation,
    page: () => RoutesConfig.navigation,
    binding: HomeBinding(),
  ),

  GetPage(
    name: BaseRoute.setUpPassword,
    page: () => RoutesConfig.setUpPassword,
    binding: SetUpPasswordBinding(),
  ),

  GetPage(
    name: BaseRoute.personalInfo,
    page: () => RoutesConfig.personalInfo,
    binding: PersonalInfoBinding(),
  ),

  GetPage(
    name: BaseRoute.authIdVerification,
    page: () => RoutesConfig.authIdVerification,
    binding: AuthIdVerificationBinding(),
  ),

  GetPage(
    name: BaseRoute.signUpStatus,
    page: () => RoutesConfig.signUpStatus,
    binding: SignUpStatusBinding(),
  ),

  GetPage(
    name: BaseRoute.wallets,
    page: () => RoutesConfig.wallets,
    binding: WalletsBinding(),
  ),

  GetPage(
    name: BaseRoute.createNewWallet,
    page: () => RoutesConfig.createNewWallet,
    binding: CreateNewWalletBinding(),
  ),

  GetPage(
    name: BaseRoute.addMoney,
    page: () => RoutesConfig.addMoney,
    binding: AddMoneyBinding(),
  ),

  GetPage(
    name: BaseRoute.addMoneyHistory,
    page: () => RoutesConfig.addMoneyHistory,
    binding: AddMoneyHistoryBinding(),
  ),

  GetPage(
    name: BaseRoute.transactions,
    page: () => RoutesConfig.transactions,
    binding: TransactionsBinding(),
  ),

  GetPage(
    name: BaseRoute.walletsDetails,
    page: () => RoutesConfig.walletDetails,
    binding: WalletDetailsBinding(),
  ),

  GetPage(
    name: BaseRoute.profileSettings,
    page: () => RoutesConfig.profileSettings,
    binding: ProfileSettingsBinding(),
  ),

  GetPage(
    name: BaseRoute.changePassword,
    page: () => RoutesConfig.changePassword,
    binding: ChangePasswordBinding(),
  ),

  GetPage(
    name: BaseRoute.twoFactorAuthentication,
    page: () => RoutesConfig.twoFactorAuthentication,
    binding: TwoFactorAuthenticationBinding(),
  ),

  GetPage(
    name: BaseRoute.notifications,
    page: () => RoutesConfig.notifications,
    binding: NotificationBinding(),
  ),

  GetPage(
    name: BaseRoute.supportTickets,
    page: () => RoutesConfig.supportTickets,
    binding: SupportTicketBinding(),
  ),

  GetPage(
    name: BaseRoute.addNewTicket,
    page: () => RoutesConfig.addNewTicket,
    binding: AddNewTicketBinding(),
  ),

  GetPage(
    name: BaseRoute.replayTicket,
    page: () => RoutesConfig.replayTicket(),
    binding: ReplyTicketBinding(),
  ),

  GetPage(
    name: BaseRoute.idVerification,
    page: () => RoutesConfig.idVerification,
    binding: IDVerificationBinding(),
  ),

  GetPage(
    name: BaseRoute.kycHistory,
    page: () => RoutesConfig.kycHistory,
    binding: KycHistoryBinding(),
  ),

  GetPage(
    name: BaseRoute.maintenanceMode,
    page: () => RoutesConfig.maintenanceMode,
  ),

  GetPage(
    name: BaseRoute.noInternetConnection,
    page: () => RoutesConfig.noInternetConnection,
  ),

  // Travel (etrip)
  GetPage(
    name: BaseRoute.travel,
    page: () => RoutesConfig.travel,
    binding: TravelBinding(),
  ),

  GetPage(
    name: BaseRoute.travelHistory,
    page: () => RoutesConfig.travelHistory,
  ),

  GetPage(
    name: BaseRoute.travelAccount,
    page: () => RoutesConfig.travelAccount,
  ),
];
