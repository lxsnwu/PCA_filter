
anaFlag = 1;
window = 1*256;%256
noverlap = 1*244;%128       Ӱ��y��ķֱ���
%nfft = 1*100*1000;% f=-8E6 : 0.1E6 :8E6;
nfft=0 : 0.1 :80;%����         Ӱ��X��ķֱ���
fs = 1000;% ������
%nfftԽ��Ƶ��ķֱ��ʾ�Խ�ߣ��ֱ���=fs/nfft��������˲ʱƵ�ʾ�ԽԶ��
%noverlapӰ��ʱ����ķֱ��ʣ�Խ�ӽ�nfft���ֱ���Խ�ߣ���Ӧ�������Խ�࣬������Խ�󣬵������ֻҪ�ܳ��ܣ����ⲻ��
if anaFlag==1
    left =1;
      %[S,F,T,P]=spectrogram(x,window,noverlap,nfft,fs)
      [S,F,T,P] = spectrogram(PCA_lpf_Rev0a_one,window,noverlap,nfft,fs);
    l=length(PCA_lpf_Rev0a_one);
     rp = real(P);
     RP=10*log10(P);
   figure;
surf(T,F,10*log10(P),'edgecolor','none');
axis tight;
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz');
%title(address);
   % loadBinDataasComplex();
 end