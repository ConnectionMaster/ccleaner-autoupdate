
notes  
this uses wget

for full automation, use windows task scheduler to run this like once a month or something
the only issue is that once the script starts the install, the user needs to confirm to allow the installation to proceed.

## Usage
Use this script to run ccleaner or defraggler portable or use it to install the standard edition of either

```
run.bat [ccleaner | defraggler] [portable | standard]
```
or for update only
```
update.bat [ccleaner | defraggler] [portable | standard] [addtask | removetask]
```

### Automatic Updating
```
update.bat [ccleaner | defraggler] [portable | standard] [addtask | removetask]
```

### In Tronlite
add a command to stage 1 in `settings.ini`

---
### Development Notes
there are some old code snippits in dev_archive

### Resources
- wget 1.20 from https://eternallybored.org/misc/wget/
- 7-Zip 19.00 (2019-02-21) from https://www.7-zip.org/download.html

i used this to finger out how to match the setup file  
http://stackoverflow.com/questions/39615/how-to-loop-through-files-matching-wildcard-in-batch-file

this is piriforms site on the command line parameters of the installer  
http://www.piriform.com/docs/ccleaner/advanced-usage/command-line-parameters
