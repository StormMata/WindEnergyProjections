function [comb,combW] = CombineAreas(wind,crops,water,city,forest,elev)
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

    crops(isnan(crops))   = 0;                                              % Set all NaNs to zeros for easier processing
    water(isnan(water))   = 0;
    city(isnan(city))     = 0;
    forest(isnan(forest)) = 0;
    elev(isnan(elev))     = 0;
    
    comb = forest;                                                          % Set forest coverage base layer (values of 1)
    
    comb(elev == 1)  = 2;                                                   % Add elevation gradient layer (values of 2)
    
    comb(water == 1) = 3;                                                   % Add standing water layer (values of 3)
    
    comb(crops == 1) = 4;                                                   % Add agricultural development layer (values of 4)
    
    comb(city == 1)  = 5;                                                   % Add urban development layer (values of 5)
    
    comb(comb == 0)  = NaN;                                                 % Set all else to NaN
    
    reserve = comb;
    reserve(reserve > 0)    = 0;
    reserve(isnan(reserve)) = 1;
    reserve(reserve == 0)   = NaN;
        
    combW = reserve .* wind;                                                % Add combined map layers to wind speed map

    fprintf('\n------------------------')                                   % Print completed function to screen
    fprintf('\n---Combine Map Layers---')
    fprintf('\n------------------------\n')

end