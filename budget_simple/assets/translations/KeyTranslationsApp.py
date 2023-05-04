import json
import codecs
with open('translationsApp.json', encoding='utf-8-sig') as d:
    data = json.load(d)

output = {}
for sheet in data:
    output[sheet] = {}
    if(sheet=="Google Play Store Listing"):
        continue
    for item in data[sheet]:
        if("en" in item.keys()):
            output[sheet][item["en"]] = item
with open('translationsAppKeyed.json', 'w', encoding='utf8') as json_file:
    json.dump(output, json_file, ensure_ascii=False,indent=2)
input("Done!")
