import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:naibrly/utils/tokenService.dart';
import '../../../models/bundle/bundleGet.dart';
import '../../../utils/app_contants.dart';
import '../../../views/screen/Users/Home/bundle_published_bottomsheet.dart';
import '../../networkService/networkService.dart';

class CreateBundleController extends GetxController{

  RxBool isLoading = false.obs;
  Future<void> createBundle({
    required BuildContext context,
    required String primaryCategory,      // e.g., "Interior"
    required String secondaryCategory,    // e.g., "Home Repairs & Maintenance"
    required List<String> services,       // e.g., ["Plumbing", "Locksmiths"]
    required String serviceDate,          // e.g., "2024-01-20"
    required String serviceTimeStart,     // e.g., "09:00"
    required String serviceTimeEnd,       // e.g., "13:00"
    required String title,
    required String description,
  }) async {
    final String url = '${AppConstants.BASE_URL}/api/bundles/create';
    final networkController = Get.find<NetworkController>();

    if (!networkController.isOnline.value) {
      showError(context, "No internet connection");
      return;
    }

    isLoading.value = true;

    try {
      final token = await TokenService().getToken();
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "category": primaryCategory,
          "categoryTypeName": secondaryCategory,
          "services": services,
          "serviceDate": serviceDate,
          "serviceTimeStart": serviceTimeStart,
          "serviceTimeEnd": serviceTimeEnd,
          "title": title,
          "description": description,
        }),
      );

      // ✅ Guard against using context after widget is disposed
      if (!context.mounted) {
        isLoading.value = false;
        return;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
         final data = jsonDecode(response.body);
         showSuccess(context, "Bundle created successfully!");
         Navigator.pop(context);
         showModalBottomSheet(
           context: context,
           useSafeArea: true,
           backgroundColor: Colors.transparent,
           builder: (context) => const BundlePublishedBottomSheet(),
         );

      } else {
        final errorMsg = response.statusCode == 400 ? "Invalid bundle data" : "Failed to create bundle (${response.statusCode})";
        showError(context, errorMsg);
      }
    } catch (e) {
      if (context.mounted) {
        showError(context, "An error occurred: $e");
      }
    } finally {
      if (context.mounted) {
        isLoading.value = false;
      }
    }
  }

  RxBool bundle= false.obs;
  RxList<Bundle> bundles = <Bundle>[].obs;
  Future<void> getNaibrlyBundle(BuildContext context) async {
    final String url = '${AppConstants.BASE_URL}/api/bundles/customer/nearby'; // 👈 Fixed: missing slash
    final networkController = Get.find<NetworkController>();

    if (!networkController.isOnline.value) {
      showError(context, "No internet connection");
      return;
    }

    try {
      bundle.value = true;
      final token = await TokenService().getToken();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          // 'Content-Type' not needed for GET
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final bundleResponse = BundleListResponse.fromJson(jsonResponse);
        bundles.assignAll(bundleResponse.data.bundles); // ✅ Store in RxList
        print(response.body);
      } else {
        showError(context, "Failed to load bundles");
      }
    } catch (e) {
      bundle.value = false;
      if (context.mounted) {
        showError(context, "Error: $e");
      }
    } finally {
      bundle.value = false;
    }
  }
  final RxString loadingBundleId = "".obs;
  // Replace the joinNaibrlyBundle method in CreateBundleController with this:

// Replace these methods in your CreateBundleController:

// Add a new method to refresh bundles WITHOUT showing loading spinner
  Future<void> refreshBundlesInBackground(BuildContext context) async {
    final String url = '${AppConstants.BASE_URL}/api/bundles/customer/nearby';
    final networkController = Get.find<NetworkController>();

    if (!networkController.isOnline.value) {
      return;
    }

    try {
      // ✅ DON'T set bundle.value = true (no loading spinner)
      final token = await TokenService().getToken();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final bundleResponse = BundleListResponse.fromJson(jsonResponse);
        bundles.assignAll(bundleResponse.data.bundles); // ✅ Update list silently
      }
    } catch (e) {
      // Silently fail - user already got success message
      if (context.mounted) {
        print("Background refresh error: $e");
      }
    }
  }

// Updated joinNaibrlyBundle method
  Future<void> joinNaibrlyBundle(BuildContext context, String id) async {
    final networkController = Get.find<NetworkController>();

    if (!networkController.isOnline.value) {
      showError(context, "No internet connection");
      loadingBundleId.value = "";
      return;
    }

    loadingBundleId.value = id; // 🔥 Set this bundle as loading

    try {
      final token = await TokenService().getToken();
      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}/api/bundles/$id/join'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) {
        loadingBundleId.value = "";
        return;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        showSuccess(context, "Joined bundle successfully!");

        // ✅ Use background refresh instead of getNaibrlyBundle
        await refreshBundlesInBackground(context);
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? "Failed to join bundle";
        showError(context, errorMessage);
      }
    } catch (e) {
      if (context.mounted) {
        showError(context, "Error: $e");
      }
    } finally {
      loadingBundleId.value = ""; // 🔥 Stop loading
    }
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }
  void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  }

}
