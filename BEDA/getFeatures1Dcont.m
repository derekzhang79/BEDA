function [output] =  getFeatures1Dcont(data,opt)
%getFeatures1Dcont - this function allows extracting some standard features
%from 1D signals
%example
% [output] =  getFeatures1Dcont(EDAsignal,'std')
%Javier Hernandez Rivera, MIT

switch opt        
    case 'ndist' %distance between first and last point
        output = data(end) - data(1);
    
    case 'mean' %mean
        output = mean(data);
    
    case 'mean.median' %difference between mean and median
        output = mean(data)-median(data);        
    
    case 'median' %median
        output = median(data);        
    
    case 'max' %maximum
        output = max(data);        
    
    case 'min' %minimum
        output = min(data);
    
    case 'range' %difference between minimum and maximum values
        output = max(data)-min(data);        
    
    case 'rpmax' %relative position max
        [v p] = max(data);
        output = p/length(data);        
    
    case 'rpmin' %relative position min
        [v p] = min(data);
        output = p/length(data);        
    
    case 'auc' %area under the curve
         n = length(data);
         x = [1,1:n,n]';
         y = [0;data(:);0];
         output = polyarea(x,y) ./ n;
         
%         output = polyarea([1:length(data)]',data(:))./length(data);   
    case 'tonic.auc' % average area under the curve
        rate = 32;
        window_len = 10 * rate; % a number of data per window
        start_index = 1;
        N = length(data);

        sum_output = 0;
        num_output = 0;
        while start_index < N
            end_index = start_index + window_len - 1;
            if end_index > N
                end_index = N;
            end
            window_data = data(start_index:end_index);
            value = getFeatures1Dcont(window_data, 'auc');
%             fprintf('%d to %d = %f\n', start_index, end_index, value);
            start_index = start_index + window_len * 0.25;
            sum_output = sum_output + value;
            num_output = num_output + 1;
        end
            
        output = sum_output / num_output;
        
    case 'max2' %maximum - mean (more normalized version)
        output = max(data-mean(data));        
    
    case 'min2' %minimum - mean (more normalized version)
        output = min(data-mean(data));          
    
    case 'SCR.amp' %distance between first value and maximum
        [v p] = max(data);
        output = v - data(1);        
    
    case 'SCR.above' % distance between max and mean
        [v p] = max(data);
        output = v - mean(data);    
    
    case 'SCR.below' %distance between mean and minimum
        [v p] = min(data);
        output = mean(data)-v;       
    
    case 'std' %std
        output = std(data);
    
    case 'avgSlope' %slope (with sliding window)
        sub_win = 30;%subwindow to compute slope (seconds)        
        SR = 8;%sampling rate
        
        N = length(data);
        %compute slopes
        slopes = [];
        piece = round((sub_win*SR)/2);
        i = piece+1;
        cont = 1;
        while i<(N-piece)
%             i
            start = i - piece; if start<=0; continue; end
            final = i + piece; if final>N; continue; end
            [slopes(cont)] =  getFeatures1Dcont(data(start:final),'slope');
            i = i + round((sub_win*SR)/3);
            cont = cont + 1;
        end
        if isempty(slopes)
            keyboard
        end
        output = mean(slopes);
        
    case 'slope' %slope (window interval)
        if length(data) == 1
            output = 0;
        else
            %fast method
%             output = ((data(end)-data(1)) / (length(data) - 1));
            
            %more robust to outliers but much slower
            x = [1:length(data)];
            vect = data(:);
            output = polyfit(x(:),vect,1);
            vals = polyval(output,[x(1) x(end)]);
            
            output = ((vals(end)-vals(1)) / (length(data) - 1));
        end
        
    case 'coeff' %coefficients of interpolated polynomial (degree)
        x = [1:length(data)];
        output = polyfit(x(:),data(:),3);
                
%     case 'findpeaks'
%         output = findpeaks(data,'MINPEAKDISTANCE', 1000, 'MINPEAKHEIGHT', 2.0)
    case 'percentage.peaks' %number of peaks 
%         minVal = 0.05;
%         [y1 x1] = findpeaks(data,'MINPEAKHEIGHT',minVal);
        [y1 x1] = findpeaks(data,'MINPEAKDISTANCE', 1000, 'MINPEAKHEIGHT', 2.0);
        if ~isempty(y1)
            output = [length(x1)/length(data) ];
        else
            output = [0];
        end
                
    case 'absnpeaks' %absolute number of peaks 
        [y1 x1] = findpeaks(data,'MINPEAKDISTANCE', 400);
        if ~isempty(y1)
            output = [length(x1)];
        else
            output = [0];
        end
        
    case 'vpeaks' %values of peaks 
        minVal = 0.05;
        [y1 x1] = findpeaks(data,'MINPEAKHEIGHT',minVal);
        if ~isempty(y1)
            output = mean(y1);
        else
            output = [0];
        end
    case 'zeros.num' %zero crossings
        [cz b] = crossing(data-mean(data));
        output(1) = length(cz)./length(data);
        
    case 'zeros.dist' %distances between zero crossings
        [cz b] = crossing(data-median(data));
        if isempty(b) || length(b) == 1
            output(1) = 1;
        else
            output(1) = mean(b(2:end)-b(1:end-1))./length(data);
        end
        
    case 'dur' %duration
        output = length(data);        
        
    otherwise
        fprintf('getFeatures1Dcont.m: Wrong feature type [%s]\n',opt);
        keyboard
end

output = output(:);
if any(isnan(output)) || any(isinf(output))
    keyboard
end
