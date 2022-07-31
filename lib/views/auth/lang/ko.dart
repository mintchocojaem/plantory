import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterfire_ui/i10n.dart';

class FlutterFireUIRuLocalizationsDelegate
    extends LocalizationsDelegate<FlutterFireUILocalizations> {
  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'en';
  }

  @override
  Future<FlutterFireUILocalizations<FlutterFireUILocalizationLabels>> load(
      Locale locale,
      ) {
    final flutterFireUILocalizations = FlutterFireUILocalizations(locale, KoLocalizations());
    return SynchronousFuture<FlutterFireUILocalizations>(
      flutterFireUILocalizations,
    );
  }

  @override
  bool shouldReload(
      covariant LocalizationsDelegate<
          FlutterFireUILocalizations<FlutterFireUILocalizationLabels>>
      old,
      ) {
    return false;
  }
}

class KoLocalizations extends FlutterFireUILocalizationLabels {
  @override
  final String emailInputLabel;
  @override
  final String passwordInputLabel;
  @override
  final String signInActionText;
  @override
  final String registerActionText;
  @override
  final String linkEmailButtonText;
  @override
  final String signInButtonText;
  @override
  final String registerButtonText;
  @override
  final String signInWithPhoneButtonText;
  @override
  final String signInWithGoogleButtonText;
  @override
  final String signInWithAppleButtonText;
  @override
  final String signInWithFacebookButtonText;
  @override
  final String signInWithTwitterButtonText;
  @override
  final String phoneVerificationViewTitleText;
  @override
  final String verifyPhoneNumberButtonText;
  @override
  final String verifyCodeButtonText;
  @override
  final String verifyingPhoneNumberViewTitle;
  @override
  final String unknownError;
  @override
  final String smsAutoresolutionFailedError;
  @override
  final String smsCodeSentText;
  @override
  final String sendingSMSCodeText;
  @override
  final String verifyingSMSCodeText;
  @override
  final String enterSMSCodeText;
  @override
  final String emailIsRequiredErrorText;
  @override
  final String isNotAValidEmailErrorText;
  @override
  final String userNotFoundErrorText;
  @override
  final String emailTakenErrorText;
  @override
  final String accessDisabledErrorText;
  @override
  final String wrongOrNoPasswordErrorText;
  @override
  final String signInText;
  @override
  final String registerText;
  @override
  final String registerHintText;
  @override
  final String signInHintText;
  @override
  final String signOutButtonText;
  @override
  final String phoneInputLabel;
  @override
  final String phoneNumberIsRequiredErrorText;
  @override
  final String phoneNumberInvalidErrorText;
  @override
  final String profile;
  @override
  final String name;
  @override
  final String deleteAccount;
  @override
  final String passwordIsRequiredErrorText;
  @override
  final String confirmPasswordIsRequiredErrorText;
  @override
  final String confirmPasswordDoesNotMatchErrorText;
  @override
  final String confirmPasswordInputLabel;
  @override
  final String forgotPasswordButtonLabel;
  @override
  final String forgotPasswordViewTitle;
  @override
  final String resetPasswordButtonLabel;
  @override
  final String verifyItsYouText;
  @override
  final String differentMethodsSignInTitleText;
  @override
  final String findProviderForEmailTitleText;
  @override
  final String continueText;
  @override
  final String countryCode;
  @override
  final String codeRequiredErrorText;
  @override
  final String invalidCountryCode;
  @override
  final String chooseACountry;
  @override
  final String enableMoreSignInMethods;
  @override
  final String signInMethods;
  @override
  final String provideEmail;
  @override
  final String goBackButtonLabel;
  @override
  final String passwordResetEmailSentText;
  @override
  final String forgotPasswordHintText;
  @override
  final String emailLinkSignInButtonLabel;
  @override
  final String signInWithEmailLinkViewTitleText;
  @override
  final String signInWithEmailLinkSentText;
  @override
  final String sendLinkButtonLabel;
  @override
  final String arrayLabel;
  @override
  final String booleanLabel;
  @override
  final String mapLabel;
  @override
  final String nullLabel;
  @override
  final String numberLabel;
  @override
  final String stringLabel;
  @override
  final String typeLabel;
  @override
  final String valueLabel;
  @override
  final String cancelLabel;
  @override
  final String updateLabel;
  @override
  final String northInitialLabel;
  @override
  final String southInitialLabel;
  @override
  final String westInitialLabel;
  @override
  final String eastInitialLabel;
  @override
  final String timestampLabel;
  @override
  final String latitudeLabel;
  @override
  final String longitudeLabel;
  @override
  final String geopointLabel;
  @override
  final String referenceLabel;

  const KoLocalizations({
  this.emailInputLabel= '이메일',
  this.passwordInputLabel = '비밀번호',
  this.signInActionText= '로그인',
  this.registerActionText = '회원가입',
  this.signInButtonText= '로그인',
  this.registerButtonText = '회원가입',
  this.linkEmailButtonText = '다음',
  this.signInWithPhoneButtonText = '전화번호로 로그인',
  this.signInWithGoogleButtonText = 'Google을 통해 로그인',
  this.signInWithAppleButtonText = 'Apple을 통해 로그인',
  this.signInWithTwitterButtonText = 'Twitter를 통해 로그인',
  this.signInWithFacebookButtonText= 'Facebook을 통해 로그인',
  this.phoneVerificationViewTitleText = '전화번호 입력해주세요',
  this.verifyPhoneNumberButtonText = '다음',
  this.verifyCodeButtonText = '인증',
  this.verifyingPhoneNumberViewTitle = '인증번호를 입력하세요',
  this.unknownError= '알 수 없는 오류 발생',
  this.smsAutoresolutionFailedError='인증번호를 수동으로 입력하세요',
  this.smsCodeSentText='인증번호를 발송하였습니다',
  this.sendingSMSCodeText = '문자 메시지로 인증번호를 보내는 중...',
  this.verifyingSMSCodeText = '인증코드 확인 중...',
  this.enterSMSCodeText= '인증번호를 입력하세요',
  this.emailIsRequiredErrorText = '이메일 주소는 필수입력 항목입니다',
  this.isNotAValidEmailErrorText = '정확한 이메일 주소를 입력하세요',
  this.userNotFoundErrorText = '계정이 존재하지 않습니다',
  this.emailTakenErrorText = '이 이메일은 이미 등록되어 있습니다',
  this.accessDisabledErrorText = '해당 계정은 일시적으로 접속이 금지되었습니다',
  this.wrongOrNoPasswordErrorText = '비밀번호가 틀리거나 계정이 존재하지 않습니다',
  this.signInText= '로그인',
  this.registerText= '회원가입',
  this.registerHintText= 'Plantory에 처음 오셨나요?',
  this.signInHintText= '기존 이용자이신가요？',
  this.signOutButtonText='로그아웃',
  this.phoneInputLabel='전화번호',
  this.phoneNumberInvalidErrorText = '전화번호가 유효하지 않습니다',
  this.phoneNumberIsRequiredErrorText = '전화번호는 필수입력 항목입니다',
  this.profile= '프로필',
  this.name = '이름',
  this.deleteAccount= '계정 삭제',
  this.passwordIsRequiredErrorText = '비밀번호는 필수입력 항목입니다',
  this.confirmPasswordIsRequiredErrorText= '비밀번호를 재입력하세요',
  this.confirmPasswordDoesNotMatchErrorText= '비밀번호가 일치하지 않습니다',
  this.confirmPasswordInputLabel = '비밀번호 확인',
  this.forgotPasswordButtonLabel = '비밀번호를 잊으셨나요?',
  this.forgotPasswordViewTitle= '비밀번호 찾기',
  this.resetPasswordButtonLabel = '비밀번호 재설정',
  this.verifyItsYouText='본인인증',
  this.differentMethodsSignInTitleText= '다음 중 하나의 방식으로 로그인',
  this.findProviderForEmailTitleText = '계속하기 위하여 이메일 입력' ,
  this.continueText= '계속',
  this.countryCode= '지역코드',
  this.codeRequiredErrorText = '지역코드는 필수입력 항목입니다',
  this.invalidCountryCode = '유효하지 않은 지역 코드',
  this.chooseACountry = '하나의 국가 또는 지역을 선택하세요',
  this.enableMoreSignInMethods = '더 많은 로그인 방식 사용',
  this.signInMethods= '로그인 방식',
  this.provideEmail= '이메일과 비밀번호를 입력하세요',
  this.goBackButtonLabel='뒤로가기',
  this.passwordResetEmailSentText = '비밀번호 재설정 링크를 이용자님의 메일로 보냈습니다',
  this.forgotPasswordHintText = '비밀번호 재설정 링크를 보낼 수 있도록 이메일을 입력해주세요',
  this.emailLinkSignInButtonLabel = '매직링크로 로그인',
  this.signInWithEmailLinkViewTitleText= '매직링크로 로그인',
  this.signInWithEmailLinkSentText = '이용자님의 메일로 매직링크를 보냈습니다. 메일함을 확인하고 링크를 클릭해주세요',
  this.sendLinkButtonLabel = '매직링크 보내기',
  this.arrayLabel = 'array',
  this.booleanLabel = 'boolean',
  this.mapLabel = 'map',
  this.nullLabel = 'null',
  this.numberLabel = 'number',
  this.stringLabel = 'string',
  this.typeLabel = 'type',
  this.valueLabel = 'value',
  this.cancelLabel = 'cancel',
  this.updateLabel = 'update',
  this.northInitialLabel = 'N',
  this.southInitialLabel = 'S',
  this.westInitialLabel = 'W',
  this.eastInitialLabel = 'E',
  this.timestampLabel = 'timestamp',
  this.longitudeLabel = 'longitude',
  this.latitudeLabel = 'latitude',
  this.geopointLabel = 'geopoint',
  this.referenceLabel = 'reference',
  });
}
