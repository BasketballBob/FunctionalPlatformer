
//Obstacle Manager Alarm
if(omAlarm > 0)
{
    omAlarm -= 1;
}
//Obstacle Alarm Disabler
else
{
    //Reactivate All Obstacles
    instance_activate_object(obj_obstacle);
    
    //Check All Obstacle Instances
    for(i = 0;i < instance_number(obj_obstacle);i++)
    {
        omInst = instance_find(obj_obstacle,i);
        omX = view_xview[0]+view_wview[0]/2;
        omY = view_yview[0]+view_hview[0]/2;
        omDist = sqrt(sqr(omInst.x-omX)+sqr(omInst.y-omY));
        
        //Turn Off Far Instances
        if(omDist > omActiveDist)
        {
            instance_deactivate_object(omInst);
        }        
    }

    //Reset OmAlarm
    omAlarm = omTime;
}
