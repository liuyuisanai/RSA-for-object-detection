function parsed = nms_parsed(parsed, th, ratio)
    parfor i = 1 : length(parsed)
        vid = find(parsed(i).cls_score >= th);
        detected = parsed(i).box(vid, :);
        id = nms(detected, ratio);
        parsed(i).box = detected(id,:);
        vid = vid(id)
        parsed(i).cls_score = parsed(i).cls_score(vid,:);
        parsed(i).point = parsed(i).point(vid,:);
    end
end