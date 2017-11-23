function out = convert_caffe2mat( out )
    assert(length(size(out)) <= 4, 'Only support at most 4-D data for convert.');
    out = single(permute(out, [2 1 3 4]));
end

