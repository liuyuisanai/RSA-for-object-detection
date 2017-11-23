function pts = convert_pts( ptscell, ptsmap )
    pts = zeros(0, 42, 'int16');
    for i = 1 : length(ptscell)
        pf = fieldnames(ptscell{i});
        assert(length(pf) == 21);
        for j = 1 : 21
            field = pf{j};
            idx = ptsmap(field);
            pts(i, idx*2-1:idx*2) = round(getfield(ptscell{i}, field));
        end
    end

end
