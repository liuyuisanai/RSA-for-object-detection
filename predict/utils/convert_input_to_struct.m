function parsed = convert_input_to_struct(input_data, param, thresh_cls)
    for gpu_id = 1:length(input_data)
        cls = convert_caffe2mat(input_data{gpu_id}{2});
        box = convert_caffe2mat(input_data{gpu_id}{3});
        pts = convert_caffe2mat(input_data{gpu_id}{4});
        pts_valid = convert_caffe2mat(input_data{gpu_id}{6});
        fmwidth = size(cls, 2);
        fmheight = size(cls, 1);
        % reshape to [h w anchor]
        cls = reshape(cls, fmheight, fmwidth, param.anchor_scale, 1);
        box = reshape(box, fmheight, fmwidth, 4, param.anchor_scale);
        pts = reshape(pts, fmheight, fmwidth, length(param.anchor_point), param.anchor_scale);
        pts_valid = reshape(pts_valid, fmheight, fmwidth, length(param.anchor_point)/2 , param.anchor_scale);
        for scale = 1 : param.anchor_scale
            anchor_box_len = [param.anchor_box(scale,3) - param.anchor_box(scale,1), param.anchor_box(scale,4) - param.anchor_box(scale,2)];
            [validy, validx] = find(cls(:,:,scale) >= thresh_cls);
            score_t{scale} = [];
            target_box_t{scale} = [];
            target_pts_t{scale} = [];
            pts_score_t{scale} = [];
            for valid_id = 1 : length(validy)
                score_t{scale}(valid_id) = cls(validy(valid_id),validx(valid_id),scale);
                anchor_center_now = [(validx(valid_id)-1)*param.stride (validy(valid_id)-1)*param.stride] + param.anchor_center;
                % for box
                box_delta = reshape(box(validy(valid_id), validx(valid_id), :, scale), 1, []);
                target_box_center = anchor_center_now + box_delta(1:2) .* anchor_box_len;
                target_box_length = anchor_box_len .* box_delta(3:4);
                target_box = [  1,  0,  -0.5,   0;
                                0,  1,  0,   -0.5;
                                1,  0,  0.5,    0;
                                0,  1,  0,    0.5   ] * [target_box_center, target_box_length]';
                target_box_t{scale}(valid_id,:) = target_box';
                % for point
                pts_score = reshape(pts_valid(validy(valid_id), validx(valid_id), :, scale) , 1, []);
                pts_delta = reshape(pts(validy(valid_id), validx(valid_id), :, scale), 1, []);
                anchor_point_now = (param.anchor_point) * max(anchor_box_len) + reshape(repmat(anchor_center_now, [length(param.anchor_point)/2 1])', 1, []);
                target_pts = pts_delta * max(anchor_box_len) + anchor_point_now;
                target_pts_t{scale}(valid_id,:) = target_pts;
                pts_score_t{scale}(valid_id,:) = pts_score;
            end
        end
        parsed(gpu_id).img = convert_caffe2img(input_data{gpu_id}{1}+127)/255;
        parsed(gpu_id).active = cls;
        parsed(gpu_id).cls_score = cell2mat(score_t)';
        parsed(gpu_id).box = cell2mat(target_box_t');
        parsed(gpu_id).point = cell2mat(target_pts_t');
        parsed(gpu_id).point_score = cell2mat(pts_score_t');
    end
end