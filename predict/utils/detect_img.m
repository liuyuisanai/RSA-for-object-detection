function [scores, rects, pts, pts_valid] = detect_img( param, caffe_solver, thres )
    num = length(list);
    test_time = ceil(num / length(param.gpu_id));
    for i = 1 : test_time
        target_scale_now = param.max_img * 
        for j = 1 : length(param.gpu_id)
            [ img, scale ] = scale_img_to_target( img, target )
        end
    end
    

end

