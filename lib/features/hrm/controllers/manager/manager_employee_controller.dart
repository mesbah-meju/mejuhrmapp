import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/features/hrm/models/manager_models.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ManagerEmployeeController extends GetxController {
  static ManagerEmployeeController get instance => Get.isRegistered<ManagerEmployeeController>()
      ? Get.find<ManagerEmployeeController>()
      : Get.put(ManagerEmployeeController());

  final HrmApiService _apiService = HrmApiService.instance;

  // Observables
  final isLoading = false.obs;
  final isOptionsLoading = false.obs;
  final isSubmitting = false.obs;

  final activeEmployees = <ManagerEmployeeModel>[].obs;
  final disabledEmployees = <ManagerEmployeeModel>[].obs;
  final options = Rxn<EmployeeOptionsModel>();

  // Filter & Search states
  final searchQuery = ''.obs;
  final selectedBranchId = Rxn<int>();
  final selectedDepartmentId = Rxn<int>();
  final selectedTab = 0.obs; // 0 = Active, 1 = Disabled

  @override
  void onInit() {
    super.onInit();
    fetchOptions();
    fetchEmployees();
  }

  /// Load options for dropdowns
  Future<void> fetchOptions() async {
    isOptionsLoading.value = true;
    try {
      final response = await _apiService.getEmployeeOptions();
      if (response.isSuccess && response.data != null) {
        options.value = response.data;
      }
    } catch (e) {
      debugPrint("Error fetching employee options: $e");
    } finally {
      isOptionsLoading.value = false;
    }
  }

  /// Fetch both active and disabled staff or based on filter
  Future<void> fetchEmployees() async {
    isLoading.value = true;
    try {
      // 1. Fetch Active Staff
      final activeRes = await _apiService.getManagerEmployees(
        search: searchQuery.value,
        status: 'active',
        branchId: selectedBranchId.value,
        departmentId: selectedDepartmentId.value,
      );
      if (activeRes.isSuccess && activeRes.data != null) {
        activeEmployees.assignAll(activeRes.data!.employees);
      }

      // 2. Fetch Disabled Staff
      final disabledRes = await _apiService.getManagerEmployees(
        search: searchQuery.value,
        status: 'disabled',
        branchId: selectedBranchId.value,
        departmentId: selectedDepartmentId.value,
      );
      if (disabledRes.isSuccess && disabledRes.data != null) {
        disabledEmployees.assignAll(disabledRes.data!.employees);
      }
    } catch (e) {
      debugPrint("Error fetching employees: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Search query updater
  void onSearchChanged(String query) {
    searchQuery.value = query;
    fetchEmployees();
  }

  /// Filter updater
  void filterByBranch(int? branchId) {
    selectedBranchId.value = branchId;
    fetchEmployees();
  }

  void filterByDepartment(int? deptId) {
    selectedDepartmentId.value = deptId;
    fetchEmployees();
  }

  /// Generated Employee ID from server options
  String get generatedEmployeeId => options.value?.generatedEmployeeId ?? '';

  /// Cascading: Filter departments for a specific branch
  List<DepartmentOption> getDepartmentsForBranch(int? branchId) {
    final allDepts = options.value?.departments ?? [];
    if (branchId == null || branchId == 0) {
      return allDepts;
    }
    return allDepts.where((d) => d.branchId == null || d.branchId == branchId).toList();
  }

  /// Cascading: Filter designations for a specific department and branch
  List<DesignationOption> getDesignationsForDepartment(int? deptId, {int? branchId}) {
    final allDesigs = options.value?.designations ?? [];
    if (deptId == null || deptId == 0) {
      if (branchId != null && branchId != 0) {
        return allDesigs.where((d) => d.branchId == null || d.branchId == branchId).toList();
      }
      return allDesigs;
    }
    return allDesigs.where((d) => d.departmentId == null || d.departmentId == deptId).toList();
  }

  /// Fetch full details for a single employee
  Future<ManagerEmployeeModel?> fetchEmployeeDetail(int id) async {
    try {
      final res = await _apiService.getManagerEmployee(id);
      if (res.isSuccess && res.data != null) {
        return res.data;
      }
    } catch (e) {
      debugPrint("Error fetching employee detail: $e");
    }
    return null;
  }

  /// Delete an uploaded employee document
  Future<bool> deleteDocument(int employeeId, int documentId) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.deleteEmployeeDocument(employeeId, documentId);
      isSubmitting.value = false;
      if (res.isSuccess) {
        THelperFunctions.showSnackBar("Document removed successfully.");
        fetchEmployees();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Failed to delete document.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("Error deleting document: $e");
      return false;
    }
  }

  /// Create / Add New Staff
  Future<bool> createEmployee(Map<String, dynamic> data) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.createEmployee(data);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Employee created successfully!");
        fetchEmployees();
        fetchOptions(); // update next auto-generated id
        return true;
      } else {
        String errorDetail = res.message;
        if (res.errors != null && res.errors is Map) {
          final errorMap = res.errors as Map;
          final errorLines = <String>[];
          errorMap.forEach((key, val) {
            if (val is List) {
              errorLines.add(val.join(', '));
            } else {
              errorLines.add(val.toString());
            }
          });
          if (errorLines.isNotEmpty) {
            errorDetail = errorLines.join('\n');
          }
        }
        THelperFunctions.showSnackBar(errorDetail.isNotEmpty ? errorDetail : "Failed to create employee.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  /// Edit / Update Staff
  Future<bool> updateEmployee(int id, Map<String, dynamic> data) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.updateEmployee(id, data);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Employee updated successfully!");
        fetchEmployees();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Failed to update employee.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  /// Toggle Active / Disabled Status
  Future<bool> toggleEmployeeStatus(ManagerEmployeeModel employee) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.toggleEmployeeStatus(employee.id);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Status changed successfully!");
        fetchEmployees();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Failed to toggle status.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  /// Change / Reset Password
  Future<bool> resetEmployeePassword(int id, String password, String confirmation) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.changeEmployeePassword(
        id: id,
        password: password,
        passwordConfirmation: confirmation,
      );
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Password reset successfully!");
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Failed to reset password.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  /// Delete Employee
  Future<bool> deleteEmployee(int id) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.deleteEmployee(id);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Employee deleted successfully!");
        fetchEmployees();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Failed to delete employee.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }
}
