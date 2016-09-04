# pass_sync

Merges remote password store into local password store (using the underlying git repositories).

See www.passwordstore.org for information on pass, the standard unix password manager.

### Requirements

* Must call `git init` to initialize git repository in password store
* Local and remote password store repositories must have common root

Script requires information for finding the local and remote password store:

* `LOCAL_HOME`   # Local home directory (e.g. /Users/hal)
* `REMOTE_HOST`  # Remote host (e.g. dave@10.0.0.1) 
* `REMOTE_HOME`  # Remote home directory (e.g. /Users/dave)

### Sample output:

```
[PASS SYNC]
Sun Sep  4 17:10:03 EDT 2016

Syncing
Connecting to dave@192.168.1.100

Updating
From /tmp/.password-store/
 * branch            HEAD       -> FETCH_HEAD
Updating 98f9936..8fc3530
Fast-forward
 amazon.gpg | Bin 0 -> 579 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 amazon.gpg

Summary
--- /tmp/pass.orig	2016-09-04 17:10:03.000000000 -0400
+++ /tmp/pass.updated	2016-09-04 17:10:06.000000000 -0400
@@ -1,4 +1,5 @@
 Password Store
+├── amazon
 ├── bank
 ├── email
 └── twitter
```
