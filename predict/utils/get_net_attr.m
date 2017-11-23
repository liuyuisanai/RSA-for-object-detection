function response = get_net_attr( netfile, maxsize )
    t = caffe.get_net(netfile, 'test');
    for i = maxsize:-1:1
        input = {zeros(i,i,3,1,'single')};
        t.reshape_as_input(input);
        t.reshape();
        response(i) = size(t.blobs(t.outputs{1}).get_data(), 1);
        if response(i) < 1
            break;
        end
    end
    caffe.reset_all;
end

