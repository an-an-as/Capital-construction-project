import json

class Student(object):
    def __init__(self, name, age, score):
        self.name = name
        self.age = age
        self.score = score

json_str = '{"age": 20, "score": 88, "name": "Bob"}'

def handle(d):
    return Student(d['name'], d['age'], d['score'])

result = json.loads(json_str, object_hook=handle)
