function rect = convert_ignore( reccell )
    rect = zeros(0, 4, 'int16');
    for i = 1 : length(reccell)
        rect(i, :) = round([reccell{i}.x, reccell{i}.y, reccell{i}.w, reccell{i}.h]);
    end

end

