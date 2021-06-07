function [f,g,h] = new_LC_timings(alpha, traj, epsilon)
    smooth_traj=smooth(traj,40,'moving');
    temp = gradient(alpha.*smooth_traj);
    a = temp>epsilon;
    a = cumsum(a);
    result = find(bwareafilt([0, diff(a')] == 1, 1));
    if ~isempty(result)
        f = result(1);
        g = result(end);
        h = smooth_traj;
    else
        f = -1;
        g = -1;
        h = smooth_traj;
    end
    return;
end