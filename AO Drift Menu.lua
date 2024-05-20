--to do:
----savedVehicle based on model hash, save trasnfers between same model different car?
----bug: traffic remover OnScriptsCallback interference
----bug: have to reload scripts for menu to display: line 134
----bug: repair resets vdmg, vgod
----bug: vgod, vdmg tog discrepancy if enabled, then get out and reenter vehicle
----bug: enable/disbale on all items? only while traffic disabled?
----callback events?
----traffic remover
----add auto-repair
----add never wanted
----add teleport (3 second?)
----vehicle:get_centre_of_mass
----REFACTOR
----NT Vector3 solution?!?
----visible damage toggle
----messagedisplay.lua for debug. what features can leverage this?
----drive_bias_front selector
----vehicle:get_mass
----model copier
----tune saver, optimal tune?
----tandem underglow? accel and decel lights
----customization toggles??
----suspension upgrade select??
----suspension height??
----drift plate?
----drift cam?



---------------variables, objects

--for saving current vehicle stats, used to revert stats back to vanilla
local savedVehicle = {
    
    model_hash = 0;
    acceleration = 0;
    anti_roll_bar_bias_front = 0;
    anti_roll_bar_force = 0;
    brake_bias_front = 0;
    brake_force = 0;
    --centre_of_mass_offset = 0, 0, 0;
    camber_stiffness = 0;
    up_shift = 0;
    down_shift = 0;
    drift_tyres_enabled = false;
    drive_bias_front = 0;
    drive_inertia = 0;
    handbrake_force = 0;
    initial_drag_coeff = 0;
    initial_drive_force = 0;
    initial_drive_gears = 0;
    initial_drive_max_flat_velocity = 0;
    mass = 0;
    roll_centre_height_front = 0;
    roll_centre_height_rear = 0;
    steering_lock = 0;
    suspension_bias_front = 0;
    suspension_comp_damp = 0;
    suspension_force = 0;
    suspension_height = 0;
    suspension_lower_limit = 0;
    suspension_raise = 0;
    suspension_rebound_damp = 0;
    suspension_upper_limit = 0;
    traction_bias_front = 0;
    traction_curve_lateral = 0;
    traction_curve_max = 0;
    traction_curve_min = 0;

}
------------drift tunes

--this changes minimal stats to enable drifting in a style similar to vanilla drift tune vehicles
--retains more character of the original car
local vanillishDriftTune = {

    --model_hash = nil;
    initial_drive_force = 0.71;
    initial_drive_gears = 4;
    acceleration = 01.0;
    traction_curve_max = 1.53;
    traction_curve_min = 1.52;
    drive_bias_front = 0.20;
    up_shift = 4.8;
    down_shift = 4.7;
    steering_lock = 75;
    suspension_force = 2.05;
    drift_tyres_enabled = true;

}

--this changes all of the current vehicle's stats to average values from all vanilla drift tuners
local vanillAvgDriftTune = {

    --model_hash = nil;
    acceleration = 0.91;
    anti_roll_bar_bias_front = .82;
    anti_roll_bar_force = .23;
    brake_bias_front = .22;
    brake_force = .82;
    camber_stiffness = 0;
    up_shift = 4.8;
    down_shift = 4.7;
    drift_tyres_enabled = true;
    drive_bias_front = .21;
    drive_inertia = 1;
    handbrake_force = .93;
    initial_drag_coeff = 2.6;
    initial_drive_force = .71;
    initial_drive_gears = 4;
    initial_drive_max_flat_velocity = 133.62;
    mass = 1267.5;
    roll_centre_height_front = .13;
    roll_centre_height_rear = .12;
    steering_lock = 77.55;
    suspension_bias_front = .49;
    suspension_comp_damp = 1.04;
    suspension_force = 1.95;
    suspension_height = .04;
    suspension_lower_limit = -.11;
    suspension_raise = .03;
    suspension_rebound_damp = 1.56;
    suspension_upper_limit = .08;
    traction_bias_front = .46;
    traction_curve_lateral = 28.31;
    traction_curve_max = 1.53;
    traction_curve_min = 1.52;

}

--tune based on KuroiYurei's recommended kiddion's settings
local keepUpDriftTune = {

    --model_hash = nil;
    acceleration = 6;
    anti_roll_bar_bias_front = .82;
    anti_roll_bar_force = .23;
    brake_bias_front = .55;
    brake_force = 1;
    ----camber_stiffness = 0;
    up_shift = 6;
    down_shift = 6;
    drift_tyres_enabled = false;
    drive_bias_front = .05;
    drive_inertia = 1;
    handbrake_force = 2;
    initial_drag_coeff = 1.02;
    initial_drive_force = 2;
    initial_drive_gears = 5;
    initial_drive_max_flat_velocity = 233.62;
    --mass = 1350;
    ----roll_centre_height_front = .13;
    ----roll_centre_height_rear = .12;
    steering_lock = 77.55;
    ----suspension_bias_front = .49;
    ----suspension_comp_damp = 1.04;
    suspension_force = 2.6;
    suspension_height = .02;
    ---suspension_lower_limit = -.11;
    ---suspension_raise = .03;
    --suspension_rebound_damp = 1.56;
    --suspension_upper_limit = .08;
    traction_bias_front = .46;
    ----traction_curve_lateral = 28.31;
    traction_curve_max = 1.4;
    traction_curve_min = 1.12;


}

--tune based on Manu's published drift tune
local manuishDriftTune = {

    --model_hash = nil;
    acceleration = 30;
    anti_roll_bar_bias_front = .82;
    anti_roll_bar_force = .23;
    brake_bias_front = .49;
    brake_force = 1;
    camber_stiffness = 0;
    up_shift = 15;
    down_shift = 15;
    drift_tyres_enabled = false;
    drive_bias_front = .09;
    drive_inertia = 1;
    handbrake_force = 2;
    initial_drag_coeff = .00094;
    initial_drive_force = .33;
    --initial_drive_gears = 5;
    initial_drive_max_flat_velocity = 41.111;
    --mass = 1350;
    roll_centre_height_front = .24;
    roll_centre_height_rear = .25;
    steering_lock = 77.55;
    suspension_bias_front = .55;
    suspension_comp_damp = 1.4;
    suspension_force = 2.8;
    suspension_height = .02;
    suspension_lower_limit = -.11;
    suspension_raise = .0;
    suspension_rebound_damp = 2.2;
    suspension_upper_limit = .08;
    traction_bias_front = .46;
    traction_curve_lateral = 1;
    traction_curve_max = 1.7;
    traction_curve_min = 1.1;


}

--based on Calpurnia's AWD drift tune
local calpurnishDriftTune = {

    acceleration = 3;
    drive_bias_front = .25;
    up_shift = 8;
    down_shift = 8;
    drift_tyres_enabled = false;
    brake_force = 1.1;
    handbrake_force = 1.2;
    initial_drag_coeff = .9;
    initial_drive_force = .3;
    initial_drive_max_flat_velocity = 160;
    steering_lock = 55;
    traction_bias_front = .5;
    traction_curve_min = 1.3;
    traction_curve_max = .9;
    suspension_force = 4;

}

--based on Calpurnia's AWD HoonTune
local calHoonDriftTune = {

    acceleration = 3;
    drive_bias_front = .25;
    up_shift = 8;
    down_shift = 8;
    drift_tyres_enabled = false;
    brake_force = 1.1;
    handbrake_force = 1.2;
    initial_drag_coeff = .9;
    initial_drive_force = .3;
    initial_drive_max_flat_velocity = 160;
    steering_lock = 55;
    traction_bias_front = .5;
    traction_curve_min = 1.3;
    traction_curve_max = .9;
    suspension_force = 1;

}

--based on Calpurnia's AWD FD Comp tune
local calCompDriftTune = {

    acceleration = 10;
    drive_bias_front = .05;
    up_shift = 8;
    down_shift = 8;
    drift_tyres_enabled = false;
    brake_force = 1.1;
    handbrake_force = 1.2;
    initial_drag_coeff = .9;
    initial_drive_force = 1;
    initial_drive_max_flat_velocity = 200;
    steering_lock = 66;
    traction_bias_front = .5;
    traction_curve_min = 1.5;
    traction_curve_max = 1.1;
    suspension_force = 1;

}

--collection of tunes for the selector array
local driftTunes = {

    savedVehicle;
    vanillishDriftTune;
    vanillAvgDriftTune;
    calpurnishDriftTune;
    calHoonDriftTune;
    calCompDriftTune;
    keepUpDriftTune;
    manuishDriftTune;

}

--? unsure if this is the ideal solution to initializing  tune selector array properly
local driftTuneIndex = 1;

-----------------menu
submenu = menu.add_submenu("AO's Drift Menu")
submenu:add_action("-------------AO's Drift Menu--------------", function() end)


--this check is a bit janky, callback?
if localplayer then  
    
---------------------menu building:::::::::::::::

-------------------/Drift tunes\-------------------
--saves vanilla stats, applies drift tunes as selected from array
    submenu:add_array_item("Drift Tune:", {"None", "Vanillish", "VanillAverage", "Calpurnish", "CalHoon", "CalComp", 
    "Kuroish", "Manuish"}, 
        function() 
            if not localplayer:is_in_vehicle() then return disabled end
            return driftTuneIndex
        end,
        function(dtIndex)
            if not localplayer:is_in_vehicle() then 
                return disabled 
            end
            driftTuneIndex = dtIndex
            local currentVehicle = localplayer:get_current_vehicle()
            local currentVehicleHash = currentVehicle:get_model_hash()

            if currentVehicleHash ~= savedVehicle.model_hash then
                for name in next, savedVehicle do
                    savedVehicle[name] = currentVehicle["get_"..name](currentVehicle)
                end
            end
            if driftTuneIndex and driftTunes then
                for name, value in next, driftTunes[driftTuneIndex] do
                    currentVehicle["set_"..name](currentVehicle, value)
                end
            end
            return
        end
    )



    -------------------Low Grip
--adds low grip tires to the current vehicle
    submenu:add_toggle("Low Grips", 
        function() 
            if not localplayer:is_in_vehicle() then
                return disabled
            else if localplayer:get_current_vehicle():get_drift_tyres_enabled() then
                return true
                end
            end
            return false
        end,
        function(enabled)  
            if not localplayer:is_in_vehicle() then 
                return disabled
            end
            
            currentVehicle = localplayer:get_current_vehicle()
            
            if enabled then
                currentVehicle:set_drift_tyres_enabled(true)
                return enabled
            else    
                currentVehicle:set_drift_tyres_enabled(false)
                return disabled
            end
        end
    )


    --------------------acceleration
--adjuster for the acceleration multiplier. use to control power curve of vehicle
    submenu:add_float_range("Acceleration", 0.05, 0.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_acceleration()
            end
        end,
        function(acceleration)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_acceleration(acceleration)  
        end
    )

    --------------------traction modifier
--this adjust the max and min points of the traction curve of the current vehicle.
--the max value is displayed, although the minimum is also adjusted to maintain the curve
    submenu:add_float_range("Traction Modifier", 0.01, 0.0, 10,
        function() 
            if localplayer:is_in_vehicle() then
                return localplayer:get_current_vehicle():get_traction_curve_max() 
            end
            return 1.5
        end,
        function(tractionMod) 
            currentVehicle = localplayer:get_current_vehicle() 
            tractionModSpread = (currentVehicle:get_traction_curve_max() - currentVehicle:get_traction_curve_min())
            currentVehicle:set_traction_curve_max(tractionMod)
            currentVehicle:set_traction_curve_min(tractionMod - tractionModSpread)
            return
        end
    )

    
    
    
    
    
    
    ------------------------nerdtune submenu
    --this submenu displays every accessible modifier value for the current vehicle, and allows
    --for fine adjustments of each. 

    --REFACTOR - REDUNDANT CODE THROUGHOUT NERDTUNE SECTION
    nerdMenu = submenu:add_submenu("NerdTune", function() end)
    nerdMenu:add_action("-------------AO's NerdTune--------------", function() end)

--------------------NT acceleration

    nerdMenu:add_float_range("Acceleration", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_acceleration()
            end
        end,
        function(acceleration)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_acceleration(acceleration)  
        end
    )

    --------------------NT anti roll bar bias front

    nerdMenu:add_float_range("Front Anti Roll Bar Bias", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_anti_roll_bar_bias_front()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_anti_roll_bar_bias_front(value)  
        end
    )

    --------------------NT anti roll bar force

    nerdMenu:add_float_range("Anti Roll Bar Force", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_anti_roll_bar_force()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_anti_roll_bar_force(value)  
        end
    )



    --------------------NT brake bias front

    nerdMenu:add_float_range("Front Brake Bias", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_brake_bias_front()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_brake_bias_front(value)  
        end
    )

    --------------------NT brake force

    nerdMenu:add_float_range("Brake Force", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_brake_force()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_brake_force(value)  
        end
    )

    --------------------NT camber stiffness

    nerdMenu:add_float_range("Camber Stiffness", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_camber_stiffness()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_camber_stiffness(value)  
        end
    )

    --------------------NT center of mass offset x

    nerdMenu:add_float_range("Center of Mass Offset X", .01, -10000.0, 10000.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                currentVehicle = localplayer:get_current_vehicle()
                vehicleCenterMass = currentVehicle:get_centre_of_mass_offset()
                return vehicleCenterMass.x
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle()
            vehicleCenterMass = currentVehicle:get_centre_of_mass_offset()
            vehicleCenterMass.x = value 
            currentVehicle:set_centre_of_mass_offset(vehicleCenterMass)  
        end
    )

    --------------------NT center of mass offset y

    nerdMenu:add_float_range("Center of Mass Offset Y", .01, -10000.0, 10000.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                currentVehicle = localplayer:get_current_vehicle()
                vehicleCenterMass = currentVehicle:get_centre_of_mass_offset()
                return vehicleCenterMass.y
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle()
            vehicleCenterMass = currentVehicle:get_centre_of_mass_offset()
            vehicleCenterMass.y = value 
            currentVehicle:set_centre_of_mass_offset(vehicleCenterMass)  
        end
    )

    --------------------NT center of mass offset z

    nerdMenu:add_float_range("Center of Mass Offset Z", .01, -10000.0, 10000.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                currentVehicle = localplayer:get_current_vehicle()
                vehicleCenterMass = currentVehicle:get_centre_of_mass_offset()
                return vehicleCenterMass.z
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle()
            vehicleCenterMass = currentVehicle:get_centre_of_mass_offset()
            vehicleCenterMass.z = value 
            currentVehicle:set_centre_of_mass_offset(vehicleCenterMass) 
        end
    )




    --------------------NT up shift

    nerdMenu:add_float_range("Up Shift", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_up_shift()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_up_shift(value)  
        end
    )

    --------------------NT down shift

    nerdMenu:add_float_range("Down Shift", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_down_shift()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_centre_of_mass_offset(value)  
        end
    )

 

    --------------------NT Front Drive Bias

    nerdMenu:add_float_range("Front Drive Bias", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_drive_bias_front()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_drive_bias_front(value)  
        end
    )

    --------------------NT Drive Inertia

    nerdMenu:add_float_range("Drive Inertia", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_drive_inertia()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_drive_inertia(value)  
        end
    )



    --------------------NT gravity

    nerdMenu:add_float_range("Gravity", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_gravity()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_gravity(value)  
        end
    )

    --------------------NT handbrake force

    nerdMenu:add_float_range("Handbrake Force", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_handbrake_force()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_handbrake_force(value)  
        end
    )



    --------------------NT initial drag coefficient

    nerdMenu:add_float_range("Initial Drag Coefficient", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_initial_drag_coeff()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_initial_drag_coeff(value)  
        end
    )

    --------------------NT initial drive force

    nerdMenu:add_float_range("Initial Drive Force", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_initial_drive_force()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_initial_drive_force(value)  
        end
    )

    --------------------NT initial drive gears

    nerdMenu:add_int_range("Initial Drive Gears", 1, -100, 100,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1
            else
                return localplayer:get_current_vehicle():get_initial_drive_gears()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_initial_drive_gears(value)  
        end
    )

    --------------------NT initial drive max flat velocity

    nerdMenu:add_float_range("Initial Drive Max Flat Velocity", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_initial_drive_max_flat_velocity()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_initial_drive_max_flat_velocity(value)  
        end
    )

    --------------------NT low speed traction loss multiplier

    nerdMenu:add_float_range("Low Speed Traction Loss Multiplier", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_low_speed_traction_loss_multiplier()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_low_speed_traction_loss_multiplier(value)  
        end
    )

    --------------------NT mass

    nerdMenu:add_float_range("Mass", 10, -10000.0, 10000.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_mass()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_mass(value)  
        end
    )

    --------------------NT max speed

    nerdMenu:add_float_range("Max Speed", 10, -1000.0, 1000.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_max_speed()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_max_speed(value)  
        end
    )

    --------------------NT roll center height front

    nerdMenu:add_float_range("Front Roll Center Height", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_roll_centre_height_front()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_roll_centre_height_front(value)  
        end
    )

    --------------------NT roll center height rear

    nerdMenu:add_float_range("Rear Roll Center Height", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_roll_centre_height_rear()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_roll_centre_height_rear(value)  
        end
    )

    --------------------NT steering lock

    nerdMenu:add_float_range("Steering Lock", 1.0, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_steering_lock()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_steering_lock(value)  
        end
    )

    --------------------NT Front Suspension Bias

    nerdMenu:add_float_range("Front Suspension Bias", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_suspension_bias_front()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_suspension_bias_front(value)  
        end
    )

    --------------------NT suspension compression damping

    nerdMenu:add_float_range("Suspension Compression Damping", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_suspension_comp_damp()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_suspension_comp_damp(value)  
        end
    )

    --------------------NT suspension force

    nerdMenu:add_float_range("Suspension Force", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_suspension_force()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_suspension_force(value)  
        end
    )


    --------------------NT suspension heaight

    nerdMenu:add_float_range("Suspension Height", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_suspension_height()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_suspension_height(value)  
        end
    )

    --------------------NT suspension lower limit

    nerdMenu:add_float_range("Suspension Lower Limit", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_suspension_lower_limit()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_suspension_lower_limit(value)  
        end
    )

    --------------------NT suspension raise

    nerdMenu:add_float_range("Suspension Raise", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_suspension_raise()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_suspension_raise(value)  
        end
    )

    --------------------NT suspension rebound dampening

    nerdMenu:add_float_range("Suspension Rebound Dampening", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_suspension_rebound_damp()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_suspension_rebound_damp(value)  
        end
    )

    --------------------NT suspension upper limit

    nerdMenu:add_float_range("Suspension Upper Limit", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_suspension_upper_limit()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_suspension_upper_limit(value)  
        end
    )

    --------------------NT front traction bias

    nerdMenu:add_float_range("Front Traction Bias", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_traction_bias_front()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_traction_bias_front(value)  
        end
    )

    --------------------NT Traction Curve Lateral

    nerdMenu:add_float_range("Traction Curve Lateral", 0.1, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_traction_curve_lateral()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_traction_curve_lateral(value)  
        end
    )

    --------------------NT traction curve max

    nerdMenu:add_float_range("Traction Curve Max", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_traction_curve_max()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_traction_curve_max(value)  
        end
    )

    --------------------NT traction curve min

    nerdMenu:add_float_range("Traction Curve Minimum", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_traction_curve_min()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_traction_curve_min(value)  
        end
    )

    --------------------NT traction loss multiplier

    nerdMenu:add_float_range("Traction Loss Multiplier", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_traction_loss_multiplier()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_traction_loss_multiplier(value)  
        end
    )

    --------------------NT traction spring delta max

    nerdMenu:add_float_range("Traction Spring Delta Max", 0.01, -100.0, 100.0,
        function() 
            if not localplayer:is_in_vehicle() then        
                return 1.0
            else
                return localplayer:get_current_vehicle():get_traction_spring_delta_max()
            end
        end,
        function(value)
            currentVehicle = localplayer:get_current_vehicle() 
            currentVehicle:set_traction_spring_delta_max(value)  
        end
    )

    ------some values that will likely never see inclusion in this menu, irrelevant
    --[[Integer vehicle:get_bomb_count()
    bool    vehicle:get_boost()
    bool    vehicle:get_boost_active()
    bool    vehicle:get_boost_enabled()
    Number  vehicle:get_bouyance()
    ]]

    ------some more unused values, although these could be useful

    --[[Number  vehicle:get_collision_damage_multiplier()
    Integer vehicle:get_countermeasure_count()
    bool    vehicle:get_create_money_pickups()
    --Integer --[[ red 0..255 ]]--,
    --Integer --[[ green 0..255 ]],
    --Integer --[[ blue 0..255 ]]
    --        vehicle:get_custom_primary_colour()
    --Integer --[[ red 0..255 ]],
    --Integer --[[ green 0..255 ]],
    --Integer --[[ blue 0..255 ]]
    --        vehicle:get_custom_secondary_colour()
    --Number  vehicle:get_deformation_damage_multiplier()
    --Number  vehicle:get_dirt_level()
    --Integer vehicle:get_door_lock_state()
    --]]
       --[[bool    vehicle:get_drift_tyres_enabled()
    Number  vehicle:get_drift_vehicle_reduced_suspension()]]

        ------------------------NT inertia multiplier
    ---Vector3 vehicle:get_inertia_multiplier()



-------------end of nerd tune




-----------------------utilities and toggles

    -------------------/Clear Wanted Level\-------------------
    submenu:add_action("Clear Wanted Level", function() menu:clear_wanted_level()  end)


    -------------------/repair current vehicle\-------------------
    submenu:add_action("Repair", 
        function() 
            menu.repair_online_vehicle() 

            --if function then set toggle?
            if GodModeState then localplayer:set_godmode(GodModeState) end
            
            --if VDmgToggle then VehicleDamage(enabled) end
            
            --if VGodToggle then VehicleGod(enabled) end

            if VDmgToggle then VDmgToggle = not VDmgToggle end
            
            if VGodToggle then VGodToggle = not VGodToggle end


        end
    )





    ----------------------vehicle god mode

    submenu:add_toggle("God Vehicle (wait after repair)", 
        function() 
            if not localplayer:is_in_vehicle() then 
                VGodToggle = false
            end
            return VGodToggle 
        end,
        function() 
            VGodToggle = not VGodToggle
            VehicleGod(VGodToggle) 
        end
    )
    function VehicleGod(enabled)
        if not localplayer:is_in_vehicle() then 
            return false
        end
        currentVehicle = localplayer:get_current_vehicle()

        if enabled then
            currentVehicle["set_godmode"](currentVehicle, true)
            return
        end
        if not enabled then
            currentVehicle["set_godmode"](currentVehicle, false)
            return
        end
    end


    ----------------------vehicle visible damage

    submenu:add_toggle("Disable Damage (wait after repair)", 
        function() 
            if not localplayer:is_in_vehicle() then 
                VDmgToggle = false
            end
            return VDmgToggle 
        end,

        function() 
            VDmgToggle = not VDmgToggle
            VehicleDamage(VDmgToggle) 
        end
    )
    function VehicleDamage(enabled)
        if not localplayer:is_in_vehicle() then 
            return false
        end
        currentVehicle = localplayer:get_current_vehicle()

        if enabled then
            currentVehicle["set_can_be_visibly_damaged"](currentVehicle, false)
            currentVehicle["set_collision_damage_multiplier"](currentVehicle, 0)
            currentVehicle["set_deformation_damage_multiplier"](currentVehicle, 0)
            return
        end
        if not enabled then
            currentVehicle["set_can_be_visibly_damaged"](currentVehicle, true)
            currentVehicle["set_collision_damage_multiplier"](currentVehicle, 1)
            currentVehicle["set_deformation_damage_multiplier"](currentVehicle, 1)
            return
        end
    end


    -------------------Bulletproof tires

    submenu:add_toggle("Bulletproof Tires", 
        function() 
            if not localplayer:is_in_vehicle() then
                return disabled
            else if localplayer:get_current_vehicle():get_bulletproof_tires() then
                return true
                end
            end
            return false
        end,
        function(enabled)  
            if not localplayer:is_in_vehicle() then 
                return disabled
            end
            
            currentVehicle = localplayer:get_current_vehicle()
            
            if enabled then
                currentVehicle:set_bulletproof_tires(true)
                return enabled
            else    
                currentVehicle:set_bulletproof_tires(false)
                return disabled
            end
        end
    )


    ---------------/Godmode\---------------
    GodModeState = false
    submenu:add_toggle("God Player", function() return GodModeState end, 
        function()
            GodModeState = not GodModeState
            localplayer:set_godmode(GodModeState)
        end)

        ---does this stuff below do anything?

    Godmode = false

    function Godmode()
        while true do
            if localplayer:get_health() ~= localplayer:get_max_health() then
                if Godmode == true then
                    menu.heal_all()
                end
            end
            sleep(0.2)
        end
    end



    submenu:add_toggle("Remove Traffic (host, w.i.p.)", function() return deleteCars end, 
        function() 
            deleteCars = not deleteCars 
            while deleteCars do
                if localplayer:is_in_vehicle() then
                    for veh in replayinterface.get_vehicles() do
                        local deleteConfirm = true
                        for i = 0, 31 do
                            local playerPed = player.get_player_ped(i)
                            if playerPed and playerPed:get_current_vehicle() == veh then
                                deleteConfirm = false
                            end
                        end
                        if deleteConfirm then
                            local pos = veh:get_position()
                            pos.z = pos.z - 100000
                            veh:set_position(pos)
                        end
                    end
                end
                sleep(.7)
            end
        end
    )

    -------------------/Big Map\-------------------
    submenu:add_toggle("Big Map", function() return mapToggle end,
        function(mapToggle)
            if mapToggle then
                menu:set_big_map(true)
                return enabled
            else
                menu:set_big_map(false)
            end 
            return
        end
    )
else 
    submenu:add_action("go online, then reload scripts", function() return end)
end










    -----------------------some preliminary work on possible future features?
    --[[-----------------------drift lights

    ---control neon color by either car angle or accel/decel for aid in tandem drifting

    submenu:add_toggle("Accel/Decel Indicator Lights)", function() return driftLightToggle end,
    function(enabled) 
        driftLightToggle = enabled 
        if not localplayer:is_in_vehicle() then return 
        end
        
        local currentVehicle = localplayer:get_current_vehicle()
        currentVehicle:

        while enabled do
            currentVehicle:get_drive_inertia()
            return
        end

        for name, value in next, savedVehicle do
            currentVehicle["set_"..name](currentVehicle, value)
        end
    end
    )
    ]]


    -----------------PERFORMANCE UPGRADE ADJUSTERS
    --no clue how to do this. seems that it must be done with globals.example or packed stats??
    
    --[[------------------suspension upgrade
    submenu:add_int_range("Suspension Upgrade (broke)", 1, 0, 5,
        function() 
            return V7 
        end,
        function(value) 
            V7 = 0; 
            SuspensionApply(value) 
        end
    )

    function SuspensionApply(value)
        if not localplayer:is_in_vehicle() then 
            return 
        end
        currentVehicle = localplayer:get_current_vehicle()
    end

    -------------------performance 
    submenu:add_toggle("Max Performance (broke)",
        function() 
            return V2 
        end,
        function(enabled) 
            V2 = enabled; 
            PerformanceApply(enabled) 
        end
    )
        
            
    function PerformanceApply(enabled)
        if not localplayer:is_in_vehicle() then 
            return 
        end
        currentVehicle = localplayer:get_current_vehicle()
        if enabled then
            for name, value in next, vehicleChanges do
                savedVehicle[name] = currentVehicle["get_"..name](currentVehicle)
                currentVehicle["set_"..name](currentVehicle, value)
            end
            
            return
        end
        
        for name, value in next, savedVehicle do
            currentVehicle["set_"..name](currentVehicle, value)
        end
    end

    -------------------armor mods

    submenu:add_toggle("Max Armor (broke)",
        function() 
            return V4 
        end,
        function(enabled) 
            V4 = enabled; 
            ArmorApply(enabled) 
        end
    )
                            
            
    function ArmorApply(enabled)
        if not localplayer:is_in_vehicle() then 
            return 
        end
        currentVehicle = localplayer:get_current_vehicle()
        if enabled then
            for name, value in next, vehicleChanges do
                savedVehicle[name] = currentVehicle["get_"..name](currentVehicle)
                currentVehicle["set_"..name](currentVehicle, value)
            end
            
            return
        end
        
        for name, value in next, savedVehicle do
            currentVehicle["set_"..name](currentVehicle, value)
        end
    end

    -------------------Brakes mod

    submenu:add_toggle("Max Brakes (broke)",
        function() 
            return V3 
        end,
        function(enabled) 
            V3 = enabled; 
            BrakesApply(enabled) 
        end
    )
            
    function BrakesApply(enabled)
        if not localplayer:is_in_vehicle() then 
            return 
        end
        currentVehicle = localplayer:get_current_vehicle()
        
        if enabled then
            for name, value in next, vehicleChanges do
                savedVehicle[name] = currentVehicle["get_"..name](currentVehicle)
                currentVehicle["set_"..name](currentVehicle, value)
            end    
            return
        end
        
        for name, value in next, savedVehicle do
            currentVehicle["set_"..name](currentVehicle, value)
        end
    end
    ]]

        --[[-----------------allgod-------------

    submenu:add_action("AllGod",
        function()
            GodModeState = true
            localplayer:set_godmode(GodModeState)
            VDmgToggle = true
            VehicleDamage(enabled)
            VGodToggle = true
            VehicleGod(enabled)
        end    
    )
    ]]






    ---------different attempts at traffic remover

       --extrasmenu = submenu:add_submenu("extras") 

    --[[-------------------Traffic Remover    ----------------------
 
    local function ShouldDelete(veh)
        for i = 0, 31 do
            local currentPed = player.get_player_ped(i)
            if currentPed then
                local pedVehicle = currentPed:get_current_vehicle()
                local currentVehicle = localplayer:get_current_vehicle()
                if veh == pedVehicle or veh == currentVehicle then
                    return false
                end
            end
        end
        return true
    end

    local function TPCars()
        if deleteCars then
            repeat
                for veh in replayinterface.get_vehicles() do
                    if ShouldDelete(veh) then
                        local pos = veh:get_position()
                        pos.x = pos.x
                        pos.y = pos.y
                        pos.z = pos.z - 100000
                        veh:set_position(pos)
                    end
                end
                sleep(0.01)
            until(not deleteCars)
        end
    end
    
    submenu:add_toggle("Remove Traffic (host [w.i.p.])", function() return deleteCars end, 
        function() 
            deleteCars = not deleteCars 
            TPCars(deleteCars) 
        end
    )

    --local deleteCars = false
    
    submenu:add_toggle("Remove Traffic (host, w.i.p.)", function() return deleteCars end, 
        function() 
            deleteCars = not deleteCars 
            if deleteCars then
                repeat
                    for veh in replayinterface.get_vehicles() do
                        local deleteConfirm = false
                        for allPed in replayinterface.get_peds() do
                            if allPed:is_in_vehicle() and allPed:get_current_vehicle() == veh then
                                deleteConfirm = true
                                for i = 0, 31 do
                                    local playerPed = player.get_player_ped(i)
                                    if playerPed == allPed then
                                        deleteConfirm = false
                                    end
                                end
                            end
                        end
                        if deleteConfirm then
                            local pos = veh:get_position()
                            pos.z = pos.z - 100000
                            veh:set_position(pos)
                        end
                    end
                    --sleep(1)
                until(not deleteCars)
            end
        end
    )]]


    --[[submenu:add_toggle("Remove Traffic (host, w.i.p.)", function() return deleteCars end, 
        function() 
            deleteCars = not deleteCars 
            while deleteCars do
                local deleteConfirm = false
                for allPed in replayinterface.get_peds() do
                    local pedVeh = allPed:get_current_vehicle()
                    if pedVeh then
                        deleteConfirm = true
                        for i = 0, 31 do
                            local playerPed = player.get_player_ped(i)
                            if playerPed == allPed then
                                deleteConfirm = false
                            end
                        end
                        if deleteConfirm then
                            local pos = pedVeh:get_position()
                            pos.z = pos.z - 100000
                            pedVeh:set_position(pos)
                        end
                    end
                end
                sleep(.75)
            end
        end
    )]]

    
    --[[local function DeleteVehicle(veh)
    local pos = veh:get_position()
    pos.z = pos.z - 100000
    veh:set_position(pos)
    end

    local function ShouldDelete(veh)
        for i = 0, 31 do
            local currentPlayer = player.get_player_ped(i)
            if currentPlayer then
                local playerVehicle = currentPlayer:get_current_vehicle()
                if playerVehicle and veh == playerVehicle then
                    return false
                end
            end
        end
        return true
    end

    submenu:add_toggle("Remove Traffic (host, w.i.p.)", function() return deleteCars end,
        function() 
            deleteCars = not deleteCars
            while deleteCars do
                for allPed in replayinterface.get_peds() do
                    veh = allPed:get_current_vehicle()
                    if veh and ShouldDelete(veh) then
                        DeleteVehicle(veh)
                    end
                end
                sleep(1)
            end
        end
    )]]
