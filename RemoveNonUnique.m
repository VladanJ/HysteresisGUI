function [ XX, YY ] = RemoveNonUnique( Xvalues, Yvalues )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

sizeOfArray = length(Xvalues);
endArrayIndex = 1;
XX = [];
YY = [];
XX(endArrayIndex) = Xvalues(1);
YY(endArrayIndex) = Yvalues(1);
for index = 2 : sizeOfArray
    if ismember(Xvalues(index),Xvalues(1:(index-1)))
    %if Xvalues(index) == Xvalues(subindex)
        continue;
    else
        endArrayIndex = endArrayIndex +1;
        XX(endArrayIndex) = Xvalues(index);
        YY(endArrayIndex) = Yvalues(index);
    end
end

end

