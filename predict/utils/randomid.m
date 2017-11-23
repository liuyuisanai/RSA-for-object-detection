function [ thisid, nowid ] = randomid( maxid, nowid, randomnum )
    if nargin < 3
        randomnum = 1;
    end
    if length(nowid) < randomnum
        nowid = randperm(maxid);
    end
    thisid = nowid(1:randomnum);
    nowid(1:randomnum) = [];
end

