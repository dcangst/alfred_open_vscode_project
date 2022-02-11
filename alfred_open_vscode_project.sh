#!/usr/bin/python3
''' Get project paths from vscode for Alfred'''

import os
import os.path as osp
import urllib.parse as parse

import json

storage_path = osp.expanduser("~/Library/Application Support/Code/User/workspaceStorage")

workspaces = []
for root, dirs, files in os.walk(storage_path):
    for file in files:
        if(file.endswith(".json")):
            lastModified = os.path.getmtime(os.path.join(root,file))
            with open(os.path.join(root,file), "r", encoding="utf8") as file:
                item = json.load(file)
                
                if "folder" in item:
                    path = item["folder"].replace("file://","")
                elif "workspace" in item:
                    path = item["workspace"].replace("file://","")
                elif "configuration" in item:
                    path = item["configuration"]["path"]
                else:
                    next
                title = parse.unquote(osp.basename(path))
                if os.path.exists(path):
                    workspaces.append({
                        "title": title,
                        "subtitle": path,
                        "arg": path,
                        "autocomplete": title,
                        "icon": {
                            "type": "fileicon",
                            "path": path
                        },
                        "sortOrder": lastModified
                    })

output = { "items": sorted(workspaces, key=lambda t: -t["sortOrder"])}

print(json.dumps(output))
