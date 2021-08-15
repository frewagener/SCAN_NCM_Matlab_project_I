# SCAN_NCM_Matlab_project_I
In the current github repository there are scripts for the creation of a Working Memory Experiment. 

![Experimental Design](https://github.com/frewagener/SCAN_NCM_Matlab_project_I/blob/main/Exp_Design/Experimental_Design.png)
  

**PARADIGM:**<br/>
This script implements a rehearsal/refreshment task. 
There is eight different stimuli
There is two experimental conditions: **(1) working memory load = 1 tone**
                                      **(2) working memory load = 3 tones**<br/>
This means that either the last tone (frequency) of a given stimulus sequence should
be rehearsed or that all 3 tones presented need to be rehearsed.
Subjects are presented with an initial sequence of tones (a sequence consits of three different frequencies),
which is repeated during a Stimulation phase for 8 seconds.
The last presentation of a stimuli is accompanied with a CUE, which tells
the subject that from then on Refreshment starts
During the Refrehsment-Period (8s) a visual pacing-cue is presented
to speed the refreshment.
After that period, a Target-Stimulus is presented, which either matches
the current to-be-refreshed stimulus in the sequence, or not.
Subjects indicate via left/right arrow button-press if it was a correct target
or not. 

**OUTPUTS:**<br/>
A MATLAB-Logfile is generated (to be used for the Data analysis)


**What you will find in each folder:** <br/>
**Creating_stimuli** has a necessary function and a script, which contain out stimuli selection for the purpose of the experiment.<br/>
**Exp_Design** contains the schematic overview of our experiment.<br/>
**Log_files** contains all of the log files produced from our work and a script which makes plots based on the log files.<br/>
The file **NCM_final** is the actual experiment it needs to be together with particiapnt input. 

