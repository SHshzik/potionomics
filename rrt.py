from pyeasyga import pyeasyga

data = [[8, 0, 0, 0, 0],
        [6, 0, 0, 0, 0],
        [0, 6, 0, 0, 0],
        [0, 8, 0, 0, 0],
        [24, 0, 0, 0, 0],
        [40, 0, 0, 0, 0],
        [0, 18, 0, 0, 0],
        [18, 0, 0, 0, 0],
        [0, 24, 0, 0, 0],
        [30, 0, 0, 0, 0],
        [0, 27, 0, 0, 0],
        [30, 0, 0, 0, 0],
        [0, 30, 0, 0, 0],
        [12, 12, 0, 0, 0],
        [18, 0, 0, 0, 0],
        [0, 30, 0, 0, 0],
        [4, 4, 0, 0, 0],
        [0, 40, 0, 0, 0],
        [0, 12, 0, 0, 0],
        [10, 20, 0, 0, 0],
        [20, 0, 0, 0, 0],
        [12, 0, 0, 0, 0],
        [12, 6, 0, 0, 0],
        [0, 12, 0, 0, 0],
        [20, 20, 0, 0, 0],
        [4, 0, 0, 0, 0],
        [0, 20, 0, 0, 0],
        [0, 4, 0, 0, 0],
        [0, 48, 0, 0, 0],
        [96, 48, 0, 0, 0],
        [16, 0, 0, 0, 0],
        [0, 16, 0, 0, 0],
        [0, 22, 0, 0, 0],
        [32, 32, 0, 0, 0],
        [66, 0, 0, 0, 0],
        [44, 44, 0, 0, 0],
        [132, 66, 0, 0, 0]]

ga = pyeasyga.GeneticAlgorithm(data)
ga.population_size = 20000

# 115

def fitness(individual, data):
    a, b, c, d, e, weight = 0, 0, 0, 0, 0, 0
    if individual.count(1) == 8:
        for (selected, item) in zip(individual, data):
            if selected:
                a += item[0]
                b += item[1]
                c += item[2]
                d += item[3]
                e += item[4]
                weight += (item[0] + item[1])
        if a > 130 or b > 130 :
            weight = 0
    return weight

ga.fitness_function = fitness               # set the GA's fitness function
ga.run()                                    # run the GA

print(ga.best_individual())
# for idx, x in enumerate(result[1]):
#     if x == 1:
#         print(data[idx])
# print(result)
