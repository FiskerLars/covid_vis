% CoViD-19 (or general case time-series) visualisation
% das@larsipulami.de

Just a little getting re-used to analysing and visualising 
time series, given, that the current pandemic gives us some data that
both is interesting, vast and — at the point of writing this — very
frightening in many countries.

My main intention has been to visualise deaths/day, as you find plenty
of visualisations of the infection rates but only summary numbers of the
number of deaths. (Or at least I did.) I wanted to see for myself how
this (probably much more accurate) number develops over time. It
probably is my way of coping with my own fears. 

Having said this, I want to express that I do not intend in any way to
reduce the victims, families and fellow human beings, the individual tragedies
to mere numbers. Every single tick in the numbers means tragedy for a
human and his friends and family. I obviously cannot take the pain from
you, but at least, by this work, I can take note.

Please stay safe, whereever you are.

### Usage

First get the current data repository from the John Hopkins University
(thank you for sharing). 

Then read it into data (as a list).
<pre>
data <- read_covid19_ts()
</pre>

Data now contains three data frames under the labels "Deaths",
"Infected" and "Recovered"

You can now produce a plot of the daily cases and a running average of
seven days with 
<pre>
plot_daily(data)
<pre>.


