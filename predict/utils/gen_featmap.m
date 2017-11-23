function featmaps = gen_featmap( list, caffe_solver, param, scale )
    num = length(list);
    featmaps = cell(num,1);
    test_time = ceil(num / length(param.gpu_id));
    for i = 1 : test_time
        now_id = mod((i-1)*length(param.gpu_id):i*length(param.gpu_id)-1, num)+1;
        for id = 1 : length(param.gpu_id)
            if ischar(list{i})
                img_t = imread(fullfile(param.test_root, list{now_id(id)}));
                if ~iscell(img_t) 
                    if size(img_t, 3) < 3
                        img_t = img_t(:,:,[1 1 1]);
                    end
                else
                    img_t = img_t{id}(:,:,[1 1 1]);
                end
            else
                img_t = list(now_id(id));
            end
            input{id}{1} = single(convert_img2caffe(imresize(img_t, param.max_img/max(size(img_t))*2^scale(now_id(id))))) - 127.0;
        end
        caffe_solver.reshape_as_input(input);
        caffe_solver.set_input_data(input);
        caffe_solver.forward_prefilled();
        o = caffe_solver.get_output();
        for j = 1 : length(o)
            featmaps{now_id(j)} = o{j}.data;
        end
    end
end

