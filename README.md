PowerBuilder Foundation Classes

To get the PBLs, fork the project into your own workspace and then do a Connect to Workspace from the PowerBuilder IDE.  That will download all the source and create the PBLs with the latest changes.

<img width="802" height="91" alt="image" src="https://github.com/user-attachments/assets/9948fd63-e0dc-4406-9653-6027cc51effc" />

Once you have forked the project your copy will show you when we have made additional changes and you can sync your fork to update your copy.

<img width="1157" height="80" alt="image" src="https://github.com/user-attachments/assets/1a708200-0ddc-4355-9afe-9800447323bf" />

If you would like to contribute to the project, please watch this video:

https://vimeo.com/478243534

## Building from the command line

`tools\build.ps1` (PowerShell 7) refreshes the PBLs from the source in `ws_objects`, the same as the IDE's refresh, and then builds targets, without opening the IDE. It uses PowerBuilder 2022's PBAutoBuild (`pbautobuild220.exe`) for the refresh and its PBC compiler (`pbc220.exe`) for the build. Close PowerBuilder first, because the IDE keeps the PBLs open.

```
pwsh -File tools\build.ps1                                          # refresh and build the PEAT demo
pwsh -File tools\build.ps1 -Target "peat demo app,security administrator"
pwsh -File tools\build.ps1 -All -Full                               # every target, full compilation
pwsh -File tools\build.ps1 -NoBuild                                 # only refresh the PBLs
```

The targets are the ones listed in `PFC.pbw`. The exe and PBDs go to `build\<target>\`. The script exits with 0 on success, 1 if the refresh or a build fails (compile errors are listed), and 2 if it could not start. The refresh imports every object of a target, so it takes a minute or so; the build is incremental unless you pass `-Full`.

The refresh uses `refresh.json`, a PBAutoBuild build file with a "Merging" entry for each target, which can also be run on its own: `pbautobuild220 /f refresh.json`.
