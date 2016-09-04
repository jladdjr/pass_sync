#!/bin/bash

# Pass Sync
# 
# Merges remote password store into local password store.
# (See https://www.passwordstore.org/ for information on pass,
#  the standard unix password manager)
#
# Author: Jim Ladd, jladdjr@gmail.com
# Date:   9/4/2016
# Site:   https://github.com/jladdjr/pass_sync

LOCAL_HOME=""   # Local home directory (e.g. /Users/hal)
REMOTE_HOST=""  # Remote host (e.g. dave@10.0.0.1) 
REMOTE_HOME=""  # Remote home directory (e.g. /Users/dave)
PASS="/usr/local/bin/pass"

BOLD=$(tput bold)
NORMAL=$(tput sgr0)

exec 2>&1  # Send stderr to stdout

echo "${BOLD}[PASS SYNC]${NORMAL}"
date

# Remove old files
rm -rf ${LOCAL_HOME}/.password-store.bak
rm -rf /tmp/.password-store
rm -f /tmp/pass.orig
rm -f /tmp/pass.updated

# Save snapshot of current store
$PASS > /tmp/pass.orig
HEAD=$(pass git log -1 --format=%H)

# Create backup
cp -r ${LOCAL_HOME}/.password-store ${LOCAL_HOME}/.password-store.bak &>/dev/null

# Copy remote password store
echo -e "\n${BOLD}Syncing${NORMAL}"
echo "Connecting to ${REMOTE_HOST}"
scp -q -r ${REMOTE_HOST}:${REMOTE_HOME}/.password-store /tmp

if [ "$?" != "0" ]; then
    echo "ERROR: Failed to connect"
    exit 1
fi

# Update local password store
echo -e "\n${BOLD}Updating${NORMAL}"
pushd . &>/dev/null
cd ${LOCAL_HOME}/.password-store
git pull --no-edit /tmp/.password-store/.git

# If merge failed, revert
if [ "$?" != 0 ]; then
    echo "ERROR: Merge failed"
    echo -e "\n${BOLD}Revert${NORMAL}"
    git reset --hard $HEAD
fi

popd &>/dev/null

# Save snapshot of updated store
$PASS > /tmp/pass.updated
UPDATED_HEAD=$(pass git log -1 --format=%H)

# Compare changes in store
echo -e "\n${BOLD}Summary${NORMAL}"
diff -u /tmp/pass.orig /tmp/pass.updated
if [ "$?" = "0" ]; then
    if [ "${HEAD}" = "${UPDATED_HEAD}" ]; then
        echo "No changes"
    else
        echo "Passwords updated"
    fi
fi
