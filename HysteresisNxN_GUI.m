function [ sumC, matrix ] = HysteresisNxN_GUI( x, hysteresis, matrix, mode)
%HysteresisNxN: Hysteresis on NxN matrix
%   Each input index touches at most one row and one column of the state
%   matrix, so the flux is tracked incrementally in O(N) per step instead of
%   recomputing the full O(N^2) sum(matrix.*hysteresis) on every step.  The
%   state is 0/1, so it is kept as an int8 (8x smaller than double), which is
%   far more cache-friendly for the strided row/column updates.

    N = size(hysteresis, 1);
    M = numel(x);
    sumC = zeros(1, M);

    DoSum = ~strcmp(mode, 'depolarizing');

    st = int8(matrix);                          % compact working copy

    if DoSum
        psi = sum(sum(double(st) .* hysteresis));   % running flux, updated per step
    end

    for n = 1:M
        xn = x(n);
        if xn < 1
            if DoSum
                psi = psi - sum(sum(double(st) .* hysteresis));
            end
            st(:) = 0;
        elseif xn < N
            if DoSum
                oldrow = double(st(xn, :));
                newrow = [ones(1, xn), zeros(1, N - xn)];
                dRow = sum((newrow - oldrow) .* hysteresis(xn, :));
                st(xn, :) = int8(newrow);
                oldcol = double(st(:, xn + 1));
                dCol = -sum(oldcol .* hysteresis(:, xn + 1));
                st(:, xn + 1) = 0;
                psi = psi + dRow + dCol;
            else
                st(xn, :) = 1;
                st(xn, xn + 1:end) = 0;
                st(:, xn + 1) = 0;
            end
        elseif xn == N
            if DoSum
                oldrow = double(st(N, :));
                dRow = sum((1 - oldrow) .* hysteresis(N, :));
                st(N, :) = 1;
                psi = psi + dRow;
            else
                st(N, :) = 1;
            end
        else % xn > N
            if DoSum
                psi = psi + sum(sum((1 - double(st)) .* hysteresis));
            end
            st(:) = 1;
        end

        if DoSum
            sumC(n) = psi;
        end
    end

    matrix = double(st);

end

