%% load param
param.net_def_dir = 'model/ResNet_3b_s16_f2r';
param.init_model = fullfile(pwd, 'output/ResNet_3b_s16/tot_wometa_1epoch'); %fullfile(pwd, 'output/ResNet-101L/1000000');
param.solverfile = 'solver_test.prototxt';
param.gpu_id = 0;
mins = 3;
maxs = 14;
%% init caffe solver
caffe.reset_all;
caffe_solver = caffe.get_solver(fullfile(param.net_def_dir, param.solverfile), param.gpu_id);
if ~isempty(param.init_model)
    assert(exist(param.init_model)==2, 'Cannot find caffemodel.');
    caffe_solver.use_caffemodel(param.init_model);
end
caffe_solver.set_phase('test');
num = length(featmap_trans);
cons = 0;
hit = 0;
sums = 0;
missed = cell(num, 1);
recall = 0;
for i = 1 : num
    ti = tic();
    drawnow;
    fprintf('Step 3 rpn:  %d/%d...', i, num);
    parsed(i) = detect_all_by_featmap( featmap_trans{i}, unique(min(scale{i}, 5)), param, caffe_solver, mins);
    toc(ti);
end
fprintf('Modify scale...')
for i = 1 : num
    s = max(size(imread(fullfile(param.test_root, list{i}))))/param.max_img;
    parsed(i).box(:,1:4) = parsed(i).box(:,1:4) * s;
    parsed(i).point = parsed(i).point * s;
end
fprintf('Done\n');
