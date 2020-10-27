#!/usr/bin/env python3

password = '1234'
for i in range(3):
    result = input('Input the password: ')
    if result == password:
        print('Login Success')
        break
else:
    print("Locked")