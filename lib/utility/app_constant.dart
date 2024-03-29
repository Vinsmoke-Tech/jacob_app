class AppConstans {
  static const String APP_NAME = "JACOB";
  static const String APP_VERSION = "2.0.1";
  // static const String BASE_URL = "http://192.168.1.40:8000";
  static const String BASE_URL = "http://117.53.144.51/jjm";


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

  //SimpWajib
  static const String MANDATORYSAVINGS = "/api/processAddMemberSavings/";
  static const String LISTMANDATORYSAVINGS = "/api/get-history-simpanan-wajib/";
  
  //ANGSURAN
  static const String GETDATACREDIT = "/api/getDataCredit";
  static const String POSTCREDITSBYID = "/api/PostCreditsById";
  static const String PAYMENTCASH = "/api/processAddCreditsPaymentCash/";
  static const String LISTCREDIT = "/api/GetAngsuran";

  //SETOR 
  static const String DEPOSITBYID = "/api/saving/deposit/";
  
  //TARIK 
  static const String WITHDRAWBYID = "/api/saving/withdraw/";

  // printer end points
  static const String PRINTER_ADDRESS = "/api/printer-address/";
  static const String PRINTER_UPDATE = "/api/printer-address/update/";
  static const String DEPOSITPRINT = "/api/print-deposit";
  static const String WITHDRAWPRINT = "/api/print-withdraw";
  static const String ANGSURANPRINT = "/api/print-credits-payment";
  static const String MANDATORYPRINT = "/api/print-member-savings";




}