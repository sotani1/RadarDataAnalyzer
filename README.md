# RadarDataAnalyzer Tool    2019/4/27
Radar Data Analyzer Tool for SHRP2 NDS and other data sources.
The primary function of this tool is to be able to read csv or MAT file data and plot ego vehicle and surrounding vehicle characteristics all in the same script.
This tool was featured in the Apri 2018 SHRP2 NDS webinar series "Insight Webinar: Data Analysis Tool Development SHRP2 NDS".
https://insight.shrp2nds.us   (User registration required)

# How-to-use
Just follow these simple steps:
  Step 1) Place data to be analyzed in the "dfolder" directory.
          *Note: You may place a csv file or a MAT file
  Step 2) Define your parameters in "cm1_varlist" (for .MAT type) or "cm1_varlist_shrp2" (for .csv type)
  Step 3) Run "cm0_radar_data_analyzer" script
  Step 4) After data are stored in workspace, run "cm3_plotfig" script located under the "program_1" directory.

# Description of main script (program_1)
This script is designed to be an opensource script to ingest SHRP2 NDS data and other data custom data types (e.g. CANape).
This script features four main modules under the master script "cm0_radar_data_analyzer".
 1. cm1_varlist_shrp2: Registers the variable names to be read by script
 2. cm2_1_dataset_unique:  Assigns values to each variables defined in "cm1_varlist_shrp2".
 3. cm2_2_setvar_shrp2:  Stores raw data and calculated data (including radar target data) in the structure "M_data". 
 4. cm3_plotfig:  Plots processed radar signals and ego vehicle kinematic data in 3D scatter plots and time-series format.
 
 # Additional automated post-processing scripts (program_2)
 Several post-processing scripts have been prepackaged as well.
 In this package, analysis for Gas-On-Brake-Off sequences (GOBO) were applied on the SHRP2 dataset.
 Post processed results and log files are exported to the following folders:
   dfolder_gobo, dfolder_gobo_log, dfolder_map, dfolder_log
 
 # Disclaimer
 This tool is not intended for developmental use.  Use with provision.
 Copyright 2017, Edward Shinji Otani, All rights reserved.
