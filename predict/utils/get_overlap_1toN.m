function overlap_ratio = get_overlap_1toN(rect1, rect2, cover)
% rect1: 1*4 
% rect2: N*4 (left top right bottom)
% cover: 0: o/(s1+s2-o) 1: o/s1 2:o/min(s1,s2) 3: 0/s2
    if nargin < 3
        cover = 0;
    end
    rect1 = repmat(rect1, [size(rect2, 1) 1]);

    area1 = (rect1(:, 3) - rect1(:, 1)) .* (rect1(:, 4) - rect1(:, 2));
    area2 = (rect2(:, 3) - rect2(:, 1)) .* (rect2(:, 4) - rect2(:, 2));

    l = max(rect1(:, 1), rect2(:, 1));
    r = min(rect1(:, 3), rect2(:, 3));
    t = max(rect1(:, 2), rect2(:, 2));
    b = min(rect1(:, 4), rect2(:, 4));

    w = r - l;
    h = b - t;
    overlap = w .* h;
    overlap(w < 0 | h < 0) = 0;
    if cover == 1
        overlap_ratio = overlap ./ area1;
    elseif cover == 2
        overlap_ratio = overlap ./ min(area1, area2); 
    elseif cover == 3
        overlap_ratio = overlap ./ area2; 
    else
        overlap_ratio = overlap ./ (area1 + area2 - overlap);
    end
end