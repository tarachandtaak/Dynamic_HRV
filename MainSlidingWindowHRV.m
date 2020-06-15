%% original made by Tara Chand

% To calculate dynamic HRV measures, using sliding window method
% The calulation will be perform in follwing order: 
%   1). If peak is not detected than first step should be to detect the peak 
%   2). Peak will be manually corrected
%   3). Outliers in peak to peak difference (IBI) will be removed
%   4). Used this IBI to calucaltes the HRV/PointProcessHRV/sliding window HRV measures 

% Dependency: 
% replaceOutliers.m from HRVAS toolbox 
% scrollplot.m- 
% 
% References: 1). Chand et al., 2020 Front. Neur.
%             2). Change et al., 2013 NeuroImage

clear
close all

%% parameters 

outlier_removal_ibi=1;
fs= 200; % sampling freq
Time_for_window= 60; % window length 
window_overlap= 0.5; %

rootDir='/media/tara/Tara4T/Ketamine_HRV/DynamicHRV'; 
rootOutDir=''; 
%% load the data 

load (fullfile(rootDir, '/SampleData/Sub01.mat'), 'PPGSignal', 'peaklist')

ecg= PPGSignal;
qrs= peaklist;

%% Sliding window HRV-caluculations 

% Mannual peak corrections
[ecg, qrs, PeaksToKill, PeaksToPut, CorruptedSegment]= manualPeakCorrection (ecg, qrs);

% IBI outliers corrections
[IBIsec_afterManualCheck, IBIsec, qrs]= IBI_OutliersCorrection (ecg, qrs, fs, outlier_removal_ibi);

% Sliding window HRV calculations
[WindowHRV_measures]= SlidingWindowHRV (ecg, qrs, IBIsec, fs, Time_for_window, window_overlap);


