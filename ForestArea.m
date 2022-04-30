function [forest,forestR] = ForestArea(CPD)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

addpath('/Users/stormmata/Downloads/TiffData');

[A1,R1] = readgeoraster('Forest-C1.tif');
[A2,R2] = readgeoraster('Forest-C2.tif');

A = [A1,A2];

R = R1;
R.LongitudeLimits(2) = R2.LongitudeLimits(2);

latlim = [23,50];                                                       % Latitude limits for US
lonlim = [-127,-65];                                                    % Longitude limits for US

cellperdeg = CPD;                                                       % Number of cells per degree of lat/long

latvec = flip(linspace(R.LatitudeLimits(1),R.LatitudeLimits(2),size(A,1)));              % Vector of latitudes
lonvec = linspace(R.LongitudeLimits(1),R.LongitudeLimits(2),size(A,2));                    % Vector of longitudes

latind(1) = find(latvec > latlim(2),1,'last');
latind(2) = find(latvec < latlim(1),1,'first');

lonind(1) = find(lonvec < lonlim(1),1,'last');
lonind(2) = find(lonvec > lonlim(2),1,'first');

B = A(latind(1):latind(2),lonind(1):lonind(2));

latnum = ceil((latlim(2) - latlim(1)) * ...     % Find number of latitude cells for geotiff data
         cellperdeg);
lonnum = ceil((abs(lonlim(1)) - abs( ...                 % Find longitude cells for geotiff data
         lonlim(2))) * cellperdeg);

B = B(floor(linspace(1,size(B,1),latnum)),floor(linspace( ...       % Sample geotiff data with 
    1,size(B,2),lonnum)));
R.RasterSize = [size(B,1),size(B,2)];
R.LatitudeLimits = latlim;
R.LongitudeLimits = lonlim;

B(B < 10) = NaN;
B(B >= 10) = 1;

B = double(B);

forest = B;
forestR = R;

end