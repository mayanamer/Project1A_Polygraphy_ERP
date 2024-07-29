# Project1A_Polygraphy
our Project 1A - Polygraphy with ERP / EEG signals 

Code Structure

1. text files containing sample values were received. To parse these files and convert them into .mat files, which are more convenient for use in MATLAB, you can run the script save_files.m. This script goes through each text file and, based on the path (which represents the signal type, participant number, and session number), places it in the appropriate matrix.

2. After running save_files, you can run dataStructOrganizer.m, which organizes all the signals into a single, final cell array, providing more convenient access to these signals.

3. The script create_feature_table.m generates a feature table of all the signals and saves it in Excel format, making it easy to import into MATLAB's Classification Learner. This code uses the function extractFeatures, which receives a signal and returns a list of features for that signal. You can add or remove features from there.

3. Besides the files mentioned in points 1-3, there are also many scripts that compute averages, generate signal graphs, box plots, and more.
