class Calculator {

  bool gender;
  int weight;
  int size;
  int age;
  int activity;

  Calculator(bool gender, int weight, int size, int age, int activity) {
    this.activity = activity;
    this.gender = gender;
    this.weight = weight;
    this.age = age;
    this.size = size;
  }
  
  double compute() {
    double result;

    if(this.gender) {
      result = 66.4730 + 13.7516 * this.weight + 5.0033 * this.size - 6.7550 * this.age;
    } else {
      result = 655.0955 + 9.5634 * this.weight + 1.8496 * this.size - 4.6756 * this.age;
    }
    return result;
  }
}