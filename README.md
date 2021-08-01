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
