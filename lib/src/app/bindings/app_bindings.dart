import 'package:get/get.dart';

import '../../common/controller/country_controller.dart';
import '../../common/controller/register_fields_controller.dart';
import '../../presentation/screens/add_money/controller/add_money_controller.dart';
import '../../presentation/screens/add_money/controller/add_money_history_controller.dart';
import '../../presentation/screens/authentication/forgot_password/controller/forgot_password_controller.dart';
import '../../presentation/screens/authentication/forgot_password/controller/forgot_password_pin_verification_controller.dart';
import '../../presentation/screens/authentication/forgot_password/controller/reset_password_controller.dart';
import '../../presentation/screens/authentication/sign_in/controller/sign_in_controller.dart';
import '../../presentation/screens/authentication/sign_in/controller/two_factor_auth_controller.dart';
import '../../presentation/screens/authentication/sign_up/controller/auth_id_verification_controller.dart';
import '../../presentation/screens/authentication/sign_up/controller/email_controller.dart';
import '../../presentation/screens/authentication/sign_up/controller/personal_info_controller.dart';
import '../../presentation/screens/authentication/sign_up/controller/set_up_password_controller.dart';
import '../../presentation/screens/authentication/sign_up/controller/sign_up_status_controller.dart';
import '../../presentation/screens/authentication/sign_up/controller/verify_email_controller.dart';
import '../../presentation/screens/authentication/splash/controller/splash_controller.dart';
import '../../presentation/screens/home/controller/home_controller.dart';
import '../../presentation/screens/home/controller/wallet_details_controller.dart';
import '../../presentation/screens/settings/controller/add_new_ticket_controller.dart';
import '../../presentation/screens/settings/controller/change_password_controller.dart';
import '../../presentation/screens/settings/controller/id_verification_controller.dart';
import '../../presentation/screens/settings/controller/kyc_history_controller.dart';
import '../../presentation/screens/settings/controller/notification_controller.dart';
import '../../presentation/screens/settings/controller/profile_settings_controller.dart';
import '../../presentation/screens/settings/controller/reply_ticket_controller.dart';
import '../../presentation/screens/settings/controller/support_ticket_controller.dart';
import '../../presentation/screens/settings/controller/two_factor_authentication_controller.dart';
import '../../presentation/screens/transactions/controller/transactions_controller.dart';
import '../../presentation/screens/travel/core/controller/travel_controller.dart';
import '../../presentation/screens/wallets/controller/create_new_wallet_controller.dart';
import '../../presentation/screens/wallets/controller/wallets_controller.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}

class TwoFactorAuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TwoFactorAuthController>(() => TwoFactorAuthController());
  }
}

class EmailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailController>(() => EmailController());
  }
}

class VerifyEmailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyEmailController>(() => VerifyEmailController());
  }
}

class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}

class ForgotPasswordPinVerificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordPinVerificationController>(
      () => ForgotPasswordPinVerificationController(),
    );
  }
}

class ResetPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
  }
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class RegisterFieldsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterFieldsController>(() => RegisterFieldsController());
  }
}

class CountryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CountryController>(() => CountryController());
  }
}

class WalletsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletsController>(() => WalletsController());
  }
}

class CreateNewWalletBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateNewWalletController>(() => CreateNewWalletController());
  }
}

class TransactionsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionsController>(() => TransactionsController());
  }
}

class AddMoneyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddMoneyController>(() => AddMoneyController());
  }
}

class AddMoneyHistoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddMoneyHistoryController>(() => AddMoneyHistoryController());
  }
}

class ProfileSettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSettingsController>(() => ProfileSettingsController());
  }
}

class ChangePasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
  }
}

class IDVerificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IdVerificationController>(() => IdVerificationController());
  }
}

class KycHistoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KycHistoryController>(() => KycHistoryController());
  }
}

class TwoFactorAuthenticationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TwoFactorAuthenticationController>(
      () => TwoFactorAuthenticationController(),
    );
  }
}

class NotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}

class SupportTicketBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportTicketController>(() => SupportTicketController());
  }
}

class AddNewTicketBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddNewTicketController>(() => AddNewTicketController());
  }
}

class ReplyTicketBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReplyTicketController>(() => ReplyTicketController());
  }
}

class SetUpPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetUpPasswordController>(() => SetUpPasswordController());
  }
}

class PersonalInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalInfoController>(() => PersonalInfoController());
  }
}

class AuthIdVerificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthIdVerificationController>(
      () => AuthIdVerificationController(),
    );
  }
}

class SignUpStatusBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpStatusController>(() => SignUpStatusController());
  }
}

class WalletDetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletDetailsController>(() => WalletDetailsController());
  }
}

class TravelBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TravelController>(() => TravelController());
  }
}
