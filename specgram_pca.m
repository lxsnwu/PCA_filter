
anaFlag = 1;
window = 1*256;%256
noverlap = 1*244;%128       影响y轴的分辨率
%nfft = 1*100*1000;% f=-8E6 : 0.1E6 :8E6;
nfft=0 : 0.1 :80;%带宽         影响X轴的分辨率
fs = 1000;% 采样率
%nfft越大，频域的分辨率就越高（分辨率=fs/nfft），但离瞬时频率就越远；
%noverlap影响时间轴的分辨率，越接近nfft，分辨率越高，相应的冗余就越多，计算量越大，但计算机只要能承受，问题不大。
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