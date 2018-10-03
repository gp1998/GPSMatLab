function [difMaxMin] = PlotDirCnoRound(gnssMeas,aer,prFileName,vel,colors)
%[colors] = PlotCno(gnssMeas,[prFileName],[colors])
% Plot the C/No from gnssMeas
%
%gnssMeas.FctSeconds    = Nx1 vector. Rx time tag of measurements.
%       .Svid           = 1xM vector of all svIds found in gpsRaw.
%       ...
%       .Cn0DbHz        = NxM
%
% Optional inputs: prFileName = string with file name
%                  colors, Mx3 color matrix
%
%Output: colors, color matrix, so we match colors each time we plot the same sv

difDir = [];
difMaxMin = [];

M = length(gnssMeas.Svid);
N = length(gnssMeas.FctSeconds);

if nargin<2
    prFileName = '';
end

if nargin<3 || any(size(colors)~=[M,3])
    colors = zeros(M,3); %initialize color matrix for storing colors
    bGotColors = false;
else
    bGotColors = true;
end

timeSeconds = gnssMeas.FctSeconds-gnssMeas.FctSeconds(1);%elapsed time in seconds
L = ceil((gnssMeas.FctSeconds(end)-gnssMeas.FctSeconds(1))*vel/360);

% difDir.svID = zeros(1,M)+ NaN;
% difDir.maxCN0 = zeros(M,L)+ NaN;
% difDir.sigMaxDeg = zeros(L,M)+ NaN;
% difDir.svFacDir = zeros(M,L)+ NaN;
% difDir.minCN0 = zeros(M,L)+ NaN;
% difDir.sigMinDeg = zeros(L,M)+ NaN;
% difDir.svBackDir = zeros(M,L)+ NaN;
% difDir.difMax = zeros(M,L)+ NaN;
% difDir.difMin = zeros(M,L)+ NaN;

%Plot C/No and acquire difMaxMin
for i=1:M
    difDir(i).svID = gnssMeas.Svid(i);
    difMaxMin(i).Svid = gnssMeas.Svid(i);
    Cn0iDbHz = gnssMeas.Cn0DbHz(:,i);
    [s1,loc1] = findpeaks(Cn0iDbHz);
    difDir(i).sigMaxDeg = [mod(loc1 * vel,360)];
    upsidedownCn0 = - Cn0iDbHz;
    [s2,loc2] = findpeaks(upsidedownCn0);
    difDir(i).sigMinDeg = [mod(loc2 * vel,360)];
    Azimuth = aer.AzDeg(:,i);
    dirDir(i).svFacDir = [Azimuth(loc1)];
    dirDir(i).svBackDir = [Azimuth(loc2)];
    difMaxMin(i).difMax = abs(difDir(i).sigMaxDeg - dirDir(i).svFacDir);
    difMaxMin(i).difMin = abs(difDir(i).sigMinDeg - dirDir(i).svBackDir);
    iF = find(isfinite(Cn0iDbHz));%find out where the finite values are
    iFA = find(isfinite(Azimuth));
    if ~isempty(iF&iFA)%if there are finite values
        ti = timeSeconds(iF(end));
        tf = ceil(Azimuth(1)/vel); %time facing the satellite
        tr = floor(360/vel);        %time needed to turn around
        thf = tr/2;                 %time needed to turn half round
        deg = mod(timeSeconds*vel,360);       
        hr = floor(deg/180);
        

        [deg, position] = sort(deg);
        NewCn0iDbHz = Cn0iDbHz(position);
        
        h = plot(deg,NewCn0iDbHz);
        if tf+thf*hr <= N
            tbf = tf+thf*hr;       %time backfacing or facing
        else
            tbf = N;
        end
        MeanMaxDeg = mod(mean(Azimuth,'omitnan'),360);
        MeanMinDeg = mod(MeanMaxDeg+180,360);
        g = line([[MeanMaxDeg;MeanMaxDeg],[MeanMinDeg;MeanMinDeg]],[0 50]);
        hold on
        if bGotColors
            set(h,'Color',colors(i,:));
            set(g,'Color',colors(i,:));
        else
            colors(i,:) = get(h,'Color');
            colors(i,:) = get(g,'Color');
        end
        ts = int2str(gnssMeas.Svid(i));
        text(ti,Cn0iDbHz(iF(end)),ts,'Color',colors(i,:));
    end
end
axis([0 360 15 50]);
title('C/No in dB.Hz'),ylabel('(dB.Hz)')
xs = sprintf('Angle (degrees)\n%s',prFileName);
xlabel(xs,'Interpreter','none')
grid on

for i=1:M
    J = find(difMaxMin(i).difMax);
    for j=1:length(J) 
        if difMaxMin(i).difMax(j) > 180
            difMaxMin(i).difMax(j) = 360 - difMaxMin(i).difMax(j);
        end
        difMaxMin(i).accMax(j) = (360 - difMaxMin(i).difMax(j))/360;
    end
    K = find(difMaxMin(i).difMin);
    for k=1:length(K) 
        if difMaxMin(i).difMin(k) > 180
            difMaxMin(i).difMin(k) = 360 - difMaxMin(i).difMin(k);
        end
        difMaxMin(i).accMin(k) = (360 - difMaxMin(i).difMin(k))/360;
    end       
end

if nargout
    colorsOut = colors;
end

end %end of function PlotCno
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright 2016 Google Inc.
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

