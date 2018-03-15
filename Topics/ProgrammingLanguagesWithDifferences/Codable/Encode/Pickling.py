import json
class Student(object):
    def __init__(self, name, age, score):
        self.name = name
        self.age = age
        self.score = score

s = Student('Bob', 20, 88)
json = json.dumps(s, default = lambda obj: obj.__dict__,sort_keys = True,indent = 4)
