function parsed = detect_large_img(img_t, caffe_solver, param, thres)
    grid = param.max_img;
    assert(length(img_t) == length(param.gpu_id));
    max_x = 0;
    max_y = 0;
    for j = 1 : length(param.gpu_id)
        max_x = max(max_x, size(img_t{j}, 2));
        max_y = max(max_y, size(img_t{j}, 1));
    end
%     pad = ceil(param.min_target *  max(max_x, max_y) / param.max_img);
    pad = param.max_target;
    grid_x = ceil(max_x / (grid - pad));
    grid_y = ceil(max_y / (grid - pad));
    for j = 1 : length(param.gpu_id)
        img = img_t{j};
        s = size(img);
        g_l = ceil(s(1:2)./[grid_y grid_x]);
        x_start{j} = 1:g_l(2):s(2);
        x_end{j} = min(x_start{j} + g_l(2) + pad, size(img, 2));
        y_start{j} = 1:g_l(1):s(1);
        y_end{j} = min(y_start{j} + g_l(1) + pad, size(img, 1));
    end
    for x = 1 : grid_x
        for y = 1 : grid_y
            for j = 1 : length(param.gpu_id)
                if length(y_start{j}) < y || length(x_start{j}) < x
                    input{j}{1} = zeros(50,50,3,'single');
                    continue;
                end
                img = img_t{j}(y_start{j}(y):y_end{j}(y), x_start{j}(x):x_end{j}(x),:);
                input{j}{1} = single(convert_img2caffe(img)) - 127.0;
            end
            caffe_solver.reshape_as_input(input);
            caffe_solver.set_input_data(input);
            caffe_solver.forward_prefilled();
            parsed_t = convert_output_to_struct( param, caffe_solver, 1, thres);
            for j = 1 : length(parsed_t)
                if isempty(parsed_t(j).cls_score)
                    continue;
                end
                parsed_t(j).box(:,[1 3]) = round(parsed_t(j).box(:,[1 3]) + x_start{j}(x));
                parsed_t(j).box(:,[2 4]) = round(parsed_t(j).box(:,[2 4]) + y_start{j}(y));
                parsed_t(j).point(:,1:2:end) = round(parsed_t(j).point(:,1:2:end) + x_start{j}(x));
                parsed_t(j).point(:,2:2:end) = round(parsed_t(j).point(:,2:2:end) + y_start{j}(y));
            end
            if ~exist('parsed', 'var')
                parsed = parsed_t;
            else
                for j = 1 : length(param.gpu_id)
                    parsed(j).cls_score = cat(1, parsed(j).cls_score, parsed_t(j).cls_score);
                    parsed(j).point = cat(1, parsed(j).point, parsed_t(j).point);
                    parsed(j).box = cat(1, parsed(j).box, parsed_t(j).box);
                end
            end
        end
    end
end