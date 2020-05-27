snapshot of file metadata in filesystem tree
- per file: properties file with same name as file + .props
  - sorted for effecient diffs

update-index --info-only
does not work, needs content on commit(-tree):
```
git init --separate-git-dir c:\temp\repos\test
git update-index --info-only [path]
// commit throws error
  error: invalid object 100644 e11fb1e80613503532d33eb4a540fab5521efa52 for 'filename'
  error: Error building trees
// create snapshot tree object
git commit-tree
// create commit tree object pointing to tree object
// move head
```

update-index --cacheinfo
iterate files on fs and create objects with same path
```
git init
$hash = echo 'metadatakey=value\nmetadatakey2=value' | git hash-object -w --stdin
$path = 'dir/file.ext.props'
git update-index --add --cacheinfo 100644 $hash $path
$tree = git write-tree
$commithash = echo 'first commit' | git commit-tree d8329f
```

fs init - create repo in repo dir for current fs
fs add [path] - add empty file to repo

master -> commit -> blobtree -> blobs
