function [R_pos,R_amp,rvalue] =  position_amplitude_R01(x)
% Locate the R wave, extract the position 
% and amplitude of the R wave and assign the value
% 
%   input: 
%        x:              filtered, smoothed single signal
%   output: 
%        R_pos:          extract the position of all R waves
%        R_amp:          the amplitude of the extracted full R wave
%        rvalue:         records data for location
%
%——心电信号去噪完成后——
yabs=abs(x); 
sigtemp=x;
siglen=length(x);
sigmax=[];
for i=1:siglen-2
    if (x(i+1)>x(i)&&x(i+1)>x(i+2))||(x(i+1)<x(i)&&x(i+1)<x(i+2))
        sigmax=[sigmax;abs(sigtemp(i+1)),i+1];
    end
end
thrtemp=sort(sigmax);
thrlen=length(sigmax);
thr=0;
for i=(thrlen-7):thrlen
    thr=thr+thrtemp(i);
end

%最大幅度平均值，8个最大幅值点的平均值
thrmax=thr/8;               
 
zerotemp=sort(x);
zerovalue=0;
for i=1:100
    zerovalue=zerovalue+zerotemp(i);
end

%最小幅度平均值，对消幅度，100个最小幅值点的平均值
zerovalue=zerovalue/100; 

%最大、最小幅度的差值的30%为判别R波的阈值   
thr=(thrmax-zerovalue)*0.3;                       
 
%定位R波
rvalue=[];
for i=1:thrlen
    if sigmax(i,1)>thr
        rvalue=[rvalue;sigmax(i,2)];
    end
end
rvalue_1=rvalue;
 
%排除误检，如果相邻两个极大值间距小于0.4s，则去掉幅度较小的一个
lenvalue=length(rvalue);
i=2;
while i<=lenvalue
      if (rvalue(i)-rvalue(i-1))*(1/800)<0.1
          if yabs(rvalue(i))>yabs(rvalue(i-1))
              rvalue(i-1)=[];
          else
              rvalue(i)=[];
          end
 
          lenvalue=length(rvalue);
          i=i-1;
      end
      i=i+1;
end      
 
lenvalue=length(rvalue);

% 在原信号上精确校准
for i=1:lenvalue
    if (x(rvalue(i))>0)
        k=(rvalue(i)-5):(rvalue(i)+5);
         [a,b]=max(x(k));
        rvalue(i)=rvalue(i)-6+b; 
    else
        k=(rvalue(i)-5):(rvalue(i)+5);
        [a,b]=min(x(k));
        rvalue(i)=rvalue(i)-6+b; 
    end
end
R_amp = x(rvalue);
R_pos = rvalue
end
