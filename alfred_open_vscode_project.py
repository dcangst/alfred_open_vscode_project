''' Get project paths from vscode for Alfred'''

import os.path as osp
import json

storage_path = osp.expanduser("~/Library/Application Support/Code/storage.json")
with open(storage_path, "r") as file:
    vscode_storage=json.load(file)["openedPathsList"]["entries"]

output = { "items": [] }

for item in vscode_storage:
    if "folderUri" in item:
        path = item["folderUri"].replace("file://","")
        title = osp.basename(path)
    elif "workspace" in item:
        path = item["workspace"]["configPath"].replace("file://","")
        title = osp.splitext(osp.basename(path))[0]
    elif "fileUri" in item:
        path = item["fileUri"].replace("file://","")
        title = osp.splitext(osp.basename(path))[0]
    else:
        next

    output["items"].append({
            "title": title,
            "subtitle": path,
            "arg": path,
            "autocomplete": title,
            "icon": {
                 "type": "fileicon",
                 "path": path
            }
        })

print(json.dumps(output))
