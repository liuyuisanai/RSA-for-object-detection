addpath('utils');
clear parsed;
%% configure your own
root = ''; % lfw
%% load param
timestamp = strrep(mat2str(clock), ' ', '');
load(fullfile(pwd, 'output', 'ResNet_3b_s16', 'param.mat'));
% diary(fullfile(param.output_dir, ['test-' fullfile(timestamp) '.txt']));
param.init_model = fullfile(pwd, 'output/ResNet_3b_s16/tot_wometa_1epoch'); %fullfile(pwd, 'output/ResNet-101L/1000000');
param.solverfile = 'solver_test.prototxt';
param.net_def_dir = fullfile(pwd, 'model', 'ResNet_3b_s16');
param.max_img =300;
%% load list
list_test = list;
param.dataset_root = '';
if ~exist('work_num', 'var')
    work_num = 1;
end
if ~exist('work_id', 'var')
    work_id = 1;
end
param.gpu_id = 0:3;
l = length(list_test)/work_num;
thisid = floor(l * (work_id-1)+1):ceil(l*work_id);
thisid(thisid>length(list_test))=[];
list = list_test(thisid);
fprintf('worker: %d / %d\n', work_id, work_num);
%% active mex


%% init caffe solver
caffe.reset_all;
caffe_solver = caffe.get_solver(fullfile(param.net_def_dir, param.solverfile), param.gpu_id);
if ~isempty(param.init_model)
    assert(exist(param.init_model)==2, 'Cannot find caffemodel.');
    caffe_solver.use_caffemodel(param.init_model);
end
num = length(list);
test_num = ceil(num/length(param.gpu_id));
tot_time = tic();
for i = 1 : test_num
    drawnow;
    if mod(i, 100) < 1
        fprintf('Testing %d/%d...', i, test_num);
        toc(tot_time);
    end
    now_id = mod((i-1)*length(param.gpu_id):i*length(param.gpu_id)-1, num) + 1;
    list_t = cellfun(@(x) fullfile(root, x), list(now_id), 'uni', 0);
    parsed_all = detect_all( list_t, param, caffe_solver, [0], 5 );
    for ii = 1 : length(param.gpu_id)
        score = parsed_all(ii).cls_score;
        point = parsed_all(ii).point;
        box = parsed_all(ii).box;
        %box = [box, score];
        if true % traditional nms
            id = nms(box, 0.3);
            if length(id) > 2000
                id = id(1:2000);
                points_new = points_new(1:2000);
            end
            parsed_all(ii).cls_score = score(id);
            parsed_all(ii).box = box(id,:);
            parsed_all(ii).point = point(id,:);
        else % points nms
            [ id, points_new ] = nms_pts( box, point, score, 0.3, 0 );
            if length(id) > 2000
                id = id(1:2000);
                points_new = points_new(1:2000,:);
            end
            parsed_all(ii).cls_score = score(id);
            parsed_all(ii).box = box(id,:);
            parsed_all(ii).point = points_new;
        end
    end
    parsed(now_id) = parsed_all;
end
% save('-v7.3', ['worker' num2str(work_id) 'roi.mat'], 'roi', 'list');
plot_parsed(parsed, 5.81, root, list)