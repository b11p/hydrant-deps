import os
from github.ContentFile import ContentFile
import requests
from github import Github
import json


class HydrantDepsInfo:
    EdgeETag = ""
    DockerImageHash = ""


def get_edge_etag():
    r = requests.head(
        "https://packages.microsoft.com/repos/edge/dists/stable/main/binary-amd64/Packages")
    etag = r.headers["ETag"]
    print(etag)
    return etag


def get_dotnet_dockerfile_hash():
    g = Github()
    dockerfile = g.get_repo(
        "dotnet/dotnet-docker").get_contents("src/runtime/8.0/bookworm-slim/amd64/Dockerfile")
    if not isinstance(dockerfile, ContentFile):
        dockerfile = dockerfile[0]
    print(dockerfile.sha)
    return dockerfile.sha

# First create a Github instance:


# using an access token
token = os.getenv('GITHUB_TOKEN')
g = Github(token)

newDeps = dict(EdgeETag=get_edge_etag(),
               DockerImageHash=get_dotnet_dockerfile_hash())

repo = g.get_repo("b11p/hydrant-deps")
content = repo.get_contents("deps-version")
if not isinstance(content, ContentFile):
    if content.count() > 0:
        content = content[0]
    else:
        content = None
if isinstance(content, ContentFile):
    oldDeps = json.loads(content.decoded_content)
    if newDeps == oldDeps:
        print("No change.")
        exit()

sha = content.sha if isinstance(content, ContentFile) else "x"
newJson = json.dumps(newDeps).encode("utf-8")

print("Updating...")
repo.update_file("deps-version", "New version-from v2", newJson, sha)
print("Updated.")