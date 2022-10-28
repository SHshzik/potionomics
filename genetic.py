import csv
import sys
import random
from pyeasyga import pyeasyga

data = []
with open("temp.csv", 'r') as file:
    data = [[int(i) if i.isdigit() else i for i in row] for row in csv.reader(file)]

capacity = int(sys.argv[1])
max_a = int(sys.argv[2])
max_b = int(sys.argv[3])
max_c = int(sys.argv[4])
max_d = int(sys.argv[5])
max_e = int(sys.argv[6])

print(capacity)
print(max_a)
print(max_b)
print(max_c)
print(max_d)
print(max_e)
print(data)

ga = pyeasyga.GeneticAlgorithm(data)
ga.population_size = 5000

def create_individual(data):
    rand = random.sample(data, capacity)
    return [1 if _ in rand else 0 for _ in range(len(data))]

ga.create_individual = create_individual

def fitness(individual, data):
    a, b, c, d, e, weight = 0, 0, 0, 0, 0, 0
    if individual.count(1) == capacity:
        for (selected, item) in zip(individual, data):
            if selected:
                a += item[0]
                b += item[1]
                c += item[2]
                d += item[3]
                e += item[4]
                weight += (item[0] + item[1] + item[2] + item[3] + item[4])
        if a > max_a or b > max_b or c > max_c or d > max_d or e > max_e:
            weight = 0
    return weight

ga.fitness_function = fitness               # set the GA's fitness function

if __name__ == '__main__':
    ga.run()                                 # run the GA

    result = ga.best_individual()
    for idx, x in enumerate(result[1]):
        if x == 1:
            print(data[idx])
    print(result)
