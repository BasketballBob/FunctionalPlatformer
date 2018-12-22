//CAMERA VARIABLE INTIATION MAY BE LOCATED IN THE PLAYER CREATE EVENT

//Special Camera Conditions
if(room = rm_elevator1 || room = rm_elevator2 || room == rm_elevator3 || room == rm_elevator4 ||
room == rm_elevator5 || room == rm_elevator6 || room == rm_elevator7 || room == rm_elevator8)
{
    //Initialize Elevator Vas
    if(cameraTimeline == 0)
    {
        //Create Elevator Aesthetic Manager
        instance_create(x,y,obj_elevatorAesthetic);
        
        //Modify Cam Starting Position
        view_yview[0] += elStartYOffSet;
    }
    
    //Increment Camera Timeline
    cameraTimeline += 1;
    
    //Elevator Pulling Up
    if(cameraTimeline > 100 && cameraTimeline < 100+elDropTime)//view_yview[0] != camOgY+elDropDist)
    {
        view_yview[0] += elDropDist/elDropTime;
    }
    
    //Background Accelerator 
    if(cameraTimeline > 100 && background_vspeed[0] < elBackSpeed)
    {
        if(elBackAlarm > 0)
        {
            elBackAlarm -= 1;
        }
        else
        {
            background_vspeed[0] += 1;
            elBackAlarm = elBackRate;
        }
    }
    
    //Elevator Shaking
    else if(cameraTimeline > 100+elDropTime) //(cameraTimeline > 180)
    {
        //Manipulate Shakespeed
        if(elShakeAlarm > 0)
        {
            elShakeAlarm -= 1;
        }
        else
        {           
            if(view_yview[0] < camOgY+elDropDist+elStartYOffSet)
            {
                elShakeSpeed += elShakeRate;                
            }
            else if(view_yview[0] > camOgY+elDropDist+elStartYOffSet)
            {
                elShakeSpeed -= elShakeRate;
            }
            elShakeAlarm = elShakeDelay;
        }
        
        //Move Camera
        view_yview[0] += elShakeSpeed;
        
        exit;
    }
}

//Determine Cam Local
if(!dead)
{
    //UNUSED SHIT (DO NOT TOUCH)
    //cdx = x-view_wview[0]/2-80*image_xscale;
    
    //Check For Change In Player Direction
    if(image_xscale != lastXScale)
    {
        camXDist = 0;
    }   
    lastXScale = image_xscale;
    
    //Increment CamXDist
    if(camXDistEnabled)
    {
        if(camXDist+camXRate < camXCap)
        {
            camXDist += camXRate;
        }
        else
        {
            camXDist = camXCap;
        }
    }
    //Set Variables For Disabled CamXDist
    else if(!camXDistEnabled)
    {
        camXDist = 0;
        camXSpeedRatio = .050; //.035
    }
    
    //Define Camera Desired X-Positon
    if(!cutscene)
    {
        cdx = x-view_wview[0]/2-round(camXDist)*image_xscale;
        //show_debug_message("EEEE");
        //show_debug_message(cdx);
        //show_debug_message(room_width/2);
    }
}

//Operate Camera Horizontal
if(cdx > 0 && cdx < room_width-view_wview[0]) // view_wview[0]/2 && room_width-view_wview[0]/2
{
    //view_xview[0] = x-view_wview[0]/2;
    
    //Move Camera Towards Determined Location
    if(cx != cdx) //1
    {
        cx += sign(cdx-cx)*ceil(abs(cdx-cx)*camXSpeedRatio); //.25
    }
}
else
{
    if(cdx < (room_width-view_wview[0])/2)
    {
        //show_debug_message("LEFT");
        cdx = 0;
        if(cx != cdx){
            cx += sign(cdx-cx)*ceil(abs(cdx-cx)*camXSpeedRatio); //.25
        }
    }
    else
    {
        //show_debug_message("RIGHT");
        cdx = room_width-view_wview[0];
        if(cx != cdx){
            cx += sign(cdx-cx)*ceil(abs(cdx-cx)*camXSpeedRatio); //.25
        }
    }
}

//Move Camera
view_xview[0] = round(cx); //No Round

//Camera Vertical
if(instance_exists(obj_water) && room != rm_tutorial_intro4 || room == rm_level5)
{     
    //Actually Move Camera 
    if(abs(cdy-cy) > 1) //1
    {
        //cy += (cdy-cy)*.02;
        //cy += sign((cdy-cy))*2;
        cy += sign(cdy-cy)*ceil(abs(cdy-cy)*.02);
        //cy += .5;
    }
    else 
    {
        cy = cdy;
    }
    
    //Set Camera Desired Location
    if(!cutscene)
    {
        if(place_meeting(x,y+1,obj_jumpPad))
        {
            cdy = y-view_hview[0]/1.1;
        }
        else if(place_meeting(x,y+1,obj_wall) && !dead)  ///place_meeting(x,y+1,obj_wall)
        {
            cdy = y-view_hview[0]/1.4;
        }
    }
        
    //Move Camera Towards Determined Location
    if(cdy > 0 && cdy < room_height-view_hview[0])
    {
        //Do Nothing
    }
    else 
    {
        if(cdy > room_height/2)
        {
            cdy = room_height-view_hview[0];
        }
        else
        {
            cdy = 0;
        }
    }
    
    //Set Cameraview
    view_yview[0] = round(cy); //No Round
}

//Attach Camera To Player
if(!playerLocked)
{
    cx = cdx;
    cy = cdy;
    playerLocked = true;
}

