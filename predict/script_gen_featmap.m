
clear parsed scale_t featmap;
addpath(fullfile(pwd, 'utils'));
%% load param (please do not modify)
param.net_def_dir = fullfile(pwd, 'model/res_pool2');
param.init_model = fullfile(pwd, 'output/ResNet_3b_s16/tot_wometa_1epoch');
param.solverfile = 'solver_test.prototxt';

%% load list

%% active mex, no need if the path has been set
if false
    addpath(pwd);
    t = pwd;
    cd(fullfile( '+caffe', 'private'));
    caffe.init_log(fullfile(param.caffe_log_dir, 'caffe'));
    cd(t);
end
clear t parsed;

%% init caffe solver
caffe.reset_all;
caffe_solver = caffe.get_solver(fullfile(param.net_def_dir, param.solverfile), param.gpu_id);
if ~isempty(param.init_model)
    assert(exist(param.init_model)==2, 'Cannot find caffemodel.');
    caffe_solver.use_caffemodel(param.init_model);
end
caffe_solver.set_phase('test');
num = length(list);
if ~exist('scale', 'var')
    scale = cellfun(@(x) 1:5, list, 'uni', 0);
end
test_num = ceil(num/length(param.gpu_id));
for i = 1 : test_num
    ti = tic();
    drawnow;
    fprintf('Step 1 fcn: %d/%d...', i, test_num);
    now_id = mod((i-1)*length(param.gpu_id):i*length(param.gpu_id)-1, num) + 1;
    list_t = list(now_id);
    for j = 1 : length(now_id)
        scale_t(j) = min(max(scale{now_id(j)})-5, 0);
    end
    featmap(now_id) = gen_featmap( list_t, caffe_solver, param, scale_t );
    toc(ti);
end
% GOTO Step2: featmap 2 featmap -- script_featmap_transfer.m
