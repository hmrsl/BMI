import 'package:flutter_test/flutter_test.dart';

import 'package:end/main.dart';

void main() {

  group("BMI category | Severe undernourishment", () {
    test("BMI = 0.0", () => expect(Controller.findCategory(0.0), "Severe undernourishment"));
    test("BMI = 5.0", () => expect(Controller.findCategory(5.0), "Severe undernourishment"));
    test("BMI = 15.999", () => expect(Controller.findCategory(15.999), "Severe undernourishment"));
  });

  group("BMI category | Medium undernourishment", () {
    test("BMI = 16.0", () => expect(Controller.findCategory(16.0), "Medium undernourishment"));
    test("BMI = 16.999", () => expect(Controller.findCategory(16.999), "Medium undernourishment"));
  });

  group("BMI category | Slight undernourishment", () {
    test("BMI = 17.0", () => expect(Controller.findCategory(17.0), "Slight undernourishment"));
    test("BMI = 18.4", () => expect(Controller.findCategory(18.4), "Slight undernourishment"));
  });

  group("BMI category | Normal nutrition state", () {
    test("BMI = 18.5", () => expect(Controller.findCategory(18.5), "Normal nutrition state"));
    test("BMI = 24.999", () => expect(Controller.findCategory(24.999), "Normal nutrition state"));

  });

  group("BMI category | Overweight", () {
    test("BMI = 25.0", () => expect(Controller.findCategory(25.0), "Overweight"));
    test("BMI = 27.0", () => expect(Controller.findCategory(27.0), "Overweight"));
    test("BMI = 29.999", () => expect(Controller.findCategory(29.999), "Overweight"));
  });
  group("BMI category | Pathological Overweight", () {
    test("BMI = 40.0", () => expect(Controller.findCategory(40.0), "Pathological obesity"));
    test("BMI = 100.0", () => expect(Controller.findCategory(100.0), "Pathological obesity"));
    test("BMI = 41.9", () => expect(Controller.findCategory(41.0), "Pathological obesity"));
  });

}
