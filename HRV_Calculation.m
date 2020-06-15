function [HRV_measures]= HRV_Calculation (IBIsec, fs)

%% original made by Tara Chand

% To calculate HRV measures
%
% VLF=[0.0 0.04];
LF =[0.05 0.15]; HF=[0.15 .5]; % The range low and high frequency 


if   length(IBIsec)>=2
    % HR
    hr=60./(IBIsec);
    meanHR=nanmean(hr);
    
    %% time domains
    
    sdHR=nanstd(hr);
    sdHR2=nanstd(hr)/meanHR;
    sdIBI = nanstd(IBIsec);
    sdIBI2 = nanstd(IBIsec)/meanHR;
    % RMSSD
    differences=(diff(IBIsec)); %successive ibi diffs
    RMSSD=sqrt(sum(differences.^2)/length(differences));
    RMSSD2=sqrt(sum(differences.^2)/length(differences))/meanHR;
    RMSSD_Martin = sqrt(sum(IBIsec.^-2)/length(differences));
    RMSSD3=sqrt(sum((differences/meanHR).^2)/length(differences))/meanHR;
    SDSD = nanstd(differences);
    SDSD2 = nanstd(differences)/meanHR;
    
    %
    %% frequency domain
    %prepare y
    use_detrend=true;
    detrend_order=true;
    y = IBIsec;
    if use_detrend
        %                     y=detrend(y,'linear');
        t=cumsum([0;IBIsec(1:end-1)]);
        [p,s,mu] = polyfit(t,y,detrend_order);
        f_y = polyval(p,t,[],mu);
        y = y - f_y;
    end
    y=y-mean(y);
    
    t=cumsum([0;IBIsec(1:end-1)]); %time (s)
    %Welch FFT
    %Prepare y
    t2 = t(1):1/fs:t(length(t));%time values for interp.
    y=interp1(t,y,t2','spline')'; %cubic spline interpolation
    y=y-mean(y); %remove mean
    
    %Calculate Welch PSD using hamming windowing
    [PSD,F] = pwelch(y,[],[],[],fs);
    
    %                 iVLF= (F>=VLF(1)) & (F<=VLF(2));
    iLF = (F>=LF(1)) & (F<=LF(2));
    iHF = (F>=HF(1)) & (F<=HF(2));
    
    % calculate raw areas (power under curve), within the freq bands (ms^2)
    %                  aVLF=trapz(F(iVLF),PSD(iVLF));
    %                 aVLF = 0;
    if length(F(iLF))>1    % If LF component is less than 1, the area under the crurve can not measure
        aLF=trapz(F(iLF),PSD(iLF));
    else
        aLF= 0;
    end
    if length(F(iHF))>1    % If LF component is less than 1, the area under the crurve can not measure
        aHF=trapz(F(iHF),PSD(iHF));
    else
        aHF= 0;
    end
    %                 aHF=trapz(F(iHF),PSD(iHF));
    %                 aTotal=aVLF+aLF+aHF;
    aTotal=aLF+aHF;
    
    %calculate areas relative to the total area (%)
    %                 pVLF=(aVLF/aTotal)*100;
    pLF=(aLF/aTotal)*100;
    pHF=(aHF/aTotal)*100;
    
    %calculate normalized areas (relative to HF+LF, n.u.)
    nLF=aLF/(aLF+aHF);
    nHF=aHF/(aLF+aHF);
    
    %calculate LF/HF ratio
    
    lfhf =aLF/aHF;
    
    %% Nonlinear measures poincare HRV
    
    ibi_ms=IBIsec.*1000; %convert ibi to ms
    sd=diff(ibi_ms); %successive differences
    rr=ibi_ms;
    SD1=sqrt( 0.5*std(sd)^2 );
    SD2=sqrt( 2*(std(rr)^2) - (0.5*std(sd)^2) );
    
    %     %format decimal places
    %     output.SD1=round(SD1*10)/10; %ms
    %     output.SD2=round(SD2*10)/10; %ms
    %
    
    HRV_measures{1,1} = 'RMSSD';
    HRV_measures{2,1} = 'RMSSD_Martin';
    HRV_measures{3,1} = 'RMSSD2';
    HRV_measures{4,1} = 'RMSSD3';
    HRV_measures{5,1} = 'meanHR';
    HRV_measures{6,1} = 'pLF';
    HRV_measures{7,1} = 'pHF';
    HRV_measures{8,1} = 'nLF';
    HRV_measures{9,1} = 'nHF';
    HRV_measures{10,1} = 'lfhf';
    HRV_measures{11,1} = 'sdHR';
    HRV_measures{12,1} = 'sdHR2';
    HRV_measures{13,1} = 'sdIBI';
    HRV_measures{14,1} = 'sdIBI2';
    HRV_measures{15,1} = 'SDSD';
    HRV_measures{16,1} = 'SDSD2';
    HRV_measures{17,1} = 'SD1';
    HRV_measures{18,1} = 'SD2';
    
    
    HRV_measures{1,2} = RMSSD;
    HRV_measures{2,2} = RMSSD_Martin;
    HRV_measures{3,2} = RMSSD2;
    HRV_measures{4,2} = RMSSD3;
    HRV_measures{5,2} = meanHR;
    HRV_measures{6,2} = pLF;
    HRV_measures{7,2} = pHF;
    HRV_measures{8,2} = nLF;
    HRV_measures{9,2} = nHF;
    HRV_measures{10,2} = lfhf;
    HRV_measures{11,2} = sdHR;
    HRV_measures{12,2} = sdHR2;
    HRV_measures{13,2} = sdIBI;
    HRV_measures{14,2} = sdIBI2;
    HRV_measures{15,2} = SDSD;
    HRV_measures{16,2} = SDSD2;
    HRV_measures{17,2} = SD1;
    HRV_measures{18,2} = SD2;
    
    
end
end

