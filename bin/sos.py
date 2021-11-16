import os
import sys

print("* sys.argv:\n%s" % sys.argv)
print("* sys.path:\n%s" % ('\n').join(sys.path))
print("* CWD:\n%s" % os.getcwd())
print("* find . -maxdepth 3:")
os.system("find . -maxdepth 3")
