EventsESN-Pi2

A model based on the echo state network for predicting the occurrence rate of Pi2 events 

[Instruction]

1. A random number generator is required. Download the Mersenne Twister in Fortran (mtfort90.f) via

  https://www.math.sci.hiroshima-u.ac.jp/m-mat/MT/VERSIONS/FORTRAN/fortran.html

and rename it as "mtfort90.f90". Remove the main program from this Fortran code to extract 
the Mersenne Twister module.


2. A data file of 5-minute solar wind data is also necessary. It should contain year, day of year, 
hour, minute, solar-wind dynamic pressure, density, speed, temperature, and interplanetary magnetic field 
Bx, By, and Bz in this order. The file "swdata2005.dat" is a sample solar wind data for one year in 2005,
which is obtained by converting the OMNI 5-min data, which were acquired from the OMNIWeb of NASA/GSFC 
(https://omniweb.gsfc.nasa.gov/). 


3. A prediction of the Pi2 event occurrence rate can be obtained as follows. 
 - Build the code as follows.

    > make pred_intensity

 - Run the model. (YYYY: year)

    > pred_intensity YYYY


4. The Python script plot_nu.py is for plotting the predicted occurrence rate. It requires 
the solar wind data (swdataYYYY.dat) and the output of "pred_intensity" (intensityYYYY.dat).
