function [fil_sig,y_fil_sig] = butt_nofigure(data,fs,low,high)
% butter worth filter
% 
%   input: 
%        data:           vector with signal values
%        fs:             sampling frequency
%        low:            low pass frequency
%        high:           gigh pass frequency
%   output: 
%        fil_sig:        signal after filtering
%        y_fil_ecg:      the fft of signal after filtering
% 

[b,a] = butter(3,[49*2/fs 51*2/fs],'stop');
fil_sig_0 = filtfilt(b,a,data);
[b1,a1]=butter(3,low/(fs/2),'high');
fil_sig_1 = filtfilt(b1,a1,fil_sig_0);
[b2,a2]=butter(3,high/(fs/2),'low');
fil_sig = filtfilt(b2,a2,fil_sig_1);

N=length(data);
f=(0:N/2-1)*fs/N;
y1 = abs(fft(data));
y_sig_ori=2*y1(1:N/2)/N;
y2 = abs(fft(fil_sig));
y_fil_sig=2*y2(1:N/2)/N;

end