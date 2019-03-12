
notes
this uses wget
we keep the installer that we download so that the updater can check the current version.

for full automation, use windows task scheduler to run this like once a month or something
the only issue is that once the script starts the install, the user needs to confirm to allow the installation to proceed.

--------------------------------------------------------------------------------
CHANGELOG
--------------------------------------------------------------------------------
3/12/19 - 0.25
-updated wget to 1.20 from eternallybored.org
-updated BETAstandarddownloader.bat

3/29/16 - 0.22
-added a case that checks for "downloadfile" which is downloaded in place of the slim installer when the Piriform website has not yet updated its slim installer. The script now returns an error, deletes the "downloadfile" (to prevent a detection of a wrong version) and then exits and returns 0x1.

12/30/15 - 0.21
-added a case where if wget is unable to resolve, the batch would stop and return 0x1. This is intended for use with Windows Task Scheduler
-removed extra pauses and echos in removetask.bat

12/30/15 - 0.20
-optimized script
	-script no longer runs the installer if no new file was downloaded
-added batch files to add and remove tasks in windows task scheduler (WIP)

12/28/15 - 0.11
-added directory structure

12/28/15 - 0.10
-initial version

--------------------------------------------------------------------------------
RESOURCES
--------------------------------------------------------------------------------
i used this to finger out how to match the setup file
http://stackoverflow.com/questions/39615/how-to-loop-through-files-matching-wildcard-in-batch-file

this is piriforms site on the command line parameters of the installer
http://www.piriform.com/docs/ccleaner/advanced-usage/command-line-parameters

wget is from eternally bored
https://eternallybored.org/misc/wget/