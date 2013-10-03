function  Ledarun()
%LEDARUN Summary of this function goes here
%   Detailed explanation goes here

clc;
close all;
clear global leda2

global leda2

leda2.intern.name = 'Ledalab';
leda2.intern.version = 3.44;
versiontxt = num2str(leda2.intern.version,'%3.2f');
leda2.intern.versiontxt = ['V',versiontxt(1:3),'.',versiontxt(4:end)];
leda2.intern.version_datestr = '2013-06-11';

%Add all subdirectories to Matlab path
file = which('Ledalab.m');
if isempty(file)
    errormessage('Can''t find Ledalab installation. Change to Ledalab install directory');
    return;
end
leda2.intern.install_dir = fileparts(file);
addpath(genpath(leda2.intern.install_dir));

ledapreset;

leda2.intern.batchmode = 1;
leda2.intern.prompt = 0;
leda2.pref.updateFit = 0;


%%%% LEDA BATCH ANALYSIS
pathname = './';
% leda2.current.batchmode.file = [];
% leda2.current.batchmode.command.pathname = pathname;
% leda2.current.batchmode.command.datatype = 'text';
% leda2.current.batchmode.command.downsample = downsample_factor;
% leda2.current.batchmode.command.smooth = smooth_settings;
% leda2.current.batchmode.command.method = analysis_method;
% leda2.current.batchmode.command.optimize = do_optimize;
% leda2.current.batchmode.command.overview = do_save_overview;
% leda2.current.batchmode.command.export_era = export_era_settings;
% leda2.current.batchmode.command.export_scrlist = export_scrlist_settings;
% leda2.current.batchmode.start = datestr(now, 21);
% leda2.current.batchmode.version = leda2.intern.version;
% leda2.current.batchmode.settings = leda2.set;
tic

filename = 'input.csv';
% filename = 'leda_test.session.txt';

disp(' '); add2log(1,['Batch-Analyzing ',filename],1,0,0,1)

import_data('text4', pathname, filename);

leda2.data.conductance.data
% leda2.data.time.data

%leda_downsample(4, 'mean');  %MB 11.06.2013
adaptive_smoothing;

sdeco(1);

M = [leda2.analysis.tonicData;leda2.analysis.phasicData];
dlmwrite('output.csv', 1);
% dlmwrite('output2.csv', M);

leda2.set.export.SCRmin = 0.01;
leda2.set.export.savetype = 3;
export_scrlist('saveList');

% analysis_overview;

% exit();

end

