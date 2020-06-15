function [WindowHRV_measures]= SlidingWindowHRV (ecg, qrs, IBIsec, fs, Time_for_window, window_overlap)

% Written by by Tara Chand 
% Calculate dynamic HRV measures, using sliding window method


dScanSec= 0; % dummy scan in sec

% fprintf('the length ECG in Scanner for sub %s is %.3f\n', folder_name, length(ecg)/fs)


win_Width  = fs*Time_for_window;  %Sliding window width

onsets= [1:(win_Width*window_overlap):length(ecg)]; % in second
numstps= length(onsets);

for i_win = 1: numstps   % can be changed
    
    if onsets(i_win)+win_Width > length(ecg)
        windowed_qrsIdx= qrs >= onsets(i_win) & qrs<=length(ecg);
        
        window_IBI = IBIsec(windowed_qrsIdx(2:end));
    else
        windowed_qrsIdx = qrs>=onsets(i_win) & qrs<=(onsets(i_win)+win_Width)-1;
        window_IBI = IBIsec(windowed_qrsIdx(2:end)); % as IBI is a diff of QRS so first should be remove; 
    end
    
    WindowHRV_measures.(sprintf('window%d',i_win))= HRV_Calculation (window_IBI, fs);
    
end
