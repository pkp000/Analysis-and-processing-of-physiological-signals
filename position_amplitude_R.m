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
%�����ĵ��ź�ȥ����ɺ󡪡�
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

%������ƽ��ֵ��8������ֵ���ƽ��ֵ
thrmax=thr/8;               
 
zerotemp=sort(x);
zerovalue=0;
for i=1:100
    zerovalue=zerovalue+zerotemp(i);
end

%��С����ƽ��ֵ���������ȣ�100����С��ֵ���ƽ��ֵ
zerovalue=zerovalue/100; 

%�����С���ȵĲ�ֵ��30%Ϊ�б�R������ֵ   
thr=(thrmax-zerovalue)*0.3;                       
 
%��λR��
rvalue=[];
for i=1:thrlen
    if sigmax(i,1)>thr
        rvalue=[rvalue;sigmax(i,2)];
    end
end
rvalue_1=rvalue;
 
%�ų���죬���������������ֵ���С��0.4s����ȥ�����Ƚ�С��һ��
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

% ��ԭ�ź��Ͼ�ȷУ׼
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
