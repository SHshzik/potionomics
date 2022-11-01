import csv
import sys
import random
import math
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
ga.population_size = 5000

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

def solveThreeRatio(ratio):
    A = ratio[0][1] * ratio[1][1]
    B = ratio[1][1] * ratio[1][1]
    C = ratio[1][1] * ratio[2][1]

    # To print the given proportion
    # in simplest form.
    gcd1 = math.gcd(math.gcd(A, B), C)

    return A // gcd1 == ratio[0][0] and B // gcd1 == ratio[1][0] and C // gcd1 == ratio[2][0]

def solveTwoRatio(ratio):
    ratio[0][1] == ratio[1][1]

def is_ideal(a, b, c, d, e):
    magimin = [a, b, c, d, e]
    ratio = [[r, magimin[index]] for index, r in enumerate(receipt) if r > 0]
    if len(ratio) == 2:
        return solveTwoRatio(ratio)
    if len(ratio) == 3:
        return solveThreeRatio(ratio)

def check_ratio(a, b, c, d, e):
    receipt_sum = sum(receipt)
    magimin = [a, b, c, d, e]
    magimin_sum = sum(magimin)
    if receipt_sum == 2:
        return all([magimin[index] / magimin_sum * 100 < 60 and magimin[index] / magimin_sum > 35 for index, r in enumerate(receipt) if r > 0])
    if receipt_sum == 4:
        return all([
            magimin[index] / magimin_sum * 100 < 30 and magimin[index] / magimin_sum * 100 > 18 if r == 1 else
            magimin[index] / magimin_sum * 100 < 60 and magimin[index] / magimin_sum * 100 > 35
            for index, r in enumerate(receipt)
            if r > 0
        ])
    if receipt_sum == 10:
        return all([
            magimin[index] / magimin_sum * 100 < 40 and magimin[index] / magimin_sum * 100 > 22 if r == 3 else
            magimin[index] / magimin_sum * 100 < 50 and magimin[index] / magimin_sum * 100 > 29
            for index, r in enumerate(receipt)
            if r > 0
            ])

def fitness(individual, data):
    a, b, c, d, e, price, weight = 0, 0, 0, 0, 0, 0, 0
    value = 0
    if individual.count(1) == capacity: # TODO: check - needed this? create_individual can fix this
        for (selected, item) in zip(individual, data):
            if selected:
                a += item[0]
                b += item[1]
                c += item[2]
                d += item[3]
                e += item[4]
                price += item[5]
                weight += item[0] + item[1] + item[2] + item[3] + item[4]
                value += weight * (weight / price)
        mixins = calculate_mixins(a, b, c, d, e)
        if ((max_a > 0 and a > max_a) or
            (max_b > 0 and b > max_b) or
            (max_c > 0 and c > max_c) or
            (max_d > 0 and d > max_d) or
            (max_e > 0 and e > max_e)):
            value = 0
        if not check_ratio(a, b, c, d, e):
            value = 0
        if weight > 0 and ((mixins / float(weight)) * 100 > 15):
            value = 0
        if weight > (max_a + max_b + max_c + max_d + max_e):
            value = 0
        if mixins == 0 and is_ideal(a, b, c, d, e):
            value *= 1.3
    return value

ga.fitness_function = fitness

if __name__ == '__main__':
    ga.run()

    result = ga.best_individual()
    for idx, x in enumerate(result[1]):
        if x == 1:
            ingredient = data[idx]
            print('{name},1'.format(name=ingredient[6]))
