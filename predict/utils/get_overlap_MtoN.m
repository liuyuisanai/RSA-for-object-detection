function overlap_ratio = get_overlap_MtoN(rect1, rect2, cover)
% TODO: is there a better way?
    if nargin < 3
        cover = 0;
    end
    overlap_ratio = zeros(size(rect1, 1), size(rect2, 1));
    for i = 1 : size(rect1, 1)
        overlap_ratio(i,:) = get_overlap_1toN(rect1(i,:), rect2, cover);
    end
end