function [ input, ok ] = prepare_data_for_test( root, list, param )
% input{1} : imgs
% input{2} : featuremap label
% input{3} : bbox regression
% input{4} : pts regression
% input{5} : box valid
% input{6} : pts valid label
% input{7} : pts valid (each axis)
    ok = 0;
    input = cell(length(param.gpu_id));
    boxcat = cell2mat(box);
    if ~check_input_is_valid(boxcat, param.ignore_min_roi)
        return;
    end
    try
        for i = 1 : length(list)
            img_t = imread(fullfile(root, list{i}));
            box_t = box{i};
            pts_t = pts{i};
            valid_t = valid{i};
            ptsed_t = ptsed{i};
            fullanno_t = fullanno(i);
            
            imsize = size(img_t);
            if imsize(3) < 3
                img_t = img_t(:,:,[1 1 1]);
            end
            [img_t, bbox_new, pts_new, valid_new] = random_crop_img(img_t, box_t, pts_t, valid_t, ptsed_t, fullanno_t, param);
            imsize = size(img_t);
            [label_t, boxreg_t, ptsreg_t, box_valid_t, pts_valid_label_t, pts_valid_t, mask_t] = ...
                prepare_label(imsize, bbox_new, pts_new, valid_new, ptsmean, param);
            input{i}{1} = single(convert_mat2caffe(img_t));
            input{i}{2} = convert_mat2caffe(label_t);
            input{i}{3} = convert_mat2caffe(boxreg_t);
            input{i}{4} = convert_mat2caffe(ptsreg_t);
            input{i}{5} = convert_mat2caffe(box_valid_t);
            input{i}{6} = convert_mat2caffe(pts_valid_label_t);
            input{i}{7} = convert_mat2caffe(pts_valid_t);
        end
    catch
       ok = 0;
       return; 
    end
    ok = 1;
end

function ok = check_input_is_valid(box, minb)
    ok = 0;
    if min(box(:,3)-box(:,1)) < minb || min(box(:,4)-box(:,2)) < minb
        return;
    end
    ok = 1;
end
