
#include <iostream>
using namespace std;

class Student {
private:
    string name;
    int *ptr;
public:
    Student(unsigned newId);
    Student(const Student &obj);
    ~Student();
    
    string getName();
    void setName(string name);
    friend void prtPrivate(Student st);
    
protected:
    int age;
    unsigned id;
};

class Student2: Student {
public:
    int getAge();
    void setAge(int newAge);
};

Student::Student(unsigned newId ): id(newId) {
    cout << "Object is being created ID:" << id << endl;
    ptr = new int;
    *ptr = newId;
}
Student::Student(const Student &obj) {
    cout << "copy!"<< endl;
    ptr = new int;
    *ptr = *obj.ptr;
}
Student::~Student(){
    cout << "Object is being deleted" << endl;
    delete ptr;
}

string Student:: getName() { return name; }
void Student:: setName(string newName){ name = newName; }
int Student2:: getAge() { return age; }
void Student2::setAge(int newAge){ age = newAge; }

void prtPrivate(Student st) {
    cout << st.name << endl;
}
void display(Student st) {
    cout << st.getName()<< endl;
}

int main(int argc, const char * argv[]) {
    Student student(001);
    student.setName("tom");
    display(student);
    Student *st;
    st = &student;
    cout << st->getName()<< endl;
    return 0;
}
