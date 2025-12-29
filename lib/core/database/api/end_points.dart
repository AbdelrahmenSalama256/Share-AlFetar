//! EndPoints
class EndPoints {
  static const String baseUrl = "https://cozyhome.com.sa/api/";
  static const String baseUrlWithoutApi = "https://cozyhome.com.sa/uploads/";
  //! Login
  static const String login = "${baseUrl}login";
  static const String getProfile = "${baseUrl}contact-details";
  static const String updateProfile = "${baseUrl}profile-update";

  //! Register
  static const String register = "${baseUrl}signup";
  static const String forgotPassword = "${baseUrl}forget-password";
  //! Logout
  static const String userLogout = "${baseUrl}logout";
  static const String deleteAccount = "${baseUrl}auth/account-deletion";
  //! Forget Password

  static const String notifications = 'notifications';
  static const String markAllNotificationsRead = 'notifications/mark-all-read';

  static const String category = '${baseUrl}categories';
  static const String allProducts = '${baseUrl}all-products';
  static const String productDetails = '${baseUrl}product-details';

  static const String favorites = '${baseUrl}wishlist-details';
  static const String addProductToWishlist = '${baseUrl}add-to-wishlist';
  static const String removeFavItem = '${baseUrl}remove-wishlist';

  static const String cart = '${baseUrl}cart-details';
  static const String addProductToCart = '${baseUrl}add-to-cart';
  static const String updateCartItemQuantity = '${baseUrl}update-cart';
  static const String removeCartItem = '${baseUrl}remove-cart';
  static const String clearCart = '${baseUrl}clear-cart';

  //! Addresses
  static const String getAddresses = '${baseUrl}addresses';
  static const String addAddress = '${baseUrl}addresses';
  static const String updateAddress = '${baseUrl}update-address';
  static const String deleteAddress = '${baseUrl}addresses';
  static const String setDefaultAddress = '${baseUrl}addresses';
  static const String cities = '${baseUrl}cities';

  //! place Orders
  static const String placeOrder = '${baseUrl}place-order';

  //! Fetch Orders
  static const String getOrders = '${baseUrl}my-orders';
  static const String getOrdersDetails = '${baseUrl}order-details';
  static const String cancelOrder = '${baseUrl}cancel-order';
  static const String trackOrder = '${baseUrl}order-tracks';

  static const String offers = '${baseUrl}offers';
  static const String productByoffers = '${baseUrl}offer-products';
  static const String settingsEndpoint = '${baseUrl}settings';
  static const String about = '${baseUrl}about';

  static const String submitTicket = '${baseUrl}submit-ticket';
  static const String getSupportTickets = '${baseUrl}support-tickets';
}

//! ApiKey
class ApiKey {
  static const String status = "status";
  static const String result = "result";
  static const String question = "questions";
  static const String answers = "answers";
  static const String bookingId = "booking_id";
  static const String userType = "user_type";
  static const String review = "review";
  static const String expertId = "expert_id";
  static const String success = "success";
  static const String message = "message";
  static const String totalTax = "total_tax";
  static const String expert = "expert";
  static const String data = "data";

  static const String authorization = "Authorization";
  static const String token = "token";
  static const String webtoken = "wss_token";
  static const String emailOrPhone = "email_or_phone";
  static const String emailOrCode = "email_or_code";
  static const String password = "password";
  static const String id = "id";
  static const String name = "name";
  static const String email = "email";
  static const String phone = "phone";
  static const String type = "type";
  static const String image = "image";
  static const String isActive = "is_active";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
  static const String passwordConfirmation = "password_confirmation";
  static const String address = "address";
  static const String lon = "lon";
  static const String lat = "lat";
  static const String phoneOne = "phone_one";
  static const String phoneTwo = "phone_two";
  static const String facebook = "facebook";
  static const String tiktok = "tiktok";
  static const String twitter = "twitter";
  static const String whatsapp = "whatsapp";
  static const String avaliableTime = "avaliable_time";
  static const String tradeRegisterImage = "trade_register_image";
  static const String taxCardImage = "tax_card_image";
  static const String placeImage = "place_image";
  static const String cardImage = "card_image";
  static const String website = "website";
  static const String day = "day";
  static const String start = "start";
  static const String end = "end";
  static const String weekend = "weekend";
  static const String profilePicture = "profile_picture";
  static const String otp = "otp";
  static const String title = "title";
  static const String description = "description";
  static const String relatedBlogs = "related_blogs";
  static const String blogs = "blogs";
  static const String sliders = "sliders";
  static const String en = "en";
  static const String ar = "ar";
  static const String price = "price";
  static const String products = "products";
  static const String product = "product";
  static const String category = "category";
  static const String car = "car";
  static const String categoryId = "category_id";
  static const String instagram = "instagram";
  static const String parentBranche = "parent_branche";
  static const String isMainBranch = "is_main_branch";
  static const String redeemPoints = "redeem_points";
  static const String socialMedia = "soical_media";
  static const String mainBranch = "main_branch";
  static const String from = "from";
  static const String branchId = "branch_id";
  static const String orderDetails = "order_details";
  static const String productId = "product_id";
  static const String quantity = "quantity";
  static const String carId = "car_id";
  static const String totalPrice = "total_price";
  static const String branch = "branch";
  static const String odrderDetails = "odrder_details";
  static const String order = "order";
  static const String totalPieces = "total_pieces";
  static const String location = "location";
  static const String branchName = "branch_name";
  static const String services = "services";
  static const String winch = "winch";
  static const String winsh = "winsh";
  static const String vendor = "vendor";
  static const String vendors = "vendors";
  static const String branches = "branches";
  static const String service = "service";
  static const String slider = "slider";
  static const String nearbyPlaces = "Nearby_places";
  static const String isFav = "is_favorite";
  static const String points = "points";
  static const String code = "code";
  static const String value = "value";
  static const String userId = "user_id";
  static const String vendorId = "vendor_id";
  static const String vouchers = "vouchers";
  static const String currentPassword = "current_password";
  static const String newPassword = "new_password";
  static const String newPasswordConfirmation = "new_password_confirmation";
  static const String key = "key";
  static const String settings = "settings";
  static const String totalUserPoints = "Total User Points";
  static const String couponPoints = "Coupon Points";
  static const String mostView = "most_view";
  static const String remainingDays = "remaining_days";
  static const String verifedEmail = "verifed_email";
  static const String loginBy = "login_by";
  static const String avatar = "avatar";
  static const String avatarOriginal = "avatar_original";
  static const String emailVerified = "email_verified";
  static const String accessToken = "access_token";
  static const String wssToken = "wss_token";
  static const String tokenType = "token_type";
  static const String expiresAt = "expires_at";
  static const String user = "user";
  static const String verifyBy = "verify_by";
  static const String verificationCode = "verification_code";
  static const String tempUserId = "temp_user_id";
  static const String variant = "variant";
  static const String grandTotal = "grand_total";
  static const String ownerId = "owner_id";
  static const String subTotal = "sub_total";
  static const String cartItems = "cart_items";
  static const String auctionProduct = "auction_product";
  static const String productThumbnailImage = "product_thumbnail_image";
  static const String variation = "variation";
  static const String currencySymbol = "currency_symbol";
  static const String tax = "tax";
  static const String shippingCost = "shipping_cost";
  static const String lowerLimit = "lower_limit";
  static const String upperLimit = "upper_limit";
  static const String productName = "product_name";
  static const String qty = "qty";
  static const String categoryName = "category_name";
  static const String rating = "rating";
  static const String slug = "slug";
  static const String thumbnailImage = "thumbnail_image";
  static const String basePrice = "base_price";
  static const String productSlug = "product_slug";
  static const String wishlistId = "wishlist_id";
  static const String isInWishlist = "is_in_wishlist";
  static const String sendCodeBy = "send_code_by";
  static const String buyProduct = "buy_product";
  static const String salon = "salon";
  static const String sender = "sender";
  static const String receiver = "receiver";
  static const String reply = "reply";
}
