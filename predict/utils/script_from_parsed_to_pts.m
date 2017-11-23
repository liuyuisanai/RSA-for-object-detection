pts = zeros(length(parsed), 10);
err = [];
for i = 1 : length(parsed)
    boxs = parsed(i).box;
    score = parsed(i).cls_score;
    if isempty(boxs)
        err(i)=1;
        continue;
    end
    if false % by overlap
        o = get_overlap_1toN([44 91 132 175], boxs);
        [~,it] = sort(o, 'descend');
        pts(i,:) = parsed(i).point(it(1),:);
    elseif false % by score
        [~,it] = sort(score, 'descend');
        pts(i,:) = parsed(i).point(it(1),:);
    elseif true % by area
        area = boxs(:, 3) - boxs(:,1);
        [~,it] = sort(area, 'descend');
        pts(i,:) = parsed(i).point(it(1),:);
    elseif true % center
        
    end
end
err=find(err);