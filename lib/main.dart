import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Entry point for the application
void main() => runApp(const GetMaterialApp(
      home: CalculateScreen(),
      debugShowCheckedModeBanner: false,
    ));


/// Controller class for functions and data keeping
class Controller extends GetxController {

  RxDouble height = 0.0.obs;
  RxDouble weight = 0.0.obs;
  RxnDouble bmi = RxnDouble(null);

  RxnString heightError = RxnString(null);
  RxnString weightError = RxnString(null);

  RxnString info = RxnString(null);


  /// Check user inputted height is valid or not.
  /// If it is valid, update [height]
  /// Otherwise update [heightError] 
  void heightChanged(String value) {
    onInputChanged();

    try{
      height.value = double.parse(value);

      if(height.value < 0.01 || height.value > 3.0) {
        heightError.value = "Invalid height! Height should be between 0.01 m and 3.0 m.";
      }else {
        heightError.value = null;
      }

    }catch (e){
      heightError.value = "Invalid height! Height should be a number.";
    }

  }
  
  /// Check user inputted weight is valid or not.
  /// If it is valid, update [weight]
  /// Otherwise update [weightError]
  void weightChanged(String value) {
    onInputChanged();

    try{
      weight.value = double.parse(value);

      if (weight.value < 0.1 || weight.value > 500.0) {
        weightError.value = "Invalid weight. Weight should be between 0.1 kg and 500.0 kg.";
      }else {
        weightError.value = null;
      }

    }catch (e){
      weightError.value = "Invalid weight! Weight should be a number.";
    }

  }
  
  /// Reset calculated values ([info], [bmi]) when user input is changed
  void onInputChanged() {
    info.value = null;
    bmi.value = null;
  }

  /// Calculate BMI of user and update [bmi] and [info]
  /// If user input is invalid, show error message using [GetSnackBar]
  void calculateBMI(){

      if(height.value == 0.0) {
        GetSnackBar snackBar = const GetSnackBar(
          title: "Invalid input!",
          message: "Height should be between 0.01 m and 3.0 m",);
        Get.showSnackbar(snackBar);

        return;
      }
      if(weight.value == 0.0) {
        GetSnackBar snackBar = const GetSnackBar(
          title: "Invalid input!",
          message: "Weight should be between 0.1 kg and 500.0 kg",);
        Get.showSnackbar(snackBar);

        return;
      }

      if(heightError.value != null) {
        GetSnackBar snackBar = GetSnackBar(
          title: "Invalid input!",
          message: heightError.value ?? "",);
        Get.showSnackbar(snackBar);

        return;
      }
      if(weightError.value != null) {
        GetSnackBar snackBar = GetSnackBar(
          title: "Invalid input!",
          message: weightError.value ?? "",);
        Get.showSnackbar(snackBar);

        return;
      }

      bmi.value = weight.value / pow(height.value, 2);

      double result = bmi.value ?? -1;
      if (result == -1) return;

      info.value = findCategory(result);
    }

  /// Return BMI category based on calculated BMI value
  static String? findCategory(double bmi) {

    switch (bmi){
      
      case < 16.0:
        return "Severe undernourishment";

      case < 17.0:
        return "Medium undernourishment";
    
      case < 18.5:
        return "Slight undernourishment";

      case < 25.0:
        return "Normal nutrition state";
    
      case < 30.0:
        return "Overweight";

      case < 40.0:
        return "Obesity";

      case >= 40.0:
        return "Pathological obesity";
    }

    return null;
  }

}

/// Calculates the BMI screen
class CalculateScreen extends StatelessWidget {
  const CalculateScreen({super.key});

  @override
  Widget build(context) {
    final Controller controller = Get.put(Controller());

    return Scaffold(
        appBar: AppBar(
          title: const Text("Calculate your BMI"),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(
                    () {
                  return TextFormField(
                      onChanged: controller.heightChanged, // controller func
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: "Height (m)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText: controller.heightError.value // obs
                      )
                  );
                },
              ),
              const SizedBox(height: 16,),
              Obx(
                    () {
                  return TextFormField(
                      onChanged: controller.weightChanged, // controller func
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: "Weight (kg)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText: controller.weightError.value // obs
                      )
                  );
                },
              ),
              const SizedBox(height: 16,),
              Center(
                  child: ElevatedButton(
                      child: Text("Calculate"), onPressed: () => controller.calculateBMI())),
              const SizedBox(height: 8,),
              Obx(
                    () {
                      return Text(controller.bmi.value == null ? "" : "Your BMI is ${controller.bmi.value?.toStringAsFixed(2)} kg m⁻²");
                },
              ),
              const SizedBox(height: 8,),

              Center(
                child: Obx(
                      () {
                        return ElevatedButton(
                            onPressed: controller.info.value == null ? null : () => Get.to(InformationScreen()),
                            child: const Text("View information"));
                      }
                )),
          ],),
        ),
    );
  }
}

/// Displays BMI based category of the user
class InformationScreen extends StatelessWidget {
  final Controller c = Get.find();

  InformationScreen({super.key});

  @override
  Widget build(context) {

    return Scaffold(
        appBar: AppBar(title: const Text("Information screen")),
        body: Center(
            child: Obx(
                  () { return Text(c.info.value ?? "Not calculated yet.");},
            ),
        )
    );
  }
}
