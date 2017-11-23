%% modify param
param.net_def_dir = 'model/ResNet_3b_s16_fm2fm_pool2_deep';
param.gpu_id = 0;
param.init_model = fullfile(pwd, 'output/ResNet_3b_s16_fm2fm_pool2_deep/65w');

%% init caffe solver
caffe.reset_all;
caffe_solver = caffe.get_solver(fullfile(param.net_def_dir, param.solverfile), param.gpu_id);
if ~isempty(param.init_model)
    assert(exist(param.init_model)==2, 'Cannot find caffemodel.');
    caffe_solver.use_caffemodel(param.init_model);
end
caffe_solver.set_phase('test');
num = length(list);
clear featmap_trans
for i = 1 : num
    ti = tic();
    drawnow;
    fprintf('Step 2 rsa:  %d/%d...', i, num);
    scale{i} = unique(min(scale{i},5));
    if numel(find(scale{i}<=5)) > 1 
        featmap_t = featmap{i};
        scale_t = scale{i};
        featmap_trans{i} = gen_trans_featmap( featmap_t, caffe_solver, scale_t );
    else
        featmap_trans{i} = featmap(i);
    end
    toc(ti);
end

% GOTO Step3: featmap 2 result -- script_featmap_2_result.m
