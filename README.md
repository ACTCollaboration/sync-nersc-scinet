Scinet->NERSC nightly sync
==========================

This set of scripts allows us to:

1. ssh into cori.nersc.gov
2. rsync a list of directories from scinet to cori

It is intended as a one-way stream to update the
NERSC ACT project directories with the latest
products (primarily from the mapmakers) from Scinet.


You can open an issue on the github page to add
a directory on Scinet that you would like synced
to NERSC.


Requirements
------------

- localMachine must have keys for Scinet and Cori with SSH Agent Forwarding enabled
- If password-protected (recommended), keys must be in the keyring so no password is requested
- clone of this repo on localMachine
- localMachine must have a cron daemon running, and localScript.sh should be added to nightly
- clone of this repo in user space on Cori

Procedure
---------

To use this yourself, you only need to clone this repo on your local machine and on Cori,
and modify the following files:
- scinetUserName: replace msyriac with your username on Scinet
- nerscUserName: replace msyriac with your username on NERSC/Cori
- nerscPath: path to the directory of this repo on NERSC/Cori, no slash at end

And then add localScript.sh to your nightly (or as desired) cron jobs.

This sets up the following procedure:
- cron on localMachine calls localScript.sh
- localScript.sh schematically does
  `ssh {nerscUserName}@cori.nersc.gov '{nerscPath}/syncScript.sh {nerscPath}/syncList.txt'`
- syncScript.sh on cori reads from syncList.txt line by line for {SRC_DIR} and {DEST_DIR}
- syncScript.sh issues schematically `rsync {scinetUserName}@login.scinet.utoronto.ca:{SRC_DIR} {DEST_DIR}`
  for each line in syncList.txt


Manual sync
-----------

To manually sync, log in to cori and run `{nerscPath}/syncScript.sh {nerscPath}/syncList.txt`.


Warnings and caveats
--------------------

1. If files are being written on Scinet while the rsync is running, the destination files on
   NERSC may get corrupted. If this was the case, you just need to manually sync as described
   above and rsync will take care of the rest.
   
2. By default, the $DEL_FLAG="--delete" is disabled in syncScript.sh. Enabled, this flag deletes
   files on Cori that are not in the corresponding Scinet directory. However, if you mess up the
   destination directory on Cori, this could potentially delete parent directories with unrelated
   project files. That's bad. So I've disabled it. This means that old files that are no longer in
   the Scinet directories will be retained in the Cori directories. For now, this might be preferable
   to risking total data loss. TODO: provide a script to clean up Cori directories with files older
   than a specified date. TODO: Another way to avoid this is to always check that the destination
   directory is a child of the ACT project directory with no ".." in the path.




