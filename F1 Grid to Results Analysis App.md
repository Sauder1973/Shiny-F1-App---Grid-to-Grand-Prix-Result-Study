F1 Qualifying Grid to Race Results Analysis App
========================================================
author: Wes Sauder
date: September 25, 2015


Qualifying Grid Position & Race Results
========================================================

During a typical Formula One Race weekend, qualifying can be as exciting as the race itself.  It sets the field of racers for the Grand Prix on Sunday.  Pole Position is obviously great for bragging rights in the pits and paddock, but how important is qualifying for the final race?

Bringing the Analysis Together
========================================================
Using R, Shiny & F1 archived data, the importance of Grid Position during qualifying is illustrated graphically in an app.
![logo](F1andR.png)

Analysis Requirements
========================================================
These are the methods that were required to build the app.

- F1 Data Source - eErgast motor racing results API (http://ergast.com) maintained by Chris Newell
- Building R Data.Frame for analysis -Datawrangling the JSON outputs using code from *Wrangling F1 Data With R: A Data Junkie's Guide, by Tony Hirst* and available at http://leanpub.com/wranglingf1datawithr
- R Code - Used to automate the API calls for data.frame build as well as generate ggplot and analysis
- FTP and Hosted data.frame - 26,000 data points from 1955 to 2015 are aggregated during multiple API calls to eErgast.  The static data.frame is at a personal hosted ftp site and uses rCurl to pull data.frame into the App.
- Shiny - Used to develop final App and create user widgets.


Basic Study - Exploratory Analysis
========================================================
Grid Position vs Final Position Scatter Plot
![plot of chunk unnamed-chunk-1](F1 Grid to Results Analysis App-figure/unnamed-chunk-1-1.png) 

This study is great and shows a correlation, but is for over 25,000 data points and provides no deeper understanding.

App Example
========================================================
The App has the same controls on each view or tab
![logo](AppScreenExample.PNG)

Studies Available
========================================================
The App allows you investigate Grid to Final Position by:
 - Year(s) (Scatter Plot Only)
 - Constructor (Scatter Plot Only for Constructor and Year(s) Selection)
 - Circuits (Scatter Plot Only)
 - Driver (Scatter Plot for Grid vs Posn as well as histogram for Grid minus Posn by Constructor)
 
 
