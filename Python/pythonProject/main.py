#!/usr/bin/env python3
list = list(range(10))

list.append([2, True])
list1 = [1, 'hello']
list.extend(list1)
del list[0: 5: 1]
print(list)
