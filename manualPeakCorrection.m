function [ecg, qrs, PeaksToKill, PeaksToPut, CorruptedSegment, h1]= manualPeakCorrection (ecg, qrs)

%% original made by Tara Chand

% To manually check peak after overlapping on ECG

% peak is ovelapped on raw ecg dataset and check if it is detected corrected. Missing peak were
% added and false peaks were removed
% Corrupted segment information were recorded; Due to movement a large segment of data can be
% corrupted so need to get the exact timing where the data is corrupted.

% dependency: scrollplot (https://www.mathworks.com/matlabcentral/fileexchange/3581-scrollplot)

%
if size(qrs,1)== 1 % check QRS dimention, should be 1*n dims
    qrs= qrs';
end


h1= figure; set(gcf, 'Position',  [1, 1000, 1000, 400])
plot(ecg),  xticks(qrs), title('Original peak detect')
scrollplot(4000, 1:length(ecg),ecg)

DOMODIFICATIONS = input('Press Y if You want to change something in this window ','s');
PeaksToPut = [];
PeaksToKill = [];
Y_PeaksToPut = [];
Y_PeaksToKill = [];
CorruptedSegment= [];
rectForFigure=[];

if strcmp(DOMODIFICATIONS,'y')
    modifyPeaks = input('Do You want to modifiy peaks?  0-kill 1-insert 2-CorruptedSegment: ');
    
    if modifyPeaks == 1
        [PeakindexX,PeakindexY] = getpts(h1);
        PeaksToPut = [PeaksToPut;PeakindexX];
        Y_PeaksToPut = [Y_PeaksToPut;PeakindexY];
        hold on
        plot(PeaksToKill,Y_PeaksToKill, 'r*') % mark modified peak on the figures
        plot(PeaksToPut,Y_PeaksToPut, 'm*') % mark modified peak on the figures
        for i_rect= 1: size(rectForFigure ,1)
            rectangle('Position', rectForFigure(i_rect,:), ...
                'Curvature', 0.2, ...
                'FaceColor', [1, 0, 0, 0.2], ...
                'EdgeColor', [1, 0, 0, 0.2]);
        end
        hold off
    end
    
    if modifyPeaks == 0
        [PeakindexX,PeakindexY] = getpts(h1);
        PeaksToKill = [PeaksToKill,PeakindexX];
        Y_PeaksToKill = [Y_PeaksToKill;PeakindexY];
    end
    
    if modifyPeaks == 2
        rect  = getrect(h1);
        CorruptedSegment = [CorruptedSegment; [rect(1),rect(1)+rect(3)]];
        rectForFigure= [rectForFigure; rect];
        %Y_PeaksToKill = [Y_PeaksToKill;PeakindexY];
    end
    
    DOMODIFICATIONS_more = input('Press Y if You want to change something in this window ','s');
    while strcmp(DOMODIFICATIONS_more,'y')
        
        modifyPeaks = input('Do You want to modifiy peaks?  0- kill 1- insert 2- CorruptedSegment: ');
        
        if modifyPeaks == 0
            [PeakindexX,PeakindexY] = getpts(h1);
            PeaksToKill = [PeaksToKill;PeakindexX];
            Y_PeaksToKill = [Y_PeaksToKill;PeakindexY];
            
        end
        
        if modifyPeaks == 1
            [PeakindexX,PeakindexY] = getpts(h1);
            PeaksToPut = [PeaksToPut;PeakindexX];
            Y_PeaksToPut = [Y_PeaksToPut;PeakindexY];
            hold on
            plot(PeaksToKill,Y_PeaksToKill, 'r*') % mark modified peak on the figures
            plot(PeaksToPut,Y_PeaksToPut, 'm*') % mark modified peak on the figures
            for i_rect= 1: size(rectForFigure ,1)
                rectangle('Position', rectForFigure(i_rect,:), ...
                    'Curvature', 0.2, ...
                    'FaceColor', [1, 0, 0, 0.2], ...
                    'EdgeColor', [1, 0, 0, 0.2]);
            end
            hold off
        end
        
        if modifyPeaks == 2
            rect  = getrect(h1);
            CorruptedSegment = [CorruptedSegment; [rect(1),rect(1)+rect(3)]];
            rectForFigure= [rectForFigure; rect];
            %Y_PeaksToKill = [Y_PeaksToKill;PeakindexY];
        end
        
        DOMODIFICATIONS_more = input('Press Y if You want to change something in this window ','s');
        
    end
    
    
    % insert QRS
    
    qrs= sort([qrs;PeaksToPut]);
    % remove QRS
    if ~isempty(PeaksToKill)
        for i_kill =1: length(PeaksToKill)
            dist    = abs(qrs- PeaksToKill(i_kill));
            minDist = 250; % we choose this value because we think that during clinking on we can not select exact the same locations of the peak
            idx     = find(dist < minDist);
            qrs(idx)= [];
        end
    end
end

DOMODIFICATIONS_final = input('Final modification: Press Y if You want to change something  ','s');

if strcmp(DOMODIFICATIONS_final,'y')
    modifyPeaks = input('Do You want to modifiy peaks ?  0-kill 1-insert 2-CorruptedSegment: ');
    
    if modifyPeaks == 1
        [PeakindexX,PeakindexY] = getpts(h1);
        PeaksToPut = [PeaksToPut;PeakindexX];
        Y_PeaksToPut = [Y_PeaksToPut;PeakindexY];
        hold on
        plot(PeaksToKill,Y_PeaksToKill, 'r*') % mark modified peak on the figures
        plot(PeaksToPut,Y_PeaksToPut, 'm*') % mark modified peak on the figures
        for i_rect= 1: size(rectForFigure ,1)
            rectangle('Position', rectForFigure(i_rect,:), ...
                'Curvature', 0.2, ...
                'FaceColor', [1, 0, 0, 0.2], ...
                'EdgeColor', [1, 0, 0, 0.2]);
        end
        hold off
    end
    
    if modifyPeaks == 0
        [PeakindexX,PeakindexY] = getpts(h1);
        PeaksToKill = [PeaksToKill,PeakindexX];
        Y_PeaksToKill = [Y_PeaksToKill;PeakindexY];
    end
    
    if modifyPeaks == 2
        rect  = getrect(h1);
        CorruptedSegment = [CorruptedSegment; [rect(1),rect(1)+rect(3)]];
        rectForFigure= [rectForFigure; rect];
        %Y_PeaksToKill = [Y_PeaksToKill;PeakindexY];
    end
    
    % insert QRS
    
    qrs= sort([qrs;PeaksToPut]);
    % remove QRS
    if ~isempty(PeaksToKill)
        for i_kill =1: length(PeaksToKill)
            dist    = abs(qrs- PeaksToKill(i_kill));
            minDist = 250; % we choose this value because we think that during clinking on we can not select exact the same locations of the peak
            idx     = find(dist < minDist);
            qrs(idx)= [];
        end
    end
end


hold on,
if ~isempty(PeaksToKill)
    plot(PeaksToKill,Y_PeaksToKill, 'r*') % mark modified peak on the figures
end
if ~isempty(PeaksToPut)
    plot(PeaksToPut,Y_PeaksToPut, 'm*') % mark modified peak on the figures
end

if ~isempty(CorruptedSegment)
    for i_rect= 1: size(rectForFigure ,1)
        rectangle('Position', rectForFigure(i_rect,:), ...
            'Curvature', 0.2, ...
            'FaceColor', [1, 0, 0, 0.2], ...
            'EdgeColor', [1, 0, 0, 0.2]);
    end
end

hold off
% saveas(h1, fullfile(root_output,[OutputName, 'duringCorrection.fig']));
qrs= double(qrs);
ecg= double(ecg);

end