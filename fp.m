function [ UpperXvalues, UpperYvalues ,LowerXvalues, LowerYvalues, PlotX, PlotY] = fp(filenameX, filenameY, points)

    data = csvread(filenameX);
    dataY = csvread(filenameY);
    
    dataNegative = data * -1;
    %peaksUP = findpeaks(1:size_data,data,1,-1,2,50);
    %peaksDO = findpeaks(1:size_data,dataN,1,-1,2,50);
    %pp = [transpose(peaksDO(:,2)),  transpose(peaksUP(:,2))];
    %pp = round(pp);

    data_min = min(data);
    data_max = max(data);
    
    dist = data_max - data_min;
    
    maxl = data_max - dist/30;
    minl=  -(data_min + dist/30);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % find upper peaks
    tmpUP= find (data > maxl);
    area_begin = true;
    x = 1;
    sz= length(tmpUP);
    cond= x<sz;
    while cond
        delta = tmpUP(x) - tmpUP(x + 1);
        delta = abs(delta);
        if delta<50
            if area_begin == false
                tmpUP (x) = [];
                area_begin = true;
            else
                x = x + 1; 
            end
        else
            x = x + 2;            
        end
        area_begin = false;
        sz= length(tmpUP);
        cond= x<sz;
    end
    
    peaksUP_values = [];
    peaksUP_positions = [];
    for x=0: (length(tmpUP)/2)-1
        ind1 = tmpUP(x*2+1);
        ind2 = tmpUP(x*2+2);
        max_value = max(data(ind1 : ind2));
        peaksUP_values = [peaksUP_values , max_value];
        position = find (data(ind1 : ind2) == max_value);
        position = ind1 + position(1) - 1;
        peaksUP_positions = [peaksUP_positions, position]; 
    end
    % find upper peaks
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % find lower peaks
    tmpLOW= find (dataNegative > minl);
    area_begin = true;
    x = 1;
    sz= length(tmpLOW);
    cond= x<sz;
    while cond
        delta = tmpLOW(x) - tmpLOW(x + 1);
        delta = abs(delta);
        if delta<50
            if area_begin == false
                tmpLOW (x) = [];
                area_begin = true;
            else
                x = x + 1; 
            end
        else
            x = x + 2;            
        end
        area_begin = false;
        sz= length(tmpLOW);
        cond= x<sz;
    end
    
    peaksLOW_values = [];
    peaksLOW_positions = [];
    for x=0: (length(tmpLOW)/2)-1
        ind1 = tmpLOW(x*2+1);
        ind2 = tmpLOW(x*2+2);
        min_value = min(data(ind1 : ind2));
        peaksLOW_values = [peaksLOW_values , min_value];
        position = find (data(ind1 : ind2) == min_value);
        position = ind1 + position(1)-1;
        peaksLOW_positions = [peaksLOW_positions, position]; 
    end
    % find lower peaks
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    peaks = [1, length(data)];
    peaks = [peaks, peaksLOW_positions, peaksUP_positions];
    
    peaks = sort(peaks);
    
    up_valuesX = [];
    down_valuesX = [];
    up_valuesY = [];
    down_valuesY = [];
    for x=1: (length(peaks))-1        
        ind1 = peaks(x);
        ind2 = peaks(x+1);
        if data(ind1)<data(ind2)
            up_valuesX = [(up_valuesX), transpose(data(ind1:ind2))];
            up_valuesY = [(up_valuesY), transpose(dataY(ind1:ind2))];
        end
        if data(ind1)>data(ind2)
            down_valuesX = [(down_valuesX), transpose(data(ind1:ind2))];
            down_valuesY = [(down_valuesY), transpose(dataY(ind1:ind2))];
        end
    end
    up_valuesX = transpose(up_valuesX);
    down_valuesX = transpose(down_valuesX);
    up_valuesY = transpose(up_valuesY);
    down_valuesY = transpose(down_valuesY);
   
    
    % generate files with temporary resuts
    %csvwrite('Xup_values.csv',up_valuesX);
    %csvwrite('Xdown_values.csv',down_valuesX);
    %csvwrite('Yup_values.csv',up_valuesY);
    %csvwrite('Ydown_values.csv',down_valuesY);
    
    
    %%%%%%%%%%%%%%%%%%%%%
    
    
%    points = 100;
    
    segment = dist / points;
    segment_begin = data_min;
    segment_end = segment_begin + segment; 
    
    averageX = [];
    averageY = [];
    for x=1 : points
        cnt=0;
        sumX=0;
        sumY=0;
        for y=1 : size(up_valuesX)
            d = up_valuesX(y);
            if ( d >= segment_begin) && (d <= segment_end)
                sumX= sumX+ up_valuesX(y);
                sumY= sumY+ up_valuesY(y);
                cnt= cnt + 1;
            end
        end
        averageX(x) = sumX / cnt;
        averageY(x) = sumY / cnt;
        
        
        segment_begin = segment_begin + segment; 
        segment_end = segment_end + segment; 
        
    end
    
    avrX = averageX;
    avrY = averageY;
    
%     averageX = transpose(averageX);
%     averageY = transpose(averageY);
%     
%     csvwrite('averageX_up.csv',averageX);
%     csvwrite('averageY_up.csv',averageY);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    segment = dist / points;
    segment_begin = data_min;
    segment_end = segment_begin + segment; 
    
    averageX = [];
    averageY = [];
    for x=1 : points
        cnt=0;
        sumX=0;
        sumY=0;
        for y=1 : size(down_valuesX)
            d = down_valuesX(y);
            if ( d >= segment_begin) && (d <= segment_end)
                sumX= sumX+ down_valuesX(y);
                sumY= sumY+ down_valuesY(y);
                cnt= cnt + 1;
            end
        end
        averageX(x) = sumX / cnt;
        averageY(x) = sumY / cnt;
        
        
        segment_begin = segment_begin + segment; 
        segment_end = segment_end + segment; 
        
    end
    
    averageX_dwn = transpose(averageX);
    averageY_dwn = transpose(averageY);
    
    UpperXvalues = averageX_dwn;
    UpperYvalues = averageY_dwn;
    
    

    PlotX = [avrX, averageX];
    PlotY = [avrY, averageY];    
    


    avrX = transpose(avrX);
    avrY = transpose(avrY);
    
    LowerXvalues = avrX;
    LowerYvalues = avrY;
    
     
    
    

    
end