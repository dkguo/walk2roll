xScale = effortBinSize/2; %divided by two because double-counting large open/close at end of each side
yScale = 1/N1;

xy120 = [2 -4.52
    3 -4.8
    5 -5.15
    6 -4.07
    8 -2.82
    11 -1.32];

xy105 = [2 -4.67
    3 -4.87
    4 -4.93
    5 -4.70
    6 -3.62
    8 -2.22
    9 -1.66
    10 -2.16];

xy90 = [2 -3.72
    3 -3.82
    4 -4.18
    5 -4.19
    6 -3.83
    7 -2.72
    9 -1.38];

xy75 = [3 -3.35
    5 -3.57
    6 -2.73
    7 -2.19
    8 -1.86
    9 -2.19];

xy60 = [3 -3.20
    5 -2.84
    6 -2.63
    8 -0.99];

% x60r = min(xy60(:,1)):0.1:max(xy60(:,1));
% y60r = interp1(xy60(:,1),xy60(:,2),x60r, 'spline');
% figure
% hold on
% plot(x60r*xScale, y60r*yScale)
% 
% x75r = min(xy75(:,1)):0.1:max(xy75(:,1));
% y75r = interp1(xy75(:,1),xy75(:,2),x75r, 'spline');
% plot(x75r*xScale, y75r*yScale)
% 
% x90r = min(xy90(:,1)):0.1:max(xy90(:,1));
% y90r = interp1(xy90(:,1),xy90(:,2),x90r, 'spline');
% plot(x90r*xScale, y90r*yScale)
% 
% 
% x105r = min(xy105(:,1)):0.1:max(xy105(:,1));
% y105r = interp1(xy105(:,1),xy105(:,2),x105r, 'spline');
% plot(x105r*xScale, y105r*yScale)
% 
% x120r = min(xy120(:,1)):0.1:max(xy120(:,1));
% y120r = interp1(xy120(:,1),xy120(:,2),x120r, 'spline');
% plot(x120r*xScale, y120r*yScale)
close all
% First Batch generated (I think)
nUse1 = maxNegByRadiusAndMotionID(4,3) %Subfigure (a)
nUse2 = maxNegByRadiusAndMotionID(6,3) %Subfigure (b)
nUse3 = maxNegByRadiusAndMotionID(8,3) %Subfigure (c)
nUse4 = maxNegByRadiusAndMotionID(8,11) %Not used
nUse5 = maxNegByRadiusAndMotionID(7,11) %Subfigure (g)

% Second batch generated
% nUse1 = maxNegByRadiusAndMotionID(8,5) %Subfigure (e)
% nUse2 = maxNegByRadiusAndMotionID(8,7) %Subfigure (h)
% nUse3 = maxNegByRadiusAndMotionID(6,5) %Subfigure (d)
% nUse4 = maxNegByRadiusAndMotionID(6,6) %Not used
% nUse5 = maxNegByRadiusAndMotionID(4,8) %Subfigure (f)

plotIndices = [nUse1 nUse2 nUse3 nUse4 nUse5]; 
Nplot = length(plotIndices);

for nplot = 1:Nplot,
    %figure
    dGx = dGRec(plotIndices(nplot),1);
    dGy = dGRec(plotIndices(nplot),2);
    rList = rListRec(plotIndices(nplot),:);
    x1 = xyRec(plotIndices(nplot),1);
    y1 = xyRec(plotIndices(nplot),2); 
    x2 = -x1;
    y2 = y1;
    

for n = 1:Nsegs,
    x1plot(n) = x1 + rList(n)*cos(th1List(n));
    y1plot(n) = y1 + rList(n)*sin(th1List(n));
    x2plot(n) = x2 + rList(n)*cos(th2List(n));
    y2plot(n) = y2 + rList(n)*sin(th2List(n));
end

figure
plot([rG1xMax rG1xMax -rG1xMax -rG1xMax rG1xMax], [rG1yMin rG1yMax rG1yMax rG1yMin rG1yMin], 'k--', 'linewidth', 2);
hold on
plot(dGx, dGy, 'ko', 'markersize', 12, 'linewidth', 2);
plot([x1 x1plot x1], [y1 y1plot y1], 'k', [x2 x2plot x2], [y2 y2plot y2], 'k', 'linewidth', 2);
plot(x1,y1,'k^', -x1, y1, 'k^', 'markersize', 12, 'linewidth', 2)
axis([-0.15 0.15 -0.1 0.15])
pbaspect([3 2.5 1])
end

% nUse1 = maxNegByRadiusAndMotionID(6,2)
% nUse2 = maxNegByRadiusAndMotionID(6,5)
% nUse3 = maxNegByRadiusAndMotionID(6,7)
% nUse4 = maxNegByRadiusAndMotionID(6,10)
% 
% plotIndices = [nUse1 nUse2 nUse3 nUse4]; 
% Nplot = length(plotIndices);
% 
% for nplot = 1:Nplot,
%     figure
%     dGx = dGRec(plotIndices(nplot),1);
%     dGy = dGRec(plotIndices(nplot),2);
%     rList = rListRec(plotIndices(nplot),:);
%     x1 = xyRec(plotIndices(nplot),1);
%     y1 = xyRec(plotIndices(nplot),2); 
%     x2 = -x1;
%     y2 = y1;
%     
% 
% for n = 1:Nsegs,
%     x1plot(n) = x1 + rList(n)*cos(th1List(n));
%     y1plot(n) = y1 + rList(n)*sin(th1List(n));
%     x2plot(n) = x2 + rList(n)*cos(th2List(n));
%     y2plot(n) = y2 + rList(n)*sin(th2List(n));
% end
% 
% 
% plot([rG1xMax rG1xMax -rG1xMax -rG1xMax rG1xMax], [rG1yMin rG1yMax rG1yMax rG1yMin rG1yMin], 'k:');
% hold on
% plot(dGx, dGy, 'ko');
% plot([x1 x1plot x1], [y1 y1plot y1], 'k', [x2 x2plot x2], [y2 y2plot y2], 'k');
% plot(x1,y1,'k^', -x1, y1, 'k^')
% axis([-0.15 0.15 -0.05 0.1])
% pbaspect([3 1.5 1])
% end
% 
nUse = maxNegByRadiusAndMotionID(6,6)
dth1List = dth1ListRec(nUse4,:);
dth2List = sort(-dth1List, 'ascend');
momentArm1 = squeeze(momentArm1Rec(nUse,:,:));
momentArm2= squeeze(momentArm2Rec(nUse,:,:));

f = figure;
f.Position = [100 100 350 1000];
subplot(2,1,1)
dth1List = rad2deg(dth1List);
[C,h] = contourf(flip(thGList(thGList>0)), dth1List, momentArm1(thGList<=0,:)');
% [C,h] = contourf(flip(thGList), dth1List, momentArm1(:,:)');
clabel(C,h);
yyaxis right
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';
axis([0 pi min(dth1List) max(dth1List)]);
xticks([0 pi/2 pi])
xticklabels({'0','-\pi/2','-\pi'})
subplot(2,1,2)
dth2List = rad2deg(dth2List);
[C,h] = contourf(flip(thGList(thGList<0)), flip(dth2List), momentArm2(thGList>=0,:)');
clabel(C,h);
axis([-pi 0 -max(dth1List) -min(dth1List)]);
xticks([-pi -pi/2 0])
xticklabels({'\pi','\pi/2','0'})
