function out = convert_caffe2img( out )
    assert(length(size(out)) <= 4, 'Only support at most 4-D data for convert.');
    out = single(permute(out(:,:,end:-1:1,:), [2 1 3 4]));
end
