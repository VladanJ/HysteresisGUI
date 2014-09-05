function [ YY, Xfactor, Xoffset, Yfactor, Yoffset] = NormalizationAndInterpolation( x, y, Nout )
%NormalizationAndThousandPointsInterpolation: Summary of this function goes here
%   x       - X axis values starting with the smallest
%   y       - Y axis values
%   Nout    - desired output size
%   YY      - polinomial coefficients



% Normalizing x vector
Xmin = x(1);
length = size(x);
Xmax = x(length(2));

if (Xmin ~= min(x))
    error('First number of FIRST array must be the smallest one!!!');
end

xNormalized = zeros(length(2),1);
Xfactor = Xmax-Xmin;
Xoffset = Xmin;

for n=1:1:length(2),
    xNormalized(n) = x(n) - Xoffset;
    xNormalized(n) = xNormalized(n)/Xfactor;
    xNormalized(n) = xNormalized(n)*Nout;
end

% Normalizing y vector
Ymin = y(1);
length = size(y);
Ymax = y(length(2));

% if (Ymin ~= min(y))
%     error('First number of  SECOND array must be the smallest one!!!');
% end

yNormalized = zeros(length(2),1);
Yfactor = Ymax-Ymin;
Yoffset = Ymin;

for n=1:1:length(2),
    yNormalized(n) = y(n) - Yoffset;
    yNormalized(n) = yNormalized(n)/Yfactor;
    yNormalized(n) = yNormalized(n)*Nout;
end



% adding two points to the end to regulate slope 

X0slope = xNormalized(1) - xNormalized(2) + xNormalized(1);
Xnslope = xNormalized(length(2)) + xNormalized(length(2)) - xNormalized(length(2)-1);
Y0slope = yNormalized(1) - yNormalized(2) + yNormalized(1);
YNslope = yNormalized(length(2)) + yNormalized(length(2)) - yNormalized(length(2)-1);

% splining
YY = spline([X0slope; xNormalized; Xnslope] , [Y0slope; yNormalized; YNslope]);


end

