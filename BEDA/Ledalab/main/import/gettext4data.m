function [time, conductance, event] = gettextdata4(fullpathname)

% Matlab V7.x+
% fid = fopen(fullpathname);
% data = textscan(fid, '%f %f','headerlines',0);
% fclose(fid);
%
% time = data{1}';
% conductance = data{2}';
% event = {};

%V213
%[time, conductance] = textread(fullpathname,'%f\t%f','headerlines',0);
%event = {};

M = dlmread(fullpathname);

conductance = M(:,1);
time = (1:length(conductance)) / 8.0;
event = [];

end
