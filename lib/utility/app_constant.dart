class AppConstans {
  static const String APP_NAME = "JACOB";
  static const String APP_VERSION = "2.0.1";
  static const String BASE_URL = "http://192.168.1.31:8000";
  // static const String BASE_URL = "http://117.53.144.51/jjm";


  // company end points
  static const String PREFERENCE_COMPANY = "/api/preference-company";
  static const String PHONE = "+6281226124600";

  // dio api client
  static const String API_CLIENT = "/api";

  // user auth end points
  static const String REGISTER = "/api/register-guest";
  static const String LOGIN = "/api/login";
  static const String LOGIN_STATE = "/api/getLoginState";
  static const String LOGOUT = "/api/logout";

  //DataSavings
  static const String DATASAVINGS = "/api/getMembers";
  static const String POSTSAVINGS = "/api/PostSavingsByMember/";
  static const String INSERTSAVINGS = "/api/PostSavingsById/";
  static const String POSTMUTATION = "/api/PostSavingsmutation";
  static const String WITHDRAWMUTATION = "/api/GetWithdraw";
  static const String MANDATORYSAVINGS = "/api/processAddMemberSavings/";

  static const String GETDATACREDIT = "/api/getDataCredit";
  static const String POSTCREDITSBYID = "/api/PostCreditsById";

  static const String DEPOSITBYID = "/api/saving/deposit/";
  static const String WITHDRAWBYID = "/api/saving/withdraw/";



}