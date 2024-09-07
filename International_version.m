clear all
clc
fs=1000;low=0.2;high=20;

try
    % Data reading and loading
    n = 1;
    
    for u = 1:3
        expr1 = ['ECG_',num2str(u),'_10 = zeros(4000,1);ECG_'...
            ,num2str(u),'_10 = zeros(4000,1);'];
        eval(expr1);
    end
    
    while 1
        m = num2str(n);
        p = ['ECG_',m,'_10.mat'];
        load(p);
        n = n+1;
    end
    
catch
    for u = 1:n-1
   
        if u == 3
            ECG_3_10 = ECG_3_10(700:1200);
        else
            expr2 = ['ECG_',num2str(u),'_10','=ECG_',num2str(u),'_10(1:2500)'];
            eval(expr2);
        end

        % Normalization
        expr3 = ['data = (ECG_',num2str(u),'_10-min(ECG_',num2str(u),...
            '_10))/(max(ECG_',num2str(u),'_10)-min(ECG_',num2str(u),'_10))'];
        eval(expr3);

        % Filtering (function)
        [fil_sig,y_fil_sig] = butt_nofigure(data,fs,low,high);
        

        % Smoothing (function)
        expr4 = ['[fil_sig1_',num2str(u),'] = fig_smooth(fil_sig)'];
        eval(expr4);

        % Locate the R wave, extract the position and amplitude of the R wave 
        % and assign the value (function)
        expr5 = ['[R_pos_',num2str(u),',R_amp_',num2str(u),...
            ',rvalue_',num2str(u),'] =  position_amplitude_R(fil_sig1_',...
            num2str(u),')'];
        eval(expr5);
    end

        % Plot and annotate R waves
        for k = 1:n-1
            subplot(n-1,2,k)
            eval(['plot(fil_sig1_',num2str(k),')']);
            % title:
            TITLE = [num2str(k),'号的心电信号和R波'];
            title(TITLE,'position',[1250,-0.5],'FontSize',14);
            if k == 3
                title(TITLE,'position',[300,-0.25],'FontSize',14);
            else
                title(TITLE,'position',[1250,-0.5],'FontSize',14);
            end
            hold on;
            expr6 = ['plot(rvalue_',num2str(k),',fil_sig1_',num2str(k),...
                '(rvalue_',num2str(k),'),"r^")'];
            eval(expr6);
            

            % Calculate heart rate,the principle is as follows:
            % R_pos_calculation =R_pos *0.004;
            % RR_all = ones(length(R_pos_calculation)-1,1);
            eval(['R_pos_calculation = R_pos_',num2str(k),'*0.001']);
            if k == 3
                R_pos_calculation =R_pos_3 *0.004;
            end
            
            for i = 2:length(R_pos_calculation)
                RR_all(i-1) = R_pos_calculation(i) - R_pos_calculation(i-1);
            end

            RR_mean = mean(RR_all);
            RR_SD = std(RR_all);
            eval(['HR',num2str(k),' = 60/RR_mean']);
            
            % The heart rate is an integer, so it is rounded up
            eval(['HR_',num2str(k),' = round(HR',num2str(k),')']);
            disp(eval(['HR_',num2str(k)]));
        end
end

