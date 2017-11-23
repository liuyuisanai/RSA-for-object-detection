function parsed_all = detect_all( list, param, caffe_solver, scale, thres, display, cutedge )
    num = length(list);
    if nargin < 6
        display = 0;
    end
    if ~exist('cutedge', 'var')
        cutedge = 1;
    end
    test_time = ceil(num / length(param.gpu_id));
    for i = 1 : test_time
        if display
            tic;
            fprintf('Testing: %d/%d...', i, test_time);
        end
        now_id = mod((i-1)*length(param.gpu_id):i*length(param.gpu_id)-1, num)+1;
        for id = 1 : length(param.gpu_id)
            if ischar(list{i})
                img_t{id} = cv.imread(fullfile(param.dataset_root, list{now_id(id)}));
                if size(img_t{id}, 3) < 3
                    img_t{id} = img_t{id}(:,:,[1 1 1]);
                end
            else
                img_t = list(now_id(id));
            end
        end
        parsed = [];
        for s = scale
            target_now = param.max_img * 2^s;
            if target_now > param.max_img
                for j = 1 : length(param.gpu_id)
                    [ img_{j}, scale_now(j) ] = scale_img_to_target( img_t{j}, target_now ); % scale = now / pre
                end
                parsed_t = detect_large_img(img_, caffe_solver, param, thres);
            else
                for j = 1 : length(param.gpu_id)
                    [ img, scale_now(j) ] = scale_img_to_target( img_t{j}, target_now ); % scale = now / pre
                    input{j}{1} = single(convert_img2caffe(img)) - 127.0;
                end
                caffe_solver.reshape_as_input(input);
                caffe_solver.set_input_data(input);
                caffe_solver.forward_prefilled();
                parsed_t = convert_output_to_struct( param, caffe_solver, 1, thres);
            end
            for j = 1 : length(parsed_t)
                parsed_t(j).box = round(parsed_t(j).box / scale_now(j));
                parsed_t(j).point = round(parsed_t(j).point / scale_now(j));
                if cutedge && ~isempty(parsed_t(j).box)
                    parsed_t(j).box(:,[1, 2]) = max(1,  parsed_t(j).box(:,[1, 2]));
                    parsed_t(j).box(:,3) = min(parsed_t(j).box(:, 3), size(img_t{j}, 2));
                    parsed_t(j).box(:,4) = min(parsed_t(j).box(:, 4), size(img_t{j}, 1));
                end
                parsed_t(j).box(:, end+1) = parsed_t(j).cls_score;
            end
            if s == scale(1)
                parsed = parsed_t;
            else
                for j = 1 : length(param.gpu_id)
                    parsed(j).cls_score = cat(1, parsed(j).cls_score, parsed_t(j).cls_score);
                    %parsed(j).active = cat(1, parsed(j).cls_score, parsed_t.cls_score);
                    parsed(j).box = cat(1, parsed(j).box, parsed_t(j).box);
                    parsed(j).point = cat(1, parsed(j).point, parsed_t(j).point);
                end
            end
        end
        parsed_all(now_id) = parsed;
        if display
            toc;
        end
    end
end

