
function rmv_indx=func_rmv_skip(numOfChannels,numOfSkip)

rmv_indx = nan(numOfChannels*3,1);

inj_Pattern = eye(numOfChannels) + circshift(eye(numOfChannels), 1 + numOfSkip); % current injection patterns
mea_Pattern = eye(numOfChannels) + circshift(eye(numOfChannels), 1 + numOfSkip); % voltage measure patterns

cnt = 0;
for i=1:numOfChannels
    for j=1:numOfChannels
        isRmv = inj_Pattern(:,i)' * mea_Pattern(:,j); % check whether it has overlapped 1s.
        if isRmv ~= 0
            cnt = cnt +1;
            rmv_indx(cnt) = (i - 1) * size(mea_Pattern,2) + j;
        end
    end
end




          