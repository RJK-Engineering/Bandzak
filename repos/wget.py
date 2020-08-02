import requests
import sys

url = sys.argv[1]
file = sys.argv[2] if len(sys.argv) > 2 else None

res = requests.get(url)
print(res.status_code)

if file != None:
    f = open(file, "wb")
    f.write(res.content)
    f.close()
else:
    print(res.content)
