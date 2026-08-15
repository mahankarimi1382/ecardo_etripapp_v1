import 'package:ecardo_etrip/src/presentation/screens/add_money/view/add_money_history/add_money_history.dart';
import 'package:ecardo_etrip/src/presentation/screens/add_money/view/add_money_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/forgot_password/view/forgot_password_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/forgot_password/view/sub_sections/forgot_password_pin_verification.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/forgot_password/view/sub_sections/reset_password.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/sign_in/view/sign_in_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/sign_in/view/sub_sections/two_factor_auth.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/sign_up/view/auth_id_verification/auth_id_verification_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/sign_up/view/email/email_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/sign_up/view/personal_info/personal_info_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/sign_up/view/set_up_password/set_up_password_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/sign_up/view/sign_up_status/sign_up_status_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/sign_up/view/verify_email/verify_email_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/splash/view/splash_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/authentication/welcome/view/welcome_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/wallet_details/wallet_details.dart';
import 'package:ecardo_etrip/src/presentation/screens/settings/view/change_password/change_password.dart';
import 'package:ecardo_etrip/src/presentation/screens/settings/view/id_verification/id_verification.dart';
import 'package:ecardo_etrip/src/presentation/screens/settings/view/id_verification/kyc_history/kyc_history.dart';
import 'package:ecardo_etrip/src/presentation/screens/settings/view/notifications/notifications.dart';
import 'package:ecardo_etrip/src/presentation/screens/settings/view/profile_settings/profile_settings.dart';
import 'package:ecardo_etrip/src/presentation/screens/settings/view/settings_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/settings/view/support_tickets/add_new_ticket/add_new_ticket.dart';
import 'package:ecardo_etrip/src/presentation/screens/settings/view/support_tickets/replay_ticket/replay_ticket.dart';
import 'package:ecardo_etrip/src/presentation/screens/settings/view/support_tickets/support_tickets.dart';
import 'package:ecardo_etrip/src/presentation/screens/settings/view/two_factor_authentication/two_factor_authentication.dart';
import 'package:ecardo_etrip/src/presentation/screens/transactions/view/transactions_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/account/travel_account_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/account/travel_history_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/home/travel_home_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/wallets/view/create_new_wallet/create_new_wallet.dart';
import 'package:ecardo_etrip/src/presentation/screens/wallets/view/wallets_screen.dart';
import 'package:ecardo_etrip/src/presentation/widgets/maintenance_mode.dart';
import 'package:ecardo_etrip/src/presentation/widgets/no_internet_connection.dart';
import '../navigation/navigation_screen.dart';

class RoutesConfig {
  static const splash = SplashScreen();

  static const welcome = WelcomeScreen();

  static const signIn = SignInScreen();

  static const twoFactorAuth = TwoFactorAuth();

  static const email = EmailScreen();

  static const verifyEmail = VerifyEmailScreen();

  static const personalInfo = PersonalInfoScreen();

  static const authIdVerification = AuthIdVerificationScreen();

  static const forgotPassword = ForgotPasswordScreen();

  static const forgotPasswordPinVerification = ForgotPasswordPinVerification();

  static const resetPassword = ResetPassword();

  static const navigation = NavigationScreen();

  static const settings = SettingsScreen();

  static const setUpPassword = SetUpPasswordScreen();

  static const signUpStatus = SignUpStatusScreen();

  static const wallets = WalletsScreen();

  static const createNewWallet = CreateNewWallet();

  static const addMoney = AddMoneyScreen();

  static const addMoneyHistory = AddMoneyHistory();

  static const transactions = TransactionsScreen();

  static const walletDetails = WalletDetails();

  static const profileSettings = ProfileSettings();

  static const changePassword = ChangePassword();

  static const twoFactorAuthentication = TwoFactorAuthentication();

  static const notifications = Notifications();

  static const supportTickets = SupportTickets();

  static const addNewTicket = AddNewTicket();

  static ReplayTicket replayTicket() => ReplayTicket(ticketUid: '');

  static const idVerification = IdVerification();

  static const kycHistory = KycHistory();

  static const maintenanceMode = MaintenanceMode();

  static const noInternetConnection = NoInternetConnection();

  // Travel (etrip)
  static const travel = TravelHomeScreen();

  static const travelHistory = TravelHistoryScreen();

  static const travelAccount = TravelAccountScreen();
}
