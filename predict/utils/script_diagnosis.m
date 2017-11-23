% th = mins + (maxs-mins)/1000*[1:1000];
% plot(th, precision);
% hold on
% plot(th, recall, 'g');grid on
% plot(th, err_num)
th = 7;
for i = 1 : length(parsed)
    detected{i} = parsed(i).box(parsed(i).cls_score >= th, :);
    id = nms(detected{i}, 0.6);
    detected{i} = detected{i}(id,:);
end
[recall, precision, error_img,miss_image,err_detail,miss_detail , err_num, ~] =  evaluate_detection_result(gt, detected, 0.3, gt_missed);
dump_error(list, error_img, err_detail, miss_image, miss_detail, gt)