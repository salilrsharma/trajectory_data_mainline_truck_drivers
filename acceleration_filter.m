function f = acceleration_filter(v,a_cal)
    %x is position array
    v = v./3.6;
    a = [];
    T = 1/10;
    for i = 1:length(v)
        if i>1 && i<length(v)-1
            a(i) = (v(i+1) - v(i-1))/(2*T);  
        else
            a(i)=a_cal(i);
        end
    end
    f = sgolayfilt(a,3,7);
    return;
end