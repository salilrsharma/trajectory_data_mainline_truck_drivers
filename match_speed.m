function f = match_speed(vehID, timeStamp, trajectories)
    if vehID == 0
        f = 0;
    else
        timeId = find(timeStamp == [trajectories(vehID).t]);
        smoothed_v = speed_filter(trajectories(vehID).x_sm,trajectories(vehID).v_cal);
%         f = trajectories(vehID).v_cal(timeId);
        f = smoothed_v(timeId);
    end
end