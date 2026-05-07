---
lang:
title: ROADMAP
created: 07/05/2026
modified: 07/05/2026
modified_millis: 2026-05-07 12:02
tags: ""
type: journey
---



> [!note] 07/05/2026
> <sub><sub>full-note-tp=beta.4.3</sub></sub>
> # ROADMAP
> > ***TL;DR :***



## **Thursday, 07 May 2026 - 02h -**
> <sub><sub>today-entry-snippet V:beta-4</sub></sub>
> reference : [[•Daily• 07.05.2026 - 2026 May - W19]]
---


Having hyprland setup as an input flake seems to override the nixpkgs version, maybe I removed follows = nixkpgs, whcih would have been relaly silly of me since it broke my entire system and my entire installation and impared my ability to install plugins and congfigure HL for days :D

So from now on, commits on stable branch will be done after reboot to prevent the thing I hate the most : being stuck on tty after reboot and have something important to do :D


### 11h35

Well guess waht !
```
hyprland.url = "github:hyprwm/Hyprland/";
#nothing bellow (:
```


untested-{ }: means hasnt beeen tested (feat or fix or ...), if next commit doesnt specify that it actually builds or works AND is from  the same branch that counts as a succesful test in one shot ! If not then it should be followed by fix on the same branch

fix: an actual bug fix with test, but not full rebuild and reboot






# File Result - references - dateless
> ---


untested-{ }: means hasnt beeen tested (feat or fix or ...), if next commit doesnt specify that it actually builds or works AND is from  the same branch that counts as a succesful test in one shot ! If not then it should be followed by fix on the same branch

fix: an actual bug fix with test, but not full rebuild and reboot
