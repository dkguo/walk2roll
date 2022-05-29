for n = 1:Nsim,
    motionNegRecAdj(n) = motionNegRec(n)*(dth1ListRec(41)-dth1ListRec(1));
end


for n = 1:Nsim,
    largestRadius(n) = max(abs(rRandRec(n,:)));
    largestRadiusBin(n) = round(largestRadius(n)/0.015);
end

close all
figure
hold on
Qmax = ceil(0.15/.02);
Qmin = min(largestRadiusBin);
effortBinSize = (max(motionNegRecAdj)-min(motionNegRecAdj))/10;
Pmax = ceil(max(motionNegRecAdj)/effortBinSize);
clear radiusBinnedStats
maxNegByRadiusAndMotion = nan(Qmax,Pmax);
maxNegByRadiusAndMotionID = nan(Qmax,Pmax);

line_style = ["-", "--", "-.", ":", "-"];
line_width = [4, 3, 3, 3, 3];
for q = Qmin:Qmax,
    qc = 1;
    for n = 1:Nsim,
        if largestRadiusBin(n) == q,
            radiusBinnedStats(:,qc,q) = [n maxNegRec(n) motionNegRecAdj(n)]';
            qc = qc+1;
        end
    end
    for qr = 1:qc-1,
        maxNegMotionBin = round(radiusBinnedStats(3,qr,q)/effortBinSize);
        if isnan(maxNegByRadiusAndMotion(q,maxNegMotionBin)) || (radiusBinnedStats(2,qr,q) < maxNegByRadiusAndMotion(q,maxNegMotionBin)),
            maxNegByRadiusAndMotion(q,maxNegMotionBin) = radiusBinnedStats(2,qr,q);
            maxNegByRadiusAndMotionID(q,maxNegMotionBin) = radiusBinnedStats(1,qr,q);
        end
    end
    plot(maxNegByRadiusAndMotion(q,:), line_style(q-3), 'linewidth', line_width(q-3))
end
legend('60 cm','75 cm','90 cm','105 cm','120 cm', 'location', 'southeast')
xlabel('Cumulative Absolute Leg Motion (rad)')
ylabel('Mean CW Moment Arm Due to Gravity (cm)')
set(gca,'fontname','times', 'fontsize', 20)






