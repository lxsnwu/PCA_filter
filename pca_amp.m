
function [ mu,sigma,coeff,score,latent ] = pca_amp( originalData )
% originalData����ԭʼ���ݣ�ÿ�д���һ�飻
% ��׼�����ݣ�mu-ÿ�еľ�ֵ��sigma-ÿ�еı�׼��;
% PCA��ά���ݣ�coeff-ϵ������score-PCA��ά���;latent-�������ɷֵ�Ӱ���ʣ�%����
 
%ѵ��ʱ��
%1�����ݱ�׼�����������׼�����õĲ�����
%2��PCA��ά��
%3��ѡ��ά�ȣ�һ��ѡ���ۼ�Ӱ���ʴ���95%��ǰ����ά�ȣ������������õ�������ֵ��ϵ������
 
 
%1�����ݱ�׼����Z-��׼��������ݣ�mu-ÿ�еľ�ֵ��sigma-ÿ�еı�׼�
[Z,mu,sigma]=zscore(originalData);
%2��PCA��ά��
[coeff,score,latent] = princomp(Z);
%3��ѡ��ά��
latent=100*latent/sum(latent);
A=length(latent);
percent_threshold=95;           %�ٷֱȷ�ֵ�����ھ������������ɷָ�����
percents=0;                          %�ۻ��ٷֱ�
for n=1:A
    percents=percents+latent(n);
    if percents>percent_threshold
        break;
    end
end
coeff=coeff(:,1:n);               %�ﵽ���ɷ��ۻ�Ӱ����Ҫ���ϵ������
score=score(:,1:n);              %�ﵽ���ɷ��ۻ�Ӱ����Ҫ������ɷ֣�<br>save PCA mu sigma coeff latent
end
