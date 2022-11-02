import csv
import sys
import random
import math
import fractions
from pyeasyga import pyeasyga

capacity = int(sys.argv[1])
max_a = int(sys.argv[2])
max_b = int(sys.argv[3])
max_c = int(sys.argv[4])
max_d = int(sys.argv[5])
max_e = int(sys.argv[6])
receipt = sys.argv[7]
receipt = list(map(lambda x: int(x), receipt.split(',')))

a_ration = receipt[0]
b_ration = receipt[1]
c_ration = receipt[2]
d_ration = receipt[3]
e_ration = receipt[4]

data = []
with open('temp.csv', 'r') as file:
    data = [[int(i) if i.lstrip("-").isdigit() else i for i in row] for row in csv.reader(file)]

ga = pyeasyga.GeneticAlgorithm(data)
ga.population_size = 20000

def create_individual(data):
    rand = random.sample(data, capacity)
    return [1 if _ in rand else 0 for _ in range(len(data))]

ga.create_individual = create_individual

def calculate_mixins(a, b, c, d, e):
    mixins = 0
    if max_a == 0:
        mixins += a
    if max_b == 0:
        mixins += b
    if max_c == 0:
        mixins += c
    if max_d == 0:
        mixins += d
    if max_e == 0:
        mixins += e
    return mixins

def fitness(individual, data):
    a, b, c, d, e, price, weight = 0, 0, 0, 0, 0, 0, 0
    value = 0
    if individual.count(1) == capacity:
        for (selected, item) in zip(individual, data):
            if selected:
                a += item[0]
                b += item[1]
                c += item[2]
                d += item[3]
                e += item[4]
                weight += item[0] + item[1] + item[2] + item[3] + item[4]
                value += weight # item[0] + item[1] * 0.1 + item[2] * 0.1 + item[3] + item[4] * 0.1
        mixins = calculate_mixins(a, b, c, d, e)
        value *= (1 - (mixins / float(weight)))
        if ((max_a > 0 and a > max_a) or
            (max_b > 0 and b > max_b) or
            (max_c > 0 and c > max_c) or
            (max_d > 0 and d > max_d) or
            (max_e > 0 and e > max_e)):
            value = 0
        if value > 0 and weight > (max_a + max_b + max_c + max_d + max_e):
            value = 0
        if value > 0 and weight > 0 and ((mixins / float(weight)) * 100 > 25):
            value = 0
    return value

ga.fitness_function = fitness

if __name__ == '__main__':
    ga.run()

    result = ga.best_individual()
    for idx, x in enumerate(result[1]):
        if x == 1:
            ingredient = data[idx]
            print('{name},1'.format(name=ingredient[6]))
