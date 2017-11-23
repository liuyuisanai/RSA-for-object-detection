for i = 1 : length(missed)
    if ~isempty(missed{i})
        I = imread(fullfile(param.dataset_root, val2db.list{i}));
        hold on
        r = missed{i};
        r=[r(:,[1,2]) r(:,3)-r(:,1) r(:,4)-r(:,2)];
        I = insertShape(I, 'rectangle', r);
        imshow(I)
        waitforbuttonpress;
    end
end