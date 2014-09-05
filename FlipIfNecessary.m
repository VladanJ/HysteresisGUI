function [ XX, YY ] = FlipIfNecessary( Xvalues, Yvalues )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

Xmin = Xvalues(1);

if (Xmin ~= min(Xvalues))
    XX = rot90(Xvalues,2);
    YY = rot90(Yvalues,2);
else
    XX = Xvalues;
    YY = Yvalues;
end

end

