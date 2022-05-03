# WindEnergyProjections

At a high level, this project contains two separate pursuits:
  1. collection and processing of geospatial data, including assimilating data from different sources into a single structure
  2. application of the above information to simulate the progression and expansion of wind energy in the US based on historical trends and future predictions from industry and academic source

<b>The data for this project were collected from the following sources:</b>
  1. Geospatial agricultural development data: United States Department of Agriculture CroplandCROS App<sup>1</sup>
  2. Geospatial water body data: Ibid<sup>1</sup>
  3. Geospatial urban development data: Ibid<sup>1</sup> and US Census Bureau via Data.Gov<sup>2</sup>
  4. Geospatial elevation data: Geospatial Information Authority of Japan via Global Mapping Project (https://globalmaps.github.io)<sup>3</sup>
  5. Geospatial forest cover data: Ibid<sup>4</sup>
  6. Geospatial wind speed map: NREL Wind Prospector<sup>5</sup>
  7. Current wind farm location coordinates: Ibid<sup>6</sup>
  8. Historical trends and future predictions in wind turbine technology advancements: United States Department of Energy<sup>7-9</sup>

<b>Requirements to Run</b>

<b>Data:</b> Download the data from: https://drive.google.com/file/d/1zZARRv8IZAjOBQrMyWTTU6ABGsUOqtO2/view?usp=sharing

All necessary data are contained in the zip file called "TiffData.zip". The unzipped data are 13.5 GB in size.

This program is composed entirely of Matlab .m files. The only requirement for running the program is a working copy of Matlab.

It should be noted that line 4 of Main.m (addpath('...')) should be modified to point to the current location of the data on your machine.

<hr>

<b>Citations</b>

<sup>1</sup><i>CroplandCROS [beta]</i>, National Agricultural Statistical Service. [Online]. Available: https://cropcros.azurewebsites.net Note: Data were too large to be downloaded together. In total, 31 separate files were generated from the CroplandCROS App. Agricultural, water, and city data are all included in the same tiff files.

<sup>2</sup><i>TIGER/Line Shapefile, 2019, nation, U.S., Current Metropolitan Statistical Area/Micropolitan Statistical Area (CBSA) National</i>, United States Census Bureau, Oct. 2021. [online]. Available: https://catalog.data.gov/dataset/tiger-line-shapefile-2019-nation-u-s-current-metropolitan-statistical-area-micropolitan-statist

<sup>3</sup><i>Elevation - Global version - Version 2</i>, Geospatial Information Authority of Japan, Feb. 2017. [online]. Available: https://github.com/globalmaps/gm_el_v2_west

<sup>4</sup><i>Vegetation (Percent Tree Cover) - Global version - Version 2</i>, Geospatial Information Authority of Japan, Feb. 2017. [online]. Available: https://github.com/globalmaps/gm_ve_v2

<sup>5</sup><i>110-Meter Hub Height (Current Technology)</i>, National Renewable Energy Laboratory. [online]. Available: https://maps.nrel.gov/wind-prospector

<sup>6</sup><i>Wind Farm Sites</i>, National Renewable Energy Laboratory. [online]. Available: https://maps.nrel.gov/wind-prospector

<sup>7</sup> United States Department of Energy, “Wind Vision: A New Era for Wind Power in the United States,” DOE/GO-102015-4557, Apr. 2015. [Online]. Available: https://www.energy.gov/sites/prod/files/WindVision_Report_final.pdf

<sup>8</sup> United States Department of Energy, “Land-Based Wind Market Report,” DOE/GO-102021-5611, Aug. 2021. [Online]. Available: https://www.energy.gov/sites/default/files/2021-08/Land-Based%20Wind%20Market%20Report%202021%20Edition_Full%20Report_FINAL.pdf

<sup>9</sup> United States Department of Energy. "Map: Projected Growth of the Wind Industry From Now Until 2050." Energy.Gov. https://www.energy.gov/maps/map-projected-growth-wind-industry-now-until-2050 (accessed Apr. 2, 2022).
