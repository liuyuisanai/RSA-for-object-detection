function parsed_all = detect_all_by_featmap( featmap, scale, param, caffe_solver, thres )
    scale = 2.^(scale(end:-1:1)-5);
    parsed = [];
    for s = 1:numel(featmap)
        caffe_solver.reshape_as_input({{featmap{s}}});
        caffe_solver.set_input_data({{featmap{s}}});
        caffe_solver.forward_prefilled();
        parsed_t = convert_output_to_struct( param, caffe_solver, 1, thres);
        for j = 1 : length(parsed_t)
            parsed_t(j).box = round(parsed_t(j).box / scale(s));
            parsed_t(j).point = round(parsed_t(j).point / scale(s));
            parsed_t(j).box(:, end+1) = parsed_t(j).cls_score;
        end
        if s == 1
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
    parsed_all = parsed;
end

