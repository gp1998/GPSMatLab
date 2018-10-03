clear; 
clc;
%feature('DefaultCharacterSet', 'UTF8');

%% Log File Names
CustomFileName = 'custom_log_2018_10_03_19_59_25.txt';
GnssFileName = 'gnss_log_2018_10_03_19_59_25.txt';

%% Dir Name
dirName = '/home/ping/GPSMatLab/data_2018.10.03/';

%% Parameters
param.llaTrueDegDegM = [55.8612870 -4.2395520 157.73];%Charleston Park Test Site
param.velDegPerSec = 22.5;

%% Set the data filter and Read log file
dataFilter = SetDataFilter;
[gnssRaw,gnssAnalysis] = ReadLogFile(dirName,CustomFileName,GnssFileName,dataFilter);
if isempty(gnssRaw), return, end

%% Get online ephemeris from Nasa ftp, first compute UTC Time from gnssRaw:
fctSeconds = 1e-3*double(gnssRaw.allRxMillis(end));
utcTime = Gps2Utc([],fctSeconds);
allGpsEph = GetNasaHourlyEphemeris(utcTime,dirName);
if isempty(allGpsEph), return, end

%% Plot the data in 360 degree
[gnssMeas] = ProcessGnssMeas(gnssRaw);
[Aer]= GpsSvAer(gnssMeas,allGpsEph,param.llaTrueDegDegM);
h1 = figure;
[colors] = PlotPseudoranges(gnssMeas,GnssFileName);
h2 = figure;
difMaxMin = PlotDirCno(gnssMeas,Aer,GnssFileName,param.velDegPerSec,colors);
[accDegPer] = PlotAngAcc(difMaxMin,colors);  

