
function [ecg, qrs]=  peakDetection (ecg, fs, DetectionMethod)

%% original made by Tara Chand

% To detect the R-Peak from ECG/PPG dataset
% peak is detect using following methods:

% 1). peakdet : https://www.mathworks.com/matlabcentral/fileexchange/47264-peakdet
%     input- ecg- ECG signal, and delta- threshold to define the r-peak
% 2). PanTompkins : https://www.mathworks.com/matlabcentral/fileexchange/45840-complete-pan-tompkins-implementation-ecg-qrs-detector
%     input- ecg- ECG signal, fs- sampling frequency, gr= flag for ploting
%
switch DetectionMethod
    case 'peakdet'
        %         pks = findpeaks(ecg); % if delta is based on mean values, delta values need to optimized based on data
        %         delta= nanmean(pks);
        delta = 0.007;
        [maxtab, mintab] = peakdet( ecg ,delta);  % I put delta to 0.007, it typically works, but for paper it is better to set it as a certain percent of mean (ppg)
        qrs = maxtab(:,1);
    case 'pantompkins'
        gr= 0; % I put it zero, as we will gonna manually check the peaks
        [qrs_amp_raw,qrs,delay]=pan_tompkin(ecg,fs,gr);
        
end

end


