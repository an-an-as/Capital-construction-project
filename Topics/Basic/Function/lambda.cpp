[]() { cout << "hello, world" << endl; }();

auto f = [](int a) { cout << "hello, world " << a << endl; return a; };
auto k = f(12);

int xxx = 10;
auto f2 = [=]() { cout << "hello, world " << xxx << endl;  };
auto f3 = [&]() { cout << "hello, world " << xxx << endl;  };
auto f4 = [=,&xxx]() { cout << "hello, world " << xxx << endl;  };
auto f5 = [&,xxx]() { cout << "hello, world " << xxx << endl;  };

f2();
f3();
f4();
f5();
