#include "foo.h"

#include "headeronlylib.h"
#include "nestedlib/nestedlib.h"

#include "bar/bar.h"

#include <iostream>

int main() {
  for (int i { 0 }; i < 10; ++i) {
    std::cout << i << "\n";
  }
  headerOnlyLib::printVersion();
  nestedLib::printVersion();
  Foo footest;
  footest.printFoo();
  Bar bartest;
  bartest.printBar();
  return 0;
}
