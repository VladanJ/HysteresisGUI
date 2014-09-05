function [ matrixOutput ] = HysteresisMatrixCreation (deltaX, deltaY, dimension, Distribution, Algorithm )

% deltaX = [0.01798621
% 0.015337466
% 0.019129778
% 0.024392314
% 0.031601695
% 0.041161051
% 0.053160832
% 0.067019151
% 0.081132452
% 0.092861989
% 0.099217061
% 0.098158259
% 0.089711653
% 0.075968153
% 0.059968052
% 0.044396554
% 0.0308994
% 0.020095346
% 0.011924592
% 0.00600768
% 0.001884102];
% 
% deltaY = [0.01798621
% 0.001884102
% 0.00600768
% 0.011924592
% 0.020095346
% 0.0308994
% 0.044396554
% 0.059968052
% 0.075968153
% 0.089711653
% 0.098158259
% 0.099217061
% 0.092861989
% 0.081132452
% 0.067019151
% 0.053160832
% 0.041161051
% 0.031601695
% 0.024392314
% 0.019129778
% 0.015337466];
% 
% 
% dimension = 21;

if (Distribution == 2) || (Distribution == 4)
    % exponencijalna raspodela
    expDiv = exp(1)-2;
    % exponencijalna raspodela
end

matrix_markers                  = zeros(dimension);
matrixInitialyHorizontal        = zeros(dimension);
matrixInitialyVertical          = zeros(dimension);
matrixOutput                    = zeros(dimension);
  
    for x=1 : dimension,
        for y=1 : dimension,
            if y<=x 
                matrix_markers(x, y)=1;
            end
        end
    end

    % initializing horizontal matrix
    for x=1 : dimension
        for y=1 : dimension
            if y<=x 
                if (y~=1),
                    if (Distribution == 0)
                        % konstantna raspodela
                        r1=deltaY(x);
                        r1=r1/(x-1);
                        % konstantna raspodela
                    elseif (Distribution == 1)
                        % linearna raspodela
                        koef1 = (2*(y-1)-1 )/((x-1)^2);
                        r1= deltaY(x) * koef1;
                        % linearna raspodela
                    elseif (Distribution == 2)
                        % exponencijalna raspodela
                        koef1 = 1 - exp(-1/(x-1));
                        koef1 = koef1/expDiv;
                        r1 = deltaY(x)*exp((y-1)/(x-1))*koef1;
                        % exponencijalna raspodela
                    elseif (Distribution == 3)
                        % inverzna linearna raspodela
                        koef1 = (2*(x-y+1)-1 )/((x-1)^2);
                        r1= deltaY(x) * koef1;
                        % inverzna linearna raspodela
                    elseif (Distribution == 4)
                        % inverzna exponencijalna raspodela
                        koef1 = 1 - exp(-1/(x-1));
                        koef1 = koef1/expDiv;
                        %r1 = deltaY(x)*(exp((x-y+1)/(x-1))*koef1 - (2*(x-y+1)-1)/expDiv);
                        
                        Xpart = (-1)/((x-1)*expDiv);
                        ExpPart = exp((x-y+1)/(x-1))*koef1;
                        r1 = deltaY(x)*(ExpPart + Xpart);
                        % inverzna exponencijalna raspodela
                    else
                        r1 = 0;
                    end
                    
                    matrixInitialyHorizontal(x, y)=r1;
                    if (x==1),
                        matrix_markers(x, y)=2;
                    end
                end;


                if y==1  %% prva kolona
                    %matrixInitialyHorizontal(x, y)=deltaX(dimension-1-x);
                    matrix_markers(x, y)=2;
                    if x~=1 
                        matrixInitialyHorizontal(x, y)=0;
                    else
                        matrixInitialyHorizontal(x, y)=deltaY(x);
                    end;
                end;

                if (y==dimension)  %% donji desni ugao
                    r1=deltaX(dimension);
                    matrixInitialyHorizontal(x, y)=r1;
                    matrix_markers(x, y)=2;
                end
            end
        end
    end
    
    for x=1 : dimension
        for y=1 : dimension
            if y<=x

                if y~=1
                    if (Distribution == 0)
                        %konstantna raspodela
                        r1=deltaX(y)/(dimension - y+1);
                        %konstantna raspodela
					elseif (Distribution == 1)
                        %linearna raspodela
                        koef1 = (2*(dimension-x+1)-1 )/((dimension-y+1)^2);
                        r1=deltaX(y)*koef1;
                        %linearna raspodela
                    elseif (Distribution == 2)
                        % exponencijalna raspodela
                        koef1 = 1 - exp(-1/(dimension-y+1));
                        r1 = deltaX(y)*exp((dimension-x+1)/(dimension-y+1))*koef1/expDiv;
                        % exponencijalna raspodela
                    elseif (Distribution == 3)
                        % inverzna linearna raspodela
                        koef1 = (2*(x-y+1)-1 )/((dimension-y+1)^2);
                        r1= deltaX(y) * koef1;
                        % inverzna linearna raspodela
                    elseif (Distribution == 4)
                        % inverzna exponencijalna raspodela
                        koef1 = 1 - exp(-1/(dimension-y+1));
                        % r1 = deltaX(y) * exp((x-y+1)/(dimension-y+1))*koef1/expDiv;
                        r1 = deltaX(y) * (exp((x-y+1)/(dimension-y+1))*koef1 - (1/(dimension-y+1)))/expDiv;
                        % inverzna exponencijalna raspodela
                    end
					
					%r1=dimension - y+1;
					matrixInitialyVertical(x, y) =r1;
					if x==1
						matrix_markers(x, y)=2;
					end
                end
                
                % lower right corner cell
                if (x==dimension) && (y==dimension)
                  r1=deltaX(dimension);
                  matrixInitialyVertical(x, y)=r1;
                  matrix_markers(x, y)=2;
                end

                % first column
                if y==1
                    matrix_markers(x, y)=2;
                    if x~=1
                        matrixInitialyVertical(x, y)=0;
                    else
                        matrixInitialyVertical(x, y) = deltaY(dimension-x+1);
                    end
                end

            end
        end
    end
    matrix_markers(2, 2)=2;
    
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if (Algorithm == 1)

    for x=2:dimension-1
        sum=0;
        sum2=0;
        for y=2:dimension
          if matrix_markers(y,x)==1
            sum=sum+matrixInitialyHorizontal(y,x);
          end
          if matrix_markers(y,x)==2
            sum2=sum2+matrixInitialyHorizontal(y,x);
          end
        end

        for y=1 : dimension
          if matrix_markers(y,x)==1
            coef1=deltaX(x);
            coef1=coef1-sum2;
            coef2=matrixInitialyHorizontal(y,x);

            r1=coef1*(coef2/sum);

            matrix_markers(y,x)=2;
            matrixInitialyHorizontal(y,x)=r1;
          end
        end

        sum=0;
        for y=1 : dimension-1
          if (matrix_markers(x+1,y)==2)
            sum=sum + matrixInitialyHorizontal(x+1,y);
          end
        end
        if (matrix_markers(x+1,x+1)==1)
          matrixInitialyHorizontal(x+1,x+1)=deltaY(x+1)-sum;
          matrix_markers(x+1,x+1)=2;
        end



        %-%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %-% horizontal
        sum=0;
        sum2=0;
        for y=1 : dimension
            yyy=dimension-x+2;
            if matrix_markers(yyy, y) == 1 
                sum=sum+matrixInitialyVertical(yyy, y);
            end;
            if matrix_markers(yyy, y) == 2 
                r1=matrixInitialyHorizontal(yyy, y);
                sum2=sum2+r1;
            end
        end

        for y=2 : dimension-1
            yyy=dimension-x+2;
            if matrix_markers(yyy, y)==1 
                r1=deltaY(yyy);
                coef1=r1-sum2;
                coef2=matrixInitialyVertical(yyy, y);
                r1=coef1*(coef2/sum);
                matrix_markers(yyy, y)=2;
                matrixInitialyHorizontal(yyy, y)=r1;
            end
        end


         sum=0;
         for y=1 : dimension
               yyy=dimension-x+1;
               if (matrix_markers(y, yyy)==2) 
                     sum=sum + matrixInitialyHorizontal(y, yyy);
               end
         end
         yyy=dimension-x+1;


         if matrix_markers(yyy, yyy)==1 
               matrixInitialyHorizontal(yyy, yyy)=deltaX(yyy)-sum;
               matrix_markers(yyy, yyy)=2;
         end
    end
    
    
    matrixOutput = matrixInitialyHorizontal;
    
    
    
else
    TriangleBorder = fix(dimension/2);
    
    for x=1:TriangleBorder
        for y=1:TriangleBorder
            matrixOutput(y,x)=matrixInitialyHorizontal(y,x);
            if (x>1) && (y>1)
                matrixOutput(dimension-x+2,dimension - y+2)=matrixInitialyHorizontal(y,x);
            end
        end
    end
    
    %for x=(TriangleBorder+1):dimension
    %    for y=(TriangleBorder+1):dimension
    %        matrixOutput(y,x)=matrixInitialyVertical(y,x);
    %    end
    %end
    
    
    
    
    y = TriangleBorder;
    
    for x=(TriangleBorder+1):dimension
        
        if y>0
            SumOfWhatsAlreadyInTable=0;
            Sum = 0;
            Koeff = 0;


            % horizontal sum of populated part of matrix
            for z=y+1:x
                SumOfWhatsAlreadyInTable=SumOfWhatsAlreadyInTable+matrixOutput(x,z);
            end
            Sum = deltaY(x);
            Sum = Sum - SumOfWhatsAlreadyInTable;


            % calculating horizontal sum of unpopulated part of matrix
            SumOfWhatsNeedsToBeInTable = 0;
            for z=2:y
                SumOfWhatsNeedsToBeInTable=SumOfWhatsNeedsToBeInTable+matrixInitialyHorizontal(x,z);
            end

            % populating horizontal
            %for k=2:y
            for k=2:(y+1)
                if SumOfWhatsNeedsToBeInTable ~= 0
                    if Sum > 0
                        Koeff = matrixInitialyHorizontal(x,k)/SumOfWhatsNeedsToBeInTable;
                        matrixOutput(x,k) = Koeff * Sum;
                        matrixOutput(dimension - k+2,dimension - x+2) = Koeff * Sum;
                    else
                        Koeff = matrixInitialyHorizontal(x,k)/SumOfWhatsNeedsToBeInTable;
                        yy = y - k + 3;
                        matrixOutput(x, yy) = Koeff * Sum;
                        xxxx = dimension - (y - k +1); 
                        yyyy = dimension - x+2;
                        matrixOutput(xxxx, yyyy) = Koeff * Sum;
                    end
                else
                    matrixOutput(x,k) = Sum;
                end
            end


            %-%% vertical part %%%

%             SumOfWhatsAlreadyInTable=0;
%             Sum = 0;
%             Koeff = 0;
% 
% 
%             % vertical sum of populated part of matrix
%             for z=(y+1):(x+1)
%                 SumOfWhatsAlreadyInTable=SumOfWhatsAlreadyInTable+matrixOutput(z,y+1);
%             end
%             %Sum = deltaX(y);
%             Sum = deltaY(dimension - y);
%             Sum = Sum - SumOfWhatsAlreadyInTable;
% 
% 
%             % calculating vertical sum of unpopulated part of matrix
%             SumOfWhatsNeedsToBeInTable = 0;
%             for z=(x+1):dimension
%                 %SumOfWhatsNeedsToBeInTable=SumOfWhatsNeedsToBeInTable+matrixInitialyVertical(z,y);
%                 SumOfWhatsNeedsToBeInTable=SumOfWhatsNeedsToBeInTable+matrixInitialyVertical(z,(y+1));
%             end
% 
%             % populating vertical
%             for k=(x+1):dimension
%                 %Koeff = matrixInitialyVertical(k, y)/SumOfWhatsNeedsToBeInTable;
%                 Koeff = matrixInitialyVertical(k, (y+1))/SumOfWhatsNeedsToBeInTable;
%                 %matrixOutput(k,y) = Koeff * Sum;
%                 %matrixOutput(k,(y+1)) = Koeff * Sum;
%                 matrixOutput(k,(y+1)) = matrixOutput((y+1),k);
%             end
        else
            
            if (dimension - x) >= 2
                SumOfWhatsAlreadyInTable=0;
                Sum = 0;
                Koeff = 0;


                % horizontal sum of populated part of matrix
                for z=y+1:x
                    SumOfWhatsAlreadyInTable=SumOfWhatsAlreadyInTable+matrixOutput(x,z);
                end
                Sum = deltaY(x);
                Sum = Sum - SumOfWhatsAlreadyInTable;


                % calculating horizontal sum of unpopulated part of matrix
                SumOfWhatsNeedsToBeInTable = 0;
                for z=2:y
                    SumOfWhatsNeedsToBeInTable=SumOfWhatsNeedsToBeInTable+matrixInitialyHorizontal(x,z);
                end

                % populating horizontal
                for k=2:y
                    Koeff = matrixInitialyHorizontal(x,k)/SumOfWhatsNeedsToBeInTable;
                    matrixOutput(x,k) = Koeff * Sum;
                end
                
            end
            
            
            
            B = [0
                0 
                0 
                0];
            
            
            % horizontal sum of populated part of matrix
            SumOfWhatsAlreadyInTable=0;
            for z=(y+1):x
                SumOfWhatsAlreadyInTable=SumOfWhatsAlreadyInTable+matrixOutput(x,z);
            end
            B(1) = deltaY(x);
            B(1) = B(1) - SumOfWhatsAlreadyInTable;
            
            SumOfWhatsAlreadyInTable=0;
            for z=(y+1):(x+1)
                SumOfWhatsAlreadyInTable=SumOfWhatsAlreadyInTable+matrixOutput(x+1,z);
            end
            B(2) = deltaY(x+1);
            B(2) = B(2) - SumOfWhatsAlreadyInTable;
            

            % vertical sum of populated part of matrix
            SumOfWhatsAlreadyInTable=0;
            for z=y:x
                SumOfWhatsAlreadyInTable=SumOfWhatsAlreadyInTable+matrixOutput(z,y);
            end
            B(4) = deltaX(y);
            B(4) = B(4) - SumOfWhatsAlreadyInTable;
            SumOfWhatsAlreadyInTable=0;
            for z=(y-1):x
                SumOfWhatsAlreadyInTable=SumOfWhatsAlreadyInTable+matrixOutput(z,y-1);
            end
            B(3) = deltaX(y-1);
            B(3) = B(3) - SumOfWhatsAlreadyInTable;
            
            
            
            
            
            
            A = [1 1 0 0;
                0 0 1 1;
                1 0 1 0;
                0 1 0 1];
            
            
            %X = A\B;
            X = linsolve(A,B);
            
            if any(isnan(X))
                    X(1) = B(1)/2;
                    X(2) = B(1)/2;
                    X(4) = B(1)/2;
                    X(3) = B(2)-B(1)/2;
            end
            
            
            
            matrixOutput(x,y-1) = X(1);
            matrixOutput(x,y) = X(2);
            matrixOutput(x+1,y-1) = X(3);
            matrixOutput(x+1,y) = X(4);
            
            break;
        
        end
        
        y = y - 1;
        
        
    end
    
    
    
    
    %matrixInitialyHorizontal = matrixOutput;
end

end

