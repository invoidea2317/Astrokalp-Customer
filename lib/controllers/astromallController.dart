import 'dart:convert';

import 'package:AstrowayCustomer/model/astromall_category_model.dart';
import 'package:AstrowayCustomer/model/astromall_product_model.dart';
import 'package:AstrowayCustomer/model/user_address_model.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

import '../model/daan_model.dart';
import '../model/pooja_model.dart';
import '../utils/global.dart';

class AstromallController extends GetxController with GetSingleTickerProviderStateMixin {
  List astroCategory = <AstromallCategoryModel>[];
  List astroProduct = <AstromallProductModel>[];
  List astroProductbyId = <AstromallProductModel>[];
  TabController? tabControllerAstroMall;
  int currentIndexAstroMall = 0;
  String? countryCode;
  String? countryCode2;

  //user address
  List userAddress = <UserAddressModel>[];
  APIHelper apiHelper = APIHelper();

  ScrollController scrollController = ScrollController();
  //add address TextEditing controller
  TextEditingController nameController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController alternatePhoneController = TextEditingController();
  TextEditingController flatNoController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  bool isScrollable = false;
  bool isScrollableNot = true;
  String errorText = "";
  ScrollController astromallCatScrollController = ScrollController();
  int fetchRecord = 20;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  FocusNode namefocus = FocusNode();
  FocusNode phone1focus = FocusNode();
  FocusNode phone2focus = FocusNode();

  ScrollController astromallProductScrollController = ScrollController();
  int startIndexForProduct = 0;
  bool isDataLoadedFroProduct = false;
  bool isAllDataLoadedForProduct = false;
  bool isMoreDataAvailableForProduct = false;
  int? productCatId;

  @override
  void onInit() async {
    tabControllerAstroMall = TabController(length: 3, vsync: this, initialIndex: currentIndexAstroMall);
    _init();
    super.onInit();
  }

  _init() async {
    paginateTask();
    getDaanProducts();
    getPoojaProducts();

  }

  updateScroll(bool value) {
    isScrollable = value;
    update();
  }

  void paginateTask() {
    astromallCatScrollController.addListener(() async {
      isScrollable = true;
      update();
      if (astromallCatScrollController.position.pixels == astromallCatScrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('notify in paginatetask');
        update();
        await getAstromallCategory(true);
      }
    });
    astromallProductScrollController.addListener(() async {
      if (astromallProductScrollController.position.pixels == astromallProductScrollController.position.maxScrollExtent && !isAllDataLoadedForProduct) {
        isMoreDataAvailableForProduct = true;
        print('productCatIdddd $productCatId');
        update();
        if (productCatId != null) {
          await getAstromallProduct(productCatId!, true);
        }
      }
    });
  }

  updateCountryCode(value, int flag) {
    if (flag == 1) {
      countryCode = value.toString();
    } else {
      countryCode2 = value.toString();
    }
    update();
  }

  bool isValidData() {
    if (phoneController.text == "") {
      errorText = "Please Enter Phone no.";
      return false;
    } else if (flatNoController.text == "") {
      errorText = "Please Enter Flate no.";
      return false;
    } else if (localityController.text == "") {
      errorText = "Please Enter Locality";
      return false;
    } else if (cityController.text == "") {
      errorText = "Please Enter City";
      return false;
    } else if (countryController.text == "") {
      errorText = "Please Enter Country";
      return false;
    } else if (pinCodeController.text == "") {
      errorText = "Please Enter Pincode";
      return false;
    } else {
      return true;
    }
  }

  getAstromallCategory(bool isLazyLoading) async {
    try {
      print('getAstromallCategory call');
      startIndex = 0;
      if (astroCategory.isNotEmpty) {
        startIndex = astroCategory.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstromallCategory(startIndex, fetchRecord).then((result) {
            if (result.status == "200") {
              astroCategory.addAll(result.recordList);
              update();
              print('astromall cat list length ${astroCategory.length} ');
              if (result.recordList.length == 0) {
                isMoreDataAvailable = false;
                isAllDataLoaded = true;
              }
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print("Exception in getAstromallCategory:-" + e.toString());
    }
  }

  orderRequest({int? catId, int? prodId, int? addId, double? payAmount, int? gstPercent, String? payMethod, double? totalPayment}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.orderAdd(productCatId: catId, productId: prodId, addressId: addId, gst: gstPercent, paymentMethod: payMethod, amount: payAmount, totalPay: totalPayment).then((result) async {
            if (result.status == "200") {
              await global.splashController.getCurrentUserData();
              global.splashController.currentUser?.walletAmount = global.splashController.currentUser?.walletAmount ?? 0 - (totalPayment ?? 0);
              update();

              global.showToast(
                message: 'Order SuccessFully',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Order not created',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in orderRequest : - ${e.toString()}');
    }
  }

  getAstromallProduct(int id, bool isProductLazyLoading) async {
    global.showOnlyLoaderDialog(Get.context);
    update();

    try {
      print('getAstromallProduct call');
      startIndexForProduct = 0;
      if (astroProduct.isNotEmpty) {
        startIndexForProduct = astroProduct.length;
      }
      if (!isProductLazyLoading) {
        isDataLoadedFroProduct = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstromallProduct(id, startIndexForProduct, fetchRecord).then((result) {
            if (result.status == "200") {
              astroProduct.addAll(result.recordList);
              update();
              if (result.recordList.length == 0) {
                isMoreDataAvailableForProduct = false;
                isAllDataLoadedForProduct = true;
              }
              print('product length:- ${astroProduct.length} ');
              update();
            } else {
              global.showToast(
                message: '',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstromallProduct:-" + e.toString());
    }
    global.hideLoader();
    update();
  }

  getproductById(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getProductById(id).then((result) {
            if (result.status == "200") {
              print('iddd :- $id');
              astroProductbyId = result.recordList;
              update();
            } else {
              global.showToast(
                message: '',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getproductById:-" + e.toString());
    }
  }

  getUserAddressData(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getUserAddress(id).then((result) {
            if (result.status == "200") {
              userAddress = result.recordList;
              update();
            } else {
              global.showToast(
                message: '',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getUserAddressData:-" + e.toString());
    }
  }

  addAddress(int id) async {
    UserAddressModel userAddressModel = UserAddressModel(
      userId: id,
      name: nameController.text,
      phoneNumber: phoneController.text,
      phoneNumber2: alternatePhoneController.text,
      flatNo: flatNoController.text,
      locality: localityController.text,
      landmark: landmarkController.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      pincode: int.parse(pinCodeController.text),
      countryCode: countryCode,
      alternateCountryCode: countryCode2,
    );
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.addAddress(userAddressModel).then((result) {
            if (result.status == "200") {
              print('success');
              countryCode = "IN";
              countryCode2 = "IN";
              update();
            } else {
              global.showToast(
                message: 'Address not added please try later!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in addAddress ${e.toString()}');
    }
  }

  removeData() {
    try {
      nameController.text = "";
      phoneController.text = "";
      alternatePhoneController.text = "";
      flatNoController.text = "";
      localityController.text = "";
      landmarkController.text = "";
      cityController.text = "";
      stateController.text = "";
      countryController.text = "";
      pinCodeController.text = "";
      countryCode = "IN";
      countryCode2 = "IN";
      update();
    } catch (e) {
      print("exception in removeData " + e.toString());
    }
  }

  getEditAddress(int index) async {
    try {
      nameController.text = userAddress[index].name;
      phoneController.text = userAddress[index].phoneNumber;
      alternatePhoneController.text = userAddress[index].phoneNumber2;
      flatNoController.text = userAddress[index].flatNo;
      localityController.text = userAddress[index].locality;
      landmarkController.text = userAddress[index].landmark;
      cityController.text = userAddress[index].city;
      stateController.text = userAddress[index].state;
      countryController.text = userAddress[index].country;
      pinCodeController.text = userAddress[index].pincode.toString();
      countryCode = userAddress[index].countryCode;
      countryCode2 = userAddress[index].alternateCountryCode;
      update();
    } catch (e) {
      print("exception in getEditAddress " + e.toString());
    }
  }

  updateUserAddress(int id) async {
    UserAddressModel userAddressModel = UserAddressModel(
      userId: global.sp!.getInt("currentUserId") ?? 0,
      name: nameController.text,
      phoneNumber: phoneController.text,
      phoneNumber2: alternatePhoneController.text,
      flatNo: flatNoController.text,
      locality: localityController.text,
      landmark: landmarkController.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      pincode: int.parse(pinCodeController.text),
      countryCode: countryCode,
      alternateCountryCode: countryCode2,
    );
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.updateAddress(id, userAddressModel).then((result) {
          if (result.status == "200") {
            global.showToast(
              message: 'Your address have been updated',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          } else {
            global.showToast(
              message: '',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  List daanProducts = <DaanModel>[];



  Future<void> getDaanProducts() async {
    try {
      var headers = {
        'Cookie': 'PHPSESSID=4hel67r0ilbcvijnbcm3tqt7v2',
        'Content-Type': 'application/json',  // Add this if needed
      };
      var request = http.Request('POST', Uri.parse('https://invoidea.work/astrokalp/api/get-daan-products'));
      request.headers.addAll(headers);
      print('Request URL getDaanProducts: ${request.url}');
      print('Request Headers getDaanProducts: ${request.headers}');
      http.StreamedResponse response = await request.send();
      print('Response Status Code getDaanProducts : ${response.statusCode}');

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('Response Body getDaanProducts : $responseBody');

        var jsonData = json.decode(responseBody);

        // Update the global daanProducts list with the parsed data
        daanProducts = (jsonData['recordList'] as List)
            .map((item) => DaanModel.fromJson(item))
            .toList();

        // Print the names of all the products in the list
        print('Daan Products: ${daanProducts.map((e) => e.name).toList()}');
        print(daanProducts.length);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Exception getDaanProducts: $e');
    }
  }
  List daanProductDetails = <DaanModel>[];
  Future<void> getDaanProductsDetails(String? slug) async {
    global.showOnlyLoaderDialog(Get.context);
    update();
    try {
      var headers = {
        'Cookie': 'PHPSESSID=${getAuthorizationToken()}',
        'Content-Type': 'application/json', // Add this if needed
      };
      var request = http.Request(
          'POST', Uri.parse('https://invoidea.work/astrokalp/api/get-daan-products-details?slug=$slug'));
      request.headers.addAll(headers);

      print('Request URL getDaanProductsDetails: ${request.url}');
      print('Request Headers getDaanProductsDetails: ${request.headers}');

      http.StreamedResponse response = await request.send();
      print('Response Status Code getDaanProductsDetails: ${response.statusCode}');

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('Response Body getDaanProductsDetails: $responseBody');

        var jsonData = json.decode(responseBody);

        // Clear the list before filling it with fresh data
        daanProductDetails.clear();

        // Safely parse the list
        if (jsonData['recordList'] != null && jsonData['recordList'] is List) {
          daanProductDetails = (jsonData['recordList'] as List)
              .map((item) => DaanModel.fromJson(item))
              .toList();

          // Print the names of all the products in the list
          print('Daan getDaanProductsDetails: ${daanProductDetails.map((e) => e.name).toList()}');
          print('Total products: ${daanProductDetails.length}');
        } else {
          print('Error: recordList is null or not a List');
          daanProductDetails = [];
        }
      } else {
        print('Error getDaanProductsDetails: ${response.reasonPhrase}');
        daanProductDetails = []; // Ensure the list is empty on failure
      }
    } catch (e) {
      // Handle any errors during the request
      print('Exception getDaanProductsDetails: $e');
      daanProductDetails = []; // Ensure the list is empty on exception
    }
    global.hideLoader();
    update();
  }



  List poojaProducts = <PoojaModel>[];
  Future<void> getPoojaProducts() async {
    try {
      var headers = {
        'Cookie': 'PHPSESSID=${getAuthorizationToken()}',
        'Content-Type': 'application/json',  // Add this if needed
      };
      var request = http.Request('POST', Uri.parse('${baseUrl}/get-puja-products'));
      request.headers.addAll(headers);
      print('Request URL poojaProducts: ${request.url}');
      print('Request Headers poojaProducts: ${request.headers}');
      http.StreamedResponse response = await request.send();
      print('Response Status Code poojaProducts : ${response.statusCode}');

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('Response Body poojaProducts : $responseBody');
        var jsonData = json.decode(responseBody);

        poojaProducts = (jsonData['recordList'] as List)
            .map((item) => PoojaModel.fromJson(item))
            .toList();

        print('poojaProducts Products: ${poojaProducts.map((e) => e.name).toList()}');
        print(poojaProducts.length);
      } else {
        print('Error: poojaProducts ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Exception poojaProducts: $e');
    }
  }

  List poojaProductDetails = <PoojaModel>[]; // Initialize as an empty list

  Future<void> getPoojaProductsDetails(String? slug) async {
    global.showOnlyLoaderDialog(Get.context);
    update();
    try {
      var headers = {
        'Cookie': 'PHPSESSID=9ho9sa1vl67rc39larcrp4mlo1; XSRF-TOKEN=eyJpdiI6Im1iWjhlTW1URGxpTktGM2prc1JvSGc9PSIsInZhbHVlIjoidlZobHdkcGs4RWNBYjhLOE1xZ1dwL3ZibnRkTHFJcUFYVVpXM3dMemhWV3M0ZnBGNlI3ZGNPUjNSS2k5WnRVbFhXUUVtWU1SNHVoMUNGN1F5UjdYQTBucXFLYUwwSVh2NjhpMjFmMytua1plcG1jRFEvVXBQdDRpbjBTM2Z3S3MiLCJtYWMiOiI1MDY4NTgxMTY3MmI4NjZhZDVmZjJhNDBmNDIxODQ5NDQyMTFjMzNkZjViMTZkZjUyZWViYmNkMDJjZTYxYmFhIiwidGFnIjoiIn0%3D; astrokalp_session=eyJpdiI6ImJjdmlMdXZzNDhqTk5yOGpOVVhxaFE9PSIsInZhbHVlIjoiejlsa1VqUUZqUENXWHRMeXM3NTVUOWRTVktPVWc5RjhXNkVRc25FZW5oeGloRjBSbC8wL25ZZnBreDVFSXNvSzZWUXJlYWxJZ3VCa0Vra1grWlZtMzhrRnVjTE1PV3dzbE9MaVNwK0lLR3M3OFc3NnBXb3p4U3IwSVdKVFVPd1QiLCJtYWMiOiI3MzNhZmU2NjM3Yzk3NDAxNDI3NTgxNjM5NzNiNWJkMTQ3Y2FjZjUxYjUxNGZjM2E5MDFiOWQxODNmZTgyNjAxIiwidGFnIjoiIn0%3D',
        'Content-Type': 'application/json', // Add this if needed
      };

      var request = http.Request(
          'POST', Uri.parse('https://invoidea.work/astrokalp/api/get-puja-products-details?slug=$slug'));
      request.headers.addAll(headers);

      print('Request URL poojaProductDetails: ${request.url}');
      print('Request Headers poojaProductDetails: ${request.headers}');

      http.StreamedResponse response = await request.send();
      print('Response Status Code poojaProductDetails: ${response.statusCode}');

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('Response Body poojaProductDetails: $responseBody');

        var jsonData = json.decode(responseBody);

        // Clear the list before populating it
        poojaProductDetails.clear();

        // Safely parse the list
        if (jsonData['recordList'] != null && jsonData['recordList'] is List) {
          poojaProductDetails = (jsonData['recordList'] as List)
              .map((item) => PoojaModel.fromJson(item))
              .toList();

          // Print the names of all the products in the list
          print('Pooja Product Names: ${poojaProductDetails.map((e) => e.name).toList()}');
          print('Total poojaProductDetails: ${poojaProductDetails.length}');
        } else {
          print('Error: recordList is null or not a List');
          poojaProductDetails = [];
        }
      } else {
        print('Error poojaProductDetails: ${response.reasonPhrase}');
        poojaProductDetails = [];
      }
    } catch (e) {
      // Handle any errors during the request
      print('Exception poojaProductDetails: $e');
      poojaProductDetails = []; // Ensure the list is empty on exception
    }
    global.hideLoader();
    update();
  }







}
