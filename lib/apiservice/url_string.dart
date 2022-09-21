class UrlConstant {
  // static const String baseUrl = "https://nmk.techvosys.com/api/";

  // static const String baseUrl = "https://staging.newmarketkart.com/api/";
  static const String baseUrl = "https://newmarketkart.com/api/";

  static const String sendOtp = baseUrl + "send-otp";
  static const String verifyUserOtp = baseUrl + "verify-user-otp";
  static const String forget = baseUrl + "forget";

  static const String vendorLoginWith = baseUrl + "vendor-login";
  static const String vendorRegister = baseUrl + "vendor-register";
  static const String vendorLoginWithPassword =
      baseUrl + "vendor-login-with-password";
  static const String businessCreate = baseUrl + "business-create";
  static const String categoriesByBusinessType =
      baseUrl + "categories-by-business-type";
  static const String uploadBusinessImages = baseUrl + "upload-business-images";
  static const String uploadProductImages = baseUrl + "uploadProductImages";

  static const String vendorCategory = baseUrl + "vendorCategory";
  static const String vendorSubCategory = baseUrl + "vendorSubCategory";
  static const String brandsByBusinessType =
      baseUrl + "brands-by-business-type";

  static const String attribute = baseUrl + "attribute";

  static const String productStore = baseUrl + "product-store";
  static const String homePage = baseUrl + "homePage";
  static const String productDelete = baseUrl + "product-delete";
  static const String productUpdate = baseUrl + "product-update";
  static const String products = baseUrl + "products?page=";
  static const String vendorChildSubCategory =
      baseUrl + "vendorChildSubCategory";

  static const String vendorProductwithCaterory =
      baseUrl + "vendorProductwithCaterory";
  static const String subCategoryForAddingProduct =
      baseUrl + "subCategoryForAddingProduct";

  static const String allProductwithCaterory =
      baseUrl + "allProductwithCaterory";

  static const String updatePassword = baseUrl + "updatePassword";

  static const String updateBusinessDocument =
      baseUrl + "updateBusinessDocument";

  static const String hsnNumber = baseUrl + "hsnNumber?category_id=";
  static const String vendorUpdate = baseUrl + "vendor-update";
  static const String vendorDetails = baseUrl + "vendor-detail";
  static const String updateWorkingHours = baseUrl + "updateWorkingHours";
  static const String vendorUpdatePassword = baseUrl + "vendor-updatePassword";
  static const String updateBusinessAddress = baseUrl + "updateBusinessAddress";

  static const String declineReason = baseUrl + "returnReason";

  static const String changeStatus = baseUrl + "vendor/orders/change-status";
  static const String allRecentOrder = baseUrl + "allRecentOrder?page=";
  static const String details = baseUrl + "vendor/orders/details";
  static const String ordersStatus = baseUrl + "vendor/orders?status=";

  static const String businessUpdate = baseUrl + "business-update";

  static const String statusList = baseUrl + "statusList?order_id=";

  static const String aboutPage = "https://newmarketkart.com/app-about";
  static const String termAndConditions =
      "https://newmarketkart.com/app-terms-and-conditions";

  static const String privacyPolicy =
      "https://newmarketkart.com/app-privacy-policy";
  static const String helpSupport = "https://newmarketkart.com/app-help";

  static const String uploadImage = baseUrl + "upload-image";

  static const String returnOrders = baseUrl + "returnOrders?page=";
  static const String returnOrdersDetails =
      baseUrl + "vendor/orders/returnOrderDetail";

  static const String changeReturnOrderStatus =
      baseUrl + "changeReturnOrderStatus";
  static const String allReturnOrder = baseUrl + "allReturnOrder?page=";

  static const String vendorRating = baseUrl + "vendor-rating";
  static const String states = baseUrl + "states";
  static const String cities = baseUrl + "cities?state_id=";

  static const String bankAddress = "https://ifsc.razorpay.com/";

  static const String updateBankDetail = baseUrl + "updateBankDetail";
}
