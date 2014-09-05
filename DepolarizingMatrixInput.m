function [ depolarizingmatrix ] = DepolarizingMatrixInput( sizeOfMatrix )

    
    depolarizingmatrix = [1:1:sizeOfMatrix];
    
    aaa = sizeOfMatrix - 1;
    bbb = 2;
    for x=3 : sizeOfMatrix/2,
        depolarizingmatrix = [depolarizingmatrix,[aaa:-1:bbb]];
        aaa = aaa - 1;
        bbb = bbb + 1;
        depolarizingmatrix = [depolarizingmatrix,[bbb:1:aaa]];
        aaa = aaa - 1;
        bbb = bbb + 1;
    end


end

