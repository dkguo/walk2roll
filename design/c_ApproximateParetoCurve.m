Nsim = 6000;

for n = 1:Nsim,
    motionNegRecAdj(n) = motionNegRec(n)*(dth1ListRec(41)-dth1ListRec(1));
end

clear selectBinStats;
qBin = 1;
for n = 1:Nsim,
    largestRadius(n) = max(abs(rRandRec(n,:)));
    largestRadiusBin(n) = round(largestRadius(n)/0.015);
    
    
    if abs(largestRadius(n)-0.105) < 0.015, 
        selectBinStats(qBin,:) = [n maxNegRec(n) motionNegRecAdj(n)];
        qBin = qBin+1;
    end
        
end



figure
hold on
Qmax = ceil(0.15/.02);
Qmin = min(largestRadiusBin);
effortBinSize = (max(motionNegRecAdj)-min(motionNegRecAdj))/10;
Pmax = ceil(max(motionNegRecAdj)/effortBinSize);
clear radiusBinnedStats
maxNegByRadiusAndMotion = nan(Qmax,Pmax);
maxNegByRadiusAndMotionID = nan(Qmax,Pmax);


fineBins = 200;
effortBinSize2 = (max(selectBinStats(:,3))-min(selectBinStats(:,3)))/fineBins;
N2 = length(selectBinStats);
for qc2 = 1:fineBins,
    effortBinTemp(qc2) = effortBinSize2*qc2;
    maxNegAtSelectRadius(qc2) = 0;
    for n = 1:N2,
        if abs(selectBinStats(n,3)- effortBinTemp(qc2)) < effortBinSize2,
            if selectBinStats(n,2) < maxNegAtSelectRadius(qc2),
                maxNegAtSelectRadius(qc2) = selectBinStats(n,2);
            end
           
        end
    end
end


% plot(selectBinStats(:,3)/effortBinSize, selectBinStats(:,2),'o')
hold on
plot(effortBinTemp/effortBinSize, maxNegAtSelectRadius, 'o', 'color', [0.4940, 0.1840, 0.5560], 'MarkerSize', 12, 'LineWidth', 2)
ylim([-6 -1])
xlabel('Cumulative Absolute Leg Motion (rad)')
ylabel('Mean CW Moment \newline Arm Due to Gravity (cm)')
set(gca,'fontname','times', 'fontsize', 24)
