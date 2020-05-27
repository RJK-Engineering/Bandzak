$hash = echo 'metadatakey=value\nmetadatakey2=value' | git hash-object -w --stdin
"Blob object: $hash"

$path = 'dir/file.ext'
"Path: $path"
git update-index --add --cacheinfo 100644 $hash $path

$tree = git write-tree
"Tree object: $tree"

$message = "first commit"
"Commit message: $message"
# $commithash = echo $message | git commit-tree $tree
$commithash = git commit-tree $tree -m "$message"
"Commit object: $commithash"
