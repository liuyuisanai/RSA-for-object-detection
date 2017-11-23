function [ pick, points_new ] = nms_pts( boxes, points, score, overlap, use_gpu )
%NMS_PTS 此处显示有关此函数的摘要
%   此处显示详细说明
    pick = nms(boxes, overlap, use_gpu);
    points_new = zeros(numel(pick), size(points, 2));
    for i = 1 : length(pick)
        o = get_overlap_1toN(boxes(pick(i), :), boxes);
        idx = find(o > 0.65);
        points_new(i,:) = reshape(score(idx), 1, []) * points(idx,:) / sum(score(idx));
    end
end

