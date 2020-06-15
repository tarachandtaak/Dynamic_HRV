function [IBIsec_afterManualCheck, IBIsec, qrs]= IBI_OutliersCorrection (ecg, qrs, fs, outlier_removal_ibi)

%% original made by Tara Chand

% To correct the Outliers from IBI (IBI- difference between two successive R-peak)
%

qrs= double(qrs); 
ibi= diff(qrs);
ibi=nonzeros(ibi);
IBIsec = ibi./fs;
IBIsec_afterManualCheck= IBIsec;


if outlier_removal_ibi == 1
    sub_ibi_mean = nanmean(IBIsec(:));
    sub_ibi_sd = nanstd(IBIsec(:));
    Outliers= IBIsec>sub_ibi_mean+3*sub_ibi_sd | IBIsec<sub_ibi_mean-3*sub_ibi_sd;
    %Outlier_sub{i_sub, day}=sum(Outliers);
   % nIBISub{i_sub, day}= length(IBIsec);
    
elseif outlier_removal_ibi == 2
    perLimit= 30/100;
    Outliers=false(length(IBIsec),1); %preallocate
    pChange=abs(diff(IBIsec))./IBIsec(1:end-1); %percent chage from previous
    %find index of values where pChange > perLimit
    Outliers(2:end) = (pChange >perLimit);
    
elseif outlier_removal_ibi == 3
    
    Outliers= isoutlier(IBIsec);
    %                         IBIsec(isoutlier(IBIsec))= [];
    Outlier_sub{i_sub, day}=sum(Outliers);
    nIBISub{i_sub, day}= length(IBIsec);
end

outlierIBI = IBIsec(Outliers);

t= 1: length(IBIsec);
[IBIsec,t2] = replaceOutliers(t,IBIsec,Outliers, 'spline');
IBIsec= IBIsec';

%% make histogram of IBI before, after manual checked, and after automatic correction

h3= figure;
% subplot(3,1,1); hist(IBIsec_beforeCorr), title('IBI Histogram (raw)')
subplot(2,1,1); hist(IBIsec_afterManualCheck), title('IBI Histogram (afterManualCheck)')
subplot(2,1,2); hist(IBIsec), title('IBI Histogram (After Clean)')

h2= figure; plot(ecg),  xticks(qrs), title('corrected peak')
scrollplot(4000, 1:length(ecg),ecg)

% OutliersLatency= qrs(find(Outliers)+1);
% 
% if ~isempty(OutliersLatency)
%     y1=get(gca,'ylim');
%     line([OutliersLatency OutliersLatency ],y1,'Color','red','LineStyle','--')
% end
% 

% OutputName= sprintf('%s_day%d_%s', folder_name, day,Task{i_task} );
% 
% saveas(h2, fullfile(root_output,[OutputName, 'afterCorrection.fig']));
% saveas(h3, fullfile(root_output,[OutputName, 'IBI_hist.fig']));
% save(fullfile(root_output, [OutputName, '.mat']), 'qrs','IBIsec', 'PeaksToKill', 'PeaksToPut')
end