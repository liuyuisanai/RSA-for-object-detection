function featmap_trans = gen_trans_featmap( featmap_t, caffe_solver, scale )
    scale = unique(min(scale, 5));
    ori_scale = max(scale);
    featmap_trans{1} = featmap_t;
    test_time = numel(find(scale<ori_scale));
    sidx = find(scale<ori_scale);
    sidx = sort(sidx, 'descend');
    for i = 1:length(sidx)
        scale_t = scale(sidx(i));
        if i == 1
            diffcnt = ori_scale - scale_t;
        else
            diffcnt = scale(sidx(i-1)) - scale_t;
        end
        inmap = featmap_trans{i};
        for cnt = 1 : diffcnt
            input{1}{1} = single(inmap);
            caffe_solver.reshape_as_input(input);
            caffe_solver.set_input_data(input);
            caffe_solver.forward_prefilled();
            o = caffe_solver.get_output();
            inmap = o{1}.data;
        end
        featmap_trans{i+1} = o{1}.data;
    end
end