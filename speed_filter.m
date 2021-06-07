function f = speed_filter(x,v_cal)
    %x is position array
    v = [];
    horizon =7;
    for i = 1:length(x)
        temp = [];
        T = 1/10;
        if i>horizon && i<length(x)-horizon
            for n = 1:7
                %convert m/s to km/h
                v_temp = ((x(i+n) - x(i-n))*3.6)/(2*n*T);
                temp = [temp; v_temp] ; 
            end
            v(i) = median(temp);
        else
            v(i)=v_cal(i);
        end
    end
    f = sgolayfilt(v,3,horizon);
    return;
end