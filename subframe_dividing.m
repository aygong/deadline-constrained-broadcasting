function [subframes] = subframe_dividing(D,K)
% Divide a frame into consecutive subframes
% D: the delivery deadline (in time slots)
% K: the number of copies of every packet to be transmitted
r = mod(D,K);
subframes = zeros(1,K);
if r == 0
    subframes(1:K) = D/K;
else
    subframes(1:K-r) = floor(D/K);
    subframes(K-r+1:K) = ceil(D/K);
end