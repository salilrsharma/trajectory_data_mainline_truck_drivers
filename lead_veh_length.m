function f = lead_veh_length(vehID, trajectories)
    if vehID == 0
        f = 0;
    else
        f = trajectories(vehID).l;
    end
end