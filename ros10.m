
rosinit('192.168.159.131')
robot = rospublisher('/mobile_base/commands/velocity');
velmsg = rosmessage(robot);
laser = rossubscriber('/scan');
scan = receive(laser,15)
odomSub = rossubscriber("/odom","DataFormat","struct");



spinVelocity = 5.0;       % Angular velocity (rad/s)
forwardVelocity = 0.50;    % Linear velocity (m/s)
backwardVelocity = -0.02; % Linear velocity (reverse) (m/s)
distanceThreshold = 0.9;  % Distance threshold (m) for turning
tic;
  while toc < 100
      % Collect information from laser scan
      scan = receive(laser);
      %plot(scan);
      data = readCartesian(scan);
      x = data(:,1);
      y = data(:,2);
      % Compute distance of the closest obstacle
      dist = sqrt(x.^2 + y.^2);
      minDist = min(dist);     
      % Command robot action
      if minDist < distanceThreshold
          % If close to obstacle, back up slightly and spin
        
          velmsg.Angular.Z = spinVelocity;
          velmsg.Linear.X = backwardVelocity;
      else
          % Continue on forward path
          velmsg.Linear.X = forwardVelocity;
          velmsg.Angular.Z = 0;

          
      end   
      send(robot,velmsg);
%       odomSub = rossubscriber("/odom","DataFormat","struct");
odomMsg = receive(odomSub,3);
pose = odomMsg.Pose.Pose;
x = pose.Position.X;
y = pose.Position.Y;
z = pose.Position.Z;



%       [position, orientation, velocity] = getState(kobuki);
%     
%     path(i,:)=[pose];
%     
%      
%     
%            opath=path;
%   vpath=opath(:,1:2);
%    vel(i, :)=[velocity.Linear];
%    
%  
%  
%   plot
        plot(x, y,'g');
%        axis equal 
%      
%  subplot( 2,1,2)
%        plot(vel(:,1),'g');
% %        
%        subplot( 2,2,3)
%        plot(vel(:,2),'b');
        hold on 
        axis equal 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      
      
  end
rosshutdown
