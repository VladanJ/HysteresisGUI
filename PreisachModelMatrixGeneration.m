function [ hysteresisMatrix, Xfactor, Xoffset, Yfactor, Yoffset] = PreisachModelMatrixGeneration( LowerpartOfLoopX,  LowerpartOfLoopY, UpperpartOfLoopX, UpperpartOfLoopY, N)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


LowerXsize = size(LowerpartOfLoopX);
LowerYsize = size(LowerpartOfLoopY);
UpperXsize = size(UpperpartOfLoopX);
UpperYsize = size(UpperpartOfLoopY);

if (LowerXsize(2)==1) 
    LowerpartOfLoopX = transpose(LowerpartOfLoopX);
elseif (LowerXsize(1)~=1)
    error('At least one dimension of input matrix must be 1!!!');
end  

if (LowerYsize(2)==1) 
    LowerpartOfLoopY = transpose(LowerpartOfLoopY);
elseif (LowerYsize(1)~=1)
    error('At least one dimension of input matrix must be 1!!!');
end

if (UpperXsize(2)==1) 
    UpperpartOfLoopX = transpose(UpperpartOfLoopX);
elseif (UpperXsize(1)~=1)
    error('At least one dimension of input matrix must be 1!!!');
end
if (UpperYsize(2)==1)
    UpperpartOfLoopY = transpose(UpperpartOfLoopY);
elseif (UpperYsize(1)~=1)
    error('At least one dimension of input matrix must be 1!!!');
end



if isequal(size(LowerpartOfLoopX), size(LowerpartOfLoopY))
    if isequal(size(UpperpartOfLoopX), size(UpperpartOfLoopY))
        
        
        
        % removing non unique values in X values array, and coresponding Y values 
        [LowerpartOfLoopX, LowerpartOfLoopY] = FlipIfNecessary( LowerpartOfLoopX, LowerpartOfLoopY );
        [LowerpartOfLoopX,LowerpartOfLoopY] = RemoveNonUnique( LowerpartOfLoopX, LowerpartOfLoopY );
        [UpperpartOfLoopX, UpperpartOfLoopY] = FlipIfNecessary( UpperpartOfLoopX, UpperpartOfLoopY );
        [UpperpartOfLoopX,UpperpartOfLoopY] = RemoveNonUnique( UpperpartOfLoopX, UpperpartOfLoopY );
        
        
        

        InputN = [1:1:N];

        [Out, XfactorA, XoffsetA, YfactorA, YoffsetA] = NormalizationAndInterpolation(LowerpartOfLoopX, LowerpartOfLoopY, N);
        [Out2, XfactorB, XoffsetB, YfactorB, YoffsetB] = NormalizationAndInterpolation(UpperpartOfLoopX, UpperpartOfLoopY, N);

        UpperLoopValues = ppval(Out2,InputN);
        LowerLoopValues = ppval(Out,InputN);


        UpperLoopDeltas = [UpperLoopValues(1),[UpperLoopValues(2:N)-UpperLoopValues(1:N-1)]];
        LowerLoopDeltas = [LowerLoopValues(1),[LowerLoopValues(2:N)-LowerLoopValues(1:N-1)]];
        
        %csvwrite('UpperLoopDeltas.csv',UpperLoopDeltas);
        %csvwrite('LowerLoopDeltas.csv',transpose(LowerLoopDeltas));

        hysteresisMatrix = HysteresisMatrixCreation(transpose(UpperLoopDeltas), transpose(LowerLoopDeltas), N, 4, 1);
        
        %csvwrite('hysteresisMatrix.csv',hysteresisMatrix);
        
        XYparam = ([XfactorA, XoffsetA, YfactorA, YoffsetA] + [XfactorB, XoffsetB, YfactorB, YoffsetB])/2;
        Xfactor = XYparam(1);
        Xoffset = XYparam(2);
        Yfactor = XYparam(3);
        Yoffset = XYparam(4);
    else
        error('Upper curve X and Y values array must be of equal lenght!!!');
    end
else
    error('Lower curve X and Y values array must be of equal lenght!!!');
end


end

