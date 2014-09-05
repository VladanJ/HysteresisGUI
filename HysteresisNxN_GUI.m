function [ sumC, matrix ] = HysteresisNxN_GUI( x, hysteresis, matrix, mode)
%HysteresisNxN: Hysteresis on NxN matrix
%   Detailed explanation goes here

Nsize = size(hysteresis);

N = Nsize(1);

length = size(x);
sumC(1:length(2)) = 0;

DoSum = 1;
if strcmp(mode,'depolarizing')
    DoSum = 0;
end

for n=1:1:length(2),
    if x(n)<1
        matrix = zeros(N,N);
    elseif x(n)<N
        matrix(x(n),:) = 1;
        matrix(x(n),x(n)+1:end) = 0;
        matrix(:,x(n)+1)=0;
    elseif x(n)==N
        matrix(x(n),:) = 1;
    elseif x(n)>N
        matrix = ones(N,N);
    end
    if DoSum
        sumR = sum(matrix.*hysteresis);
        sumC(n) = sum(sumR);
    end
end
 
        
end

