# D-HRV 1.0: Dynamic Heart Rate Variablity Toolbox
```diff
! Performs dynamic analysis of the heart rate variablity and it's derived measures. 
```
**Implemented Computational Order for Dynamic-HRV analysis:** 


         1). Peak Detection 
                           
                           Saves computational time, if peak exists! 


Heart rate variablity is a measure of fluctuations between heart beats (fluctuations in R-R peaks interval). Therefore to calculate HRV, the r-peak should be detected properly. While acquring the data, some software detect peaks in real time. If this peak is not detected than 'peak detection' function should used which detects the peaks automatically. The peaks detection can be performed using Pan-Tompkins and Billauer algorithms.  

         2). Peak Correction 

                           False peak removal
                           Adds missing peak
                           
The quality of the detected peaks are manually inspected by overlapping detected P-peaks timestamps over ECG/PPG signal; during this process missing peaks are added and false peaks are removed via manual inspections. 
 
         3). Outlier detection and removal of peak difference (IBI) 
                           Ecotic peak correction

The intermittent errors in P-peaks due to the ectopic beats or movement artifacts indentifing and correct. The identifications methods can be pertanges filter or threshold methods. The erroreous IBI can be removed or interpolates.  

         4). IBI input -> HRV and sliding window HRV measures analysis 
                           Time and frequency measures

Preprocessed IBI is used as a input for the HRV calculations. For calculations of the dynamic HRV measures, sliding window method is applied.  The choice of the parameters for the sliding window can be decided by the user. For example  window length should be short enough to track the fast temporal changes but long enough not to introduce spurious fluctuations. The overlap between successive windows typically may vary from a single data point up to the length of a window. Therefore, the step size of the shifting window is also a trade-off, moving one data point can lead to a large number of windowed-matric data points with the cost of the auto-correlation (Chang 2013, Lurie, 2020). <br />

Both time and frequency domains measures can be calculates for each window. If No parameters is used for the sliding window than HRV will be calculates for whole recording time (static HRV)

**Processing Flowchart:**  
                  
           Flowchart illustrates the processing insights in more detail and corresponds to the code-stack!

![alt text](https://github.com/tarachandtaak/Dynamic_HRV/blob/master/SampleData/FlowChartGitHubTemp.jpg?raw=true)

<!---**Tutorial with Sample Data:**

            Let's play with one Sample data and analyze D-HRV ... --->


**Required Dependensies:**

           Matlab 2017 or Higher 
           Signal processing Toolbox
           Image processing Toolbox
