clear all; close all; clc; format compact;
warning('off');

filepath1 ='E:\Python\wifi CSI tool\maltab\data1012\';
filepath2 ='E:\Python\wifi CSI tool\maltab\data1012\';
% filepath1 = 'C:\Users\Administrator\Desktop\CSI_12_23\test3\';  % 无干扰
% filepath2 = 'C:\Users\Administrator\Desktop\CSI_12_23\hengzhepaishou\'; % 目标+干扰
% get_scaled_csi.m：此处的CSI信息H是根据噪声功率归一化之后的H；
% normalized the CSI (in textbooks, usually called H) such that there is unit noise.
csi_trace1 = read_bf_file([filepath1  'walk02-2.dat']); % 推拉，51~100 无干扰; 1~50 静干扰；
ii0 =1:length(csi_trace1);
csi_trace2 = read_bf_file([filepath2  'jump01-2.dat']); % 推拉，1~50 目标+干扰(disanci)
ii1 =1:length(csi_trace2);


kk = 1;
csi_trace = csi_trace1;
%采集不同天线上的数据
for i = 1:length(csi_trace);
    [kk i]
    csi_entry1 = csi_trace{i};
    csi = get_scaled_csi(csi_entry1);
    for j = 1:30
        Rev1(i,j) = csi(1,1,j); % 第1个接收天线：维度：时域采样点数*子载波数
        Rev2(i,j) = csi(1,2,j); % 第2个接收天线
        Rev3(i,j) = csi(1,3,j); % 第3个接收天线
    end
end
Rev0a =  abs(Rev3);
be_R0 = Rev0a;

csi_trace = csi_trace2;
for i = 1:length(csi_trace)
    [kk+1 i]
    csi_entry1 = csi_trace{i};
    csi = get_scaled_csi(csi_entry1);
    for j = 1:30
        Rev1(i,j) = csi(1,1,j); % 第1个接收天线：维度：时域采样点数*子载波数
        Rev2(i,j) = csi(1,2,j); % 第2个接收天线
        Rev3(i,j) = csi(1,3,j); % 第3个接收天线
    end
end
Rev1a =  abs(Rev3);
be_R1 = Rev1a;

% =========LPF低通滤波器==============================
fs = 1000;          % 采样频率
wp = 4*1/(fs/2);    % 通带边界频率  上界 pi rad/sample
ws = 4*5/(fs/2);    % 阻带截止频率  下界 pi rad/sample
Rp = 1;             % 通带最大衰减 dB
As = 30;            % 阻带最小衰 dB
[N,wc] = buttord(wp,ws,1,30); % 估计滤波器的阶数N, wc滤波器的3 dB频率
[B,A] = butter(N,wc);
lpf_Rev0a = filter(B,A,Rev0a,[],1);
lpf_Rev0a = bsxfun(@minus, lpf_Rev0a , mean(lpf_Rev0a(180:900,:),1));

% figure; plot(lpf_Rev0a) plot(lpf_Rev0a)
% 
lpf_Rev1a = filter(B,A,Rev1a,[],1);
lpf_Rev1a = bsxfun(@minus, lpf_Rev1a , mean(lpf_Rev1a(180:900,:),1));

%未校准前的相位图，横坐标t
an_be = angle(lpf_Rev1a(:,5));

Fs = 1000; % 采样频率
NFFT = 2048;  
% ii0 = 1180:1802; % 1- 41
% ii0 = 1324:2324; % 1 - 31
L = length(ii0);    
Y = fft(lpf_Rev0a(ii0, :),NFFT)/L;      
f = Fs/2*linspace(0,1,NFFT/2+1); 
Rev0p = angle(Y(1:NFFT/2+1,:));
Rev0a = 2*abs(Y(1:NFFT/2+1,:));

% ii1 = 6630:8174; % 40
% ii1 = 6300:7900; % 30
% ii1 = 6686:7952; % 15
L = length(ii1);    
Y = fft(lpf_Rev1a(ii1, :),NFFT)/L;      
Rev1p = angle(Y(1:NFFT/2+1,:));
Rev1a = 2*abs(Y(1:NFFT/2+1,:));

%k = [-28,-26,-24,-22,-20,-18,-16,-14,-12,-10,-8,-6,-4,-2,-1,1,3,5,7,9,11,13,15,17,19,21,23,25,27,28];
k = [-28:2:-2 -1 1 2:2:28];
rp = bsxfun(@plus, ((Rev0p(:,end)-Rev0p(:,1))./(k(end)-k(1))*k), mean(Rev0p,2));
r_Rev0p = Rev0p - rp; % 相位矫正
rp = bsxfun(@plus, ((Rev1p(:,end)-Rev1p(:,1))./(k(end)-k(1))*k), mean(Rev1p,2));
r_Rev1p = Rev1p - rp; 


% FF = 1:30;
% % figure(5);clf;                                  
% % polar(Rev0p(FF,:),lpf_Rev0a(FF,:),'*'); hold on
% % polar(r_Rev0p(FF,:),lpf_Rev0a(FF,:),'r*');
% for ii1 = 1:30
%     scatter(Rev0a(FF,ii1),Rev0p(FF,ii1),'k*'); hold on; grid on
%     scatter(Rev0a(FF,ii1),r_Rev0p(FF,ii1),'r*');
%     ii1 = ii1 + 1;
% end
% 
% % figure(6);clf;                                  
% % polar(Rev1p(FF,:),lpf_Rev1a(FF,:),'*'); hold on
% % polar(r_Rev1p(FF,:),lpf_Rev1a(FF,:),'r*');
% for ii1 = 1:30
%     scatter(Rev1a(FF,ii1),Rev1p(FF,ii1),'k*'); hold on; grid on
%     scatter(Rev1a(FF,ii1),r_Rev1p(FF,ii1),'r*');
%     ii1 = ii1 + 1;
% end

% mean(var(r_Rev0p(FF,:)))
% mean(var(r_Rev1p(FF,:)))
% [r,c] = size(Rev0p(FF,:));
% pp0 = reshape(Rev0p(FF,:),1,r*c);
% [r,c] = size(Rev0p(FF,:));
% pp1 = reshape(Rev1p(FF,:),1,r*c);
% figure;hist(pp0); grid on; hold on
% hist(pp1);

% [r,c] = size(r_Rev0p(FF,:));
% pp0 = reshape(r_Rev0p(FF,:),1,r*c);
% [r,c] = size(r_Rev1p(FF,:));
% pp1 = reshape(r_Rev1p(FF,:),1,r*c);
% figure;hist(pp0); grid on; hold on
% hist(pp1);

% [r,c] = size(r_Rev0p);
% pp0 = reshape(r_Rev0p,1,r*c);
% [r,c] = size(r_Rev1p);
% pp1 = reshape(r_Rev1p,1,r*c);


% 
% mean(var(r_Rev0p./bsxfun(@times,max(r_Rev0p),ones(NFFT/2+1,1))))
% mean(var(r_Rev1p./bsxfun(@times,max(r_Rev1p),ones(NFFT/2+1,1))))
% mean(var(Rev0p./bsxfun(@times,max(Rev0p),ones(NFFT/2+1,1))))
% mean(var(Rev1p./bsxfun(@times,max(Rev1p),ones(NFFT/2+1,1))))


% close all; 
t1=mean(var(r_Rev0p/max(max(r_Rev0p))))
t2=mean(var(r_Rev1p/max(max(r_Rev1p))))
% t3=mean(var(Rev0p/max(max(Rev0p))))
% t4=mean(var(Rev1p/max(max(Rev1p))))
% % return
% 
%figure(1)
subplot(2,1,1);plot(lpf_Rev0a); 
ylabel('CSI amplitude');
xlabel('Package number ');

subplot(2,1,2);plot(lpf_Rev1a);
ylabel('CSI amplitude');
xlabel('Package number ');
% scatter(lpf_Rev2a(NN:end-NN1,1),Rev2p(NN:end-NN1,1),'*'); hold on; grid on
% scatter(lpf_Rev2a(NN:end-NN1,1),r_Rev2p(NN:end-NN1,1),'r*');

% mean(var(r_Rev2p(NN:end-NN1,:)))

% polar(Rev2p(NN:NN1,:),lpf_Rev2a(NN:NN1,:),'*'); hold on
% polar(r_Rev2p(NN:NN1,:),lpf_Rev2a(NN:NN1,:),'r*');
% polar(Rev2p(NN:end-NN1,:),lpf_Rev2a(NN:end-NN1,:),'*'); hold on
% polar(r_Rev2p(NN:end-NN1,:),lpf_Rev2a(NN:end-NN1,:),'r*');
% polar(Rev2p(2515:3656,:),lpf_Rev2a(2515:3656,:),'*');

%polar(r_Rev2p(2215:3356,:),lpf_Rev2a(2215:3356,:),'r*');
% figure(6);
% polar(r_Rev2p(2515:3656,:),lpf_Rev2a(2515:3656,:),'r*');

% figure(5);clf;                                  
% polar(Rev2p(500:end-90,:),lpf_Rev2a(500:end-90,:),'*'); hold on
% polar(r_Rev2p(500:end-90,:),lpf_Rev2a(500:end-90,:),'r*');

% figure(5)                                  
% polar(Rev2p(1453:2130,2),lpf_Rev2a(1453:2130,2),'*'); hold on
% polar(r_Rev2p(1453:2130,2),lpf_Rev2a(1453:2130,2),'r*'); 

% figure(5)                                  
% polar(r_Rev2p(:,1),lpf_Rev2a(:,1),'r*'); 
