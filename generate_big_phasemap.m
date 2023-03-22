clear all
close all
clc

nPxp = 590;
addpath D:\Documents\Research\functions_system_phase_pyr 
tic
[X_phase,Y_s] = Generate_phasemap(nPxp,500,1:200,0.5,5);
toc

save('./Phasemaps/Phasemap_500_rand.mat','X_phase','Y_s')