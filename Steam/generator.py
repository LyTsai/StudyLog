import random
class Randable():
    def __init__(self, total):
        self.count = 0
        self.total = total
    
    def __iter__(self):
        return self
    
    def __next__(self):
        if self.count == self.total:
            raise StopIteration
        random_num = random.randint(1, 100)
        self.count += 1
        return random_num
  
def randgen(total):
    for _ in range(0, total):
        yield random.randint(1, 100)

# for i in Randable(20):
#   print(i)
# print('-------------------------')
# for i in randgen(20):
#   print(i)


def filter_odd(numbers):
    for i in range(numbers):
        if i % 2 != 0:
            yield(i)

odd_numbers = filter_odd(20)
print(list(odd_numbers))
for i in list(odd_numbers):
    print(i)