function [accDegPer] = PlotAngAcc(difMaxMin,colors)
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
accDegPer = [];
accDegPer.maxDegMean = [];
accDegPer.maxPerMean = [];
accDegPer.minDegMean = [];
accDegPer.minPerMean = [];

M = length(difMaxMin);

if nargin<3 || any(size(colors)~=[M,3])
    colors = zeros(M,3); %initialize color matrix for storing colors
    bGotColors = false;
else
    bGotColors = true;
end

%Plot accDegPer
for i=1:M
    accDegMean.maxDegMean(i) = mean(difMaxMin(i).difMax,'omitnan');
    accDegMean.minDegMean(i) = mean(difMaxMin(i).difMin,'omitnan');
    accDegMean.maxPerMean(i) = mean(difMaxMin(i).accMax,'omitnan');
    accDegMean.minPerMean(i) = mean(difMaxMin(i).accMin,'omitnan');
end
X1 = [mean(accDegMean.maxDegMean,'omitnan')];
Y1 = [mean(accDegMean.minDegMean,'omitnan')];
X2 = [mean(accDegMean.maxPerMean,'omitnan')];
Y2 = [mean(accDegMean.minPerMean,'omitnan')];
disp([X1,Y1,X2,Y2]);

% for i=1:M
%     iF = find(isfinite(Cn0iDbHz));
%     iFA = find(isfinite(Azimuth));
%     if ~isempty(iF&iFA)
%         ti = timeSeconds(iF(end));
%         tf = ceil(Azimuth(1)/vel); %time facing the satellite
%         tr = floor(360/vel);        %time needed to turn around
%         thf = tr/2;                 %time needed to turn half round
%         deg = timeSeconds*vel;
%         hr = floor(deg/180);
%         h = plot(deg,Cn0iDbHz);
%         if tf+thf*hr <= N
%             tbf = tf+thf*hr;       %time backfacing or facing
%         else
%             tbf = N;
%         end
%         g = line([Azimuth(tbf)+180*hr Azimuth(tbf)+180*hr],[0 50]);
%         hold on
%         if bGotColors
%             set(h,'Color',colors(i,:));
%             set(g,'Color',colors(i,:));
%         else
%             colors(i,:) = get(h,'Color');
%             colors(i,:) = get(g,'Color');
%         end
%         ts = int2str(gnssMeas.Svid(i));
%         text(ti,Cn0iDbHz(iF(end)),ts,'Color',colors(i,:));
%     end
% end
% axis([0 N*vel 15 50]);
% title('C/No in dB.Hz'),ylabel('(dB.Hz)')
% xs = sprintf('Angle (degrees)\n%s',prFileName);
% xlabel(xs,'Interpreter','none')
% grid on

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

