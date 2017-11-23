function [ img, scale ] = scale_img_to_target( img, target )
    pre = max(size(img));
    scale = target / max(size(img));
    img = imresize(img, scale);
    scale = max(size(img)) / pre;
end

