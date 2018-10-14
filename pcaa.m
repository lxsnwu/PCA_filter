% load pca_amp
% rownum=size(input_test,1);
% input_test=(input_test-repmat(mu,rownum,1))./repmat(sigma,rownum,1);
% input_test=input_test*coeff;

[ mu,sigma,coeff,score,latent ] = pca_amp(lpf_Rev0a);
%简单滤波前be_R0
%滤波后lpf_Rev0a


%画出PCA降维之前的图
subplot(2,1,1);plot(lpf_Rev0a); 
ylabel('CSI amplitude');
%ylim([-10 20])
xlabel('Package number ');

%----------------------------------------------------------------------
%画出PCA降维之后的图
figure(1);
rownum=size(lpf_Rev0a,1);
PCA_lpf_Rev0a=(lpf_Rev0a-repmat(mu,rownum,1))./repmat(sigma,rownum,1);
PCA_lpf_Rev0a=PCA_lpf_Rev0a*coeff;

%subplot(2,1,2);plot(score);
subplot(2,1,2);plot(PCA_lpf_Rev0a);
ylabel('CSI amplitude');
xlabel('Package number ');


for j = 1:length(PCA_lpf_Rev0a)
    PCA_lpf_Rev0a_one(j,1) = PCA_lpf_Rev0a(j,1);
end
figure(2);
plot(PCA_lpf_Rev0a_one);
ylim([-30 30]);






