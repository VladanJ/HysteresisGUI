function [ Xoutput, Youtput] = Denormalize( Xinputs, Yinputs, Xfactor, Xoffset, Yfactor, Yoffset, N)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    Xoutput = (Xinputs .* Xfactor) ./N + Xoffset;
    Youtput = (Yinputs .* Yfactor) ./N + Yoffset;
end

