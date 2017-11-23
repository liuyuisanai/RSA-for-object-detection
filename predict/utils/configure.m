%% load data annotation
param.anno_pos = {'annotation/my_pos', 'annotation/renren_pos', 'annotation/newrenren_pos', 'annotation/imdb1_pos.mat', 'annotation/meta_pos.mat'};
param.anno_neg = {'annotation/my_neg', 'annotation/renren_neg', 'annotation/newrenren_neg'};
param.dataset_root = 'G:\temp\face\detection';


%% load net
param.model_name = 'ResNet_3b_s16_fm2fm_feat_deep';
param.solverfile = 'solver_train.prototxt';
param.netnolossfile = 'net_noloss.prototxt';
assert(~isempty(param.netnolossfile));
param.net_def_dir = fullfile(pwd, 'model', 'rpn_prototxts', param.model_name);
param.output_dir = fullfile(pwd, 'output', param.model_name);

%% configure training setting
param.gpu_id = 0:3;
param.pos_gpu = 0:3;
param.neg_gpu = 0;
param.batch_size_per_gpu = 1;
% param.anchor_is_stride_center = true; % always true
param.speedup = 1;
param.max_img = 1200;
param.max_pos_img = 1200;
param.min_img = 32;
param.max_target = 1024;
param.min_target = 32;
param.val_num = 128;
param.fast_valid = 1;
param.test_interval = 10000;
param.snapshot_interval = 10000;
param.display_interval = 500;
param.max_rand_offset = 5;
param.reg_points_diff = true;
param.anchor_scale = 1;
param.multishape_anchor = false;
param.pos_overlap_ratio = 0.7;
param.neg_overlap_ratio = 0.5;
param.gray_augment_ratio = 0.4;
param.validation_ratio = 0.01;
param.ignore_min_roi = 5;

%% configure init setting
%param.init_model = 'model/pre_trained_models/ResNet-101L/ResNet-101-model.caffemodel';
param.init_model = 'weight_share_feat_new_68w';
param.out_dir = fullfile(pwd, 'output', param.model_name);
param.caffe_log_dir = fullfile(param.out_dir, 'caffe_log/');