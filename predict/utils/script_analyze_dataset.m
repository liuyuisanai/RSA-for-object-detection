clear ra
for i = 1 : length(list)
    s = size(imread(list{i}));
    s = max(s);
    t=gt{i};
    t = t(:,3)-t(:,1);
    t=t/s*2048;
    ra{i} = t;
end
t = cellfun(@(x) unique(11-floor(log2(x))), ra, 'uni', 0);
 class = cellfun(@(x) max(1, min(ceil(log2(x   )*10)-50, 60)), ra, 'uni', 0);