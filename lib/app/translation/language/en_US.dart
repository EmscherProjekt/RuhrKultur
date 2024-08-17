import '../translation_keys.dart' as translation;

class enUS {
  Map<String, String> get message => {
        translation.navigation_bar_home: 'Home',
        translation.navigation_bar_settings: 'Settings',
        translation.navigation_bar_audioguid: 'Audioguide',

        //Settings
        translation.settings_genral: 'General',
        translation.settings_pacht_notes_modal_titel:
            'Patch Notes Was ist neu?',
        translation.settings_pacht_notes: 'Patch Notes',
        translation.settings_language: 'Language',
        translation.settings_language_deDE: 'German',
        translation.settings_language_enUS: 'English',
        translation.settings_language_ruRU: 'Russian',
        translation.settings_language_trTR: 'Turkish',
        translation.settings_language_ukUA: 'Ukrainian',
        translation.settings_language_frFR: 'French',
        translation.settings_language_arAR: 'Arabic',
        translation.settings_language_modal_titel: 'Select Language',
        translation.settings_about_page__description:
            'Rediscover the Ruhr area',
        translation.settings_app_info: 'App Info',
        translation.settings_app_change_log: 'Change Log',

        //Auth
        translation.auth_login: 'Login',
        translation.auth_already_have_account: 'Already have an account?',
        translation.auth_already_have_account_login: 'Login',
        translation.auth_do_not_have_account: 'Don\'t have an account?',
        translation.auth_do_not_have_account_sign_up: 'Sign Up',
        translation.auth_email: 'Email',
        translation.auth_email_error: 'Invalid email address',
        translation.auth_forgot_password: 'Forgot Password',
        translation.auth_create_password: 'Create Password',
        translation.auth_regster_titel: 'Register',
        translation.auth_regster_firstName: 'First Name',
        translation.auth_regster_firstName_error: 'First name is required',
        translation.auth_regster_lastName: 'Last Name',
        translation.auth_regster_lastName_error: 'Last name is required',
        translation.auth_regster_username: 'Username',
        translation.auth_regster_username_erro: 'Username is required',
        translation.auth_regster_password_retype: 'Retype Password',
        translation.auth_regster_password_retype_error:
            'Please retype the password',
        translation.auth_regster_password_retype_error_notMatch:
            'Passwords do not match',
        translation.auth_regster_password: 'Password',
        translation.auth_regster_password_error: 'Password is required',
        translation.auth_regster_password_validation_minLength:
            'Password must be at least 6 characters long',
        translation.auth_sign_in_with: 'Sign in with',
        translation.auth_terms_and_conditions_one: 'I agree to the',
        translation.auth_terms_and_conditions_two: 'Terms of Service',
        translation.auth_terms_and_conditions_three: 'and',
        translation.auth_terms_and_conditions_four: 'Privacy Policy',

        //Audio
        translation.audio_page_tab_all: 'Alle',
        translation.audio_page_tab_map: 'Karte',
        translation.audio_page_title: 'Audioguide Page',
        translation.audio_page_tooltip_scan: 'Scan QR Code',
        translation.audio_page_no_data_found: 'No data found',
        translation.audio_page_no_data_found_info: 'Please try again later',
        translation.audio_page_card_merken: 'Save',
        translation.audio_page_card_to_audioguid: 'To the Audioguide',
        translation.audio_page_detail_tab_content: 'Content',
        translation.audio_page_detail_tab_media: 'Media',
        translation.audio_page_detail_tab_sources: 'Sources',
        translation.audio_player_current_song: 'Current Guide',
        translation.audio_player_current_description: 'Description',
        translation.audio_player_back: 'Back',
        translation.audio_guid_location_error_titel:
            'We could not find an audioguide near you.',
        translation.audio_guid_location_error_description:
            'Please try again later.',
      };
}
