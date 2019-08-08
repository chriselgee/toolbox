#!/usr/bin/python3
import sqlite3
from random import randrange, choice
from hashlib import md5
from os import path

OV = '\x1b[0;33m' # verbose
OR = '\x1b[0;34m' # routine
OE = '\x1b[1;31m' # error
OM = '\x1b[0m'    # mischief managed

# easy MD5 hashing
def md5it(password):
  if (isinstance(password,str)):
    password = password.encode('utf')
  return md5(password).hexdigest()

file_path = path.dirname(path.realpath(__file__))
debuggin = False

if debuggin: print(OV+"Debuggin from builddb!"+OM)

# create a new db on disk
def builddb():
  print(OR+"Creating users.db"+OM)
  dbcon = sqlite3.connect('users.db')
  cur = dbcon.cursor()
  cur.execute('DROP TABLE IF EXISTS users;')
  # create and populate user table
  cur.execute("CREATE TABLE users (userid INTEGER PRIMARY KEY, username, first, last, phonenum, email);")
  dbcon.commit()

  users = []
  userid = randrange(5000000)
  # create users
  try:
    for line in open(file_path+'/users.txt','r'):
      user = []
      user.append(str(userid))
      userid += 1
      user.append(line.rstrip())
      user.append(line.split('.')[0].capitalize().rstrip())
      try:
        user.append(line.split('.')[1].capitalize().rstrip())
      except:
        user.append(line.capitalize().rstrip())
      user.append(str(randrange(2,10))+str(randrange(0,10))+str(randrange(2,10))+'-'+str(randrange(2,10))+str(randrange(0,10))+str(randrange(2,10))+'-'+str(randrange(0,10000)).zfill(4))
      user.append(str(line).rstrip()+'@'+choice(['gmail.com','hotmail.com','protonmail.com','outlook.com','aol.com','yahoo.com','cloud.me']))
      users.append(user)
    cur.executemany("INSERT INTO users VALUES (?,?,?,?,?,?);", users)
  
    dbcon.commit()
    if debuggin: print(OV+"Created users.db"+OM)
    dbcon.close()
  except:
    print(OE+'No users.txt?  Users not in format '+OR+'first.last'+OE+'?')
    print(OR+'Consider getting a good list from https://wiki.skullsecurity.org/Passwords'+OM)

if __name__ == '__main__':
  builddb()
