local Rad        =   peripheral.wrap("top")
local C         =   peripheral.wrap("back")
 
 --写的比较赶，看起来很乱
-- 获取实体数据并处理攻击动作
function GetEntitydata()
    C.assemble()
    redstone.setAnalogOutput("back",0)   --初始化攻击动作
    local Rad_data=Rad.scan("entity",40) --扫描实体，范围40格
    local entity_pos_x={}
    local entity_pos_y={}
    local entity_pos_z={}
    local entity_pos_c={}
 
    local turret_yaw={}
    local turret_yaw_error={}
    local turret_pitch={}
    local turret_pitch_error={}
     
 
 
    if Rad_data==nil then
        print("no find entity")
        redstone.setAnalogOutput("back",0) 
        
    else
        for key,value in pairs(Rad_data) do
                local data_base=value 
            --print(data_base.x,data_base.y,data_base.z)
                  
                if data_base.category=="MONSTER" then
                     
                    --[[table.insert(entity_pos_x,data_base.x)
                    table.insert(entity_pos_y,data_base.y)
                    table.insert(entity_pos_z,data_base.z)
                    table.insert(entity_pos_c,data_base.category)   ]]--
 
                    local yaw=math.atan2((data_base.x),-1*(data_base.z))*180/math.pi
                    local pitch=math.atan2(data_base.y,math.sqrt(data_base.x^2+data_base.z^2))*180/math.pi
                    
                    table.insert(turret_yaw,yaw)
                    table.insert(turret_pitch,pitch)
                        
                        for key, value in ipairs(turret_yaw) do
                            if key-1>1 then
                                local yaw_error=math.abs(turret_yaw[key])-math.abs(turret_yaw[key-1])
                                --print(math.abs(turret_yaw[key]),math.abs(turret_yaw[key-1]),yaw_error)
                                table.insert(turret_yaw_error,yaw_error)    
 
                            end
                             
                        end
                        for key, value in ipairs(turret_pitch_error) do
                                if key-1>1 then
                                    local pitch_error=math.abs(turret_pitch[key])-math.abs(turret_pitch[key-1])
                                    --print(math.abs(turret_pitch[key]),math.abs(turret_pitch[key-1]),pitch_error)
                                    table.insert(turret_pitch_error,pitch_error)
                                end
                        end
                        for key1, value in ipairs(turret_yaw_error) do
                            if turret_yaw_error[key1+2]~=nil then
                                yaw_error=math.abs(turret_yaw_error[key1+1])-math.abs(turret_yaw_error[key1+2])   
                                yaw=yaw+yaw_error
                                print(yaw,yaw_error)
                            end
 
                        end
                        for index, value in ipairs(turret_pitch_error) do
                            if turret_pitch_error[index+2]~=nil then
                                pitch_error=math.abs(turret_pitch_error[index+1])-math.abs(turret_pitch_error[index+2])
                                pitch=pitch+pitch_error
                                print(pitch,pitch_error)
                             
                            end
                     
                             
                        end
                         
                         
                        C.setYaw(yaw+0.55)
                        C.setPitch(pitch)
                        redstone.setAnalogOutput("back",15)   
                        os.sleep(0.5)
                        redstone.setAnalogOutput("back",0)   
                        
 
                end
                
                 
        end
         
         
        
       
 
    end
end
 
-- 实体扫描函数

-- 主循环，每次获取实体数据
while true do
     GetEntitydata()
     os.sleep(0)
end
