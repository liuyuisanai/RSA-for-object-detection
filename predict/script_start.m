%% Step0: compile CaffeMex_v2 and link matlab/+caffe to ./+caffe
%% Step1: load your list in matlab workspace which should be an N-by-1 cell
%% Step2: modify your configuration in "customize configuration"
%% Step3: cd utils and mex nms_mex.cpp
%% Step4: run this script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if false % Set to true if you have FDDB dataset
    % Here we use some imgs in FDDB for an example
    list = textread('G:/temp/face/detection/FDDB/list.txt', '%s');
    list = list(1:64);
    load scale_fddb;
    scale = fddb_cls;
else
    % Test imgs in full scales before we provid code for SFN.
    list = {'testimg1.jpg', 'testimg2.jpg', 'testimg3.jpg', 'testimg4.jpg'};
    clear scale
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% customize configuration
load(fullfile(pwd, 'output', 'ResNet_3b_s16', 'param.mat'));
param.test_root = ''; % Prefix of your list.;
param.caffe_log_dir = fullfile(pwd, 'log/');
param.max_img =2048; 
param.target_ratio = -4:0; % Pyramid layers, best leave it as default (-4:0)
param.det_thresh = 5;
param.plot_thresh = 7;
param.gpu_id = 0:1; % For multiple gpus, just set it as a array. E.g. 0:7.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% run rpn+rsa
caffe.init_log('log/');
script_gen_featmap; % GPU runtime: 5ms per pic on Titan Xp @2048px
script_featmap_transfer; % GPU runtime: 0.3ms per pic on Titan Xp
script_featmap_2_result; % GPU runtime: 3.2ms per pic on Titan Xp
% Detection result (bbox+landmarks) will be storaged in variable `parsed'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% post processing (NMS, set threshold, and show the result)
threshold = 8;
nms_ratio = 0.6;
p = nms_parsed(parsed, threshold, nms_ratio);
plot_parsed(p, threshold, '', list)
