import 'dart:ui';

class Constants {
    //shared preferences
    static const String SF_KEY_ZIP = 'zip';
    static const String SF_KEY_NAME = 'name';
    static const String SF_KEY_FLAT = 'flat';
    static const String SF_KEY_STREET1 = 'street1';
    static const String SF_KEY_STREET2 = 'street2';
    static const String SF_KEY_CITY = 'city';

    //api
    static const String BASE_URL = 'https://asia-east2-whysh-wish.cloudfunctions.net/api/v1';

    //navigation
    static const int SELECTION_PENDING_TASK = 1;
    static const int SELECTION_CREATE_TASK = 2;
    static const int SELECTION_ASSIGNED_TASK = 3;
    static const int SELECTION_CREATED_TASK = 4;


    static const Color APP_BAR_COLOR = Color.fromARGB(255, 58, 183, 149);

}