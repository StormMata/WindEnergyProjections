function [comb] = CombineAreas(crops,water,city,forest,elev)
%CombineAreas takes geospatial data matrices and assimilates them
%   Takes geospatial data for:
%
%       agricultural development
%       standing water
%       urban development
%       forest coverage
%       elevation gradient
%
%   and assimilates these various map layers into one matrix to reveal
%   remaining available development area

crops(isnan(crops))   = 0;
water(isnan(water))   = 0;
city(isnan(city))     = 0;
forest(isnan(forest)) = 0;
elev(isnan(elev))     = 0;

comb = forest;

comb(elev == 1) = 2;

comb(water == 1) = 3;

comb(crops == 1) = 4;

comb(city == 1) = 5;

comb(comb == 0) = NaN;

end