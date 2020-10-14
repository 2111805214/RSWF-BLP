%clc;clear;
% format long
%% ԭʼ����
lncSim = load('D:\MATLAB\RWSF-BLP\data\lncRNAsimilarity.txt');   %lncRNA ���������
disSim = load('D:\MATLAB\RWSF-BLP\data\diseasesimilarity.txt');   % disease ����������
interaction = load('D:\MATLAB\RWSF-BLP\data\known_lncRNA_disease_interaction.txt');
[nl,nd] = size(interaction);
interaction_ori = interaction;
%% ���ݴ�����
 n = 1;
 m=1;

    [km,kd] = gaussiansimilarity(interaction_ori,nl,nd);  
    [M_re,D_re] = K_fusion( disSim,lncSim,kd,km,7,0.4);
   
%% ������
   F_ori = LP(interaction_ori,D_re,M_re,nl,nd,0.2);
 
 %%
 F_ori_ori= F_ori;
 index=find(interaction_ori==1);
%%  5-fold ������֤
auc = zeros(1,100);
for k = 1:100
    k
    indices = crossvalind('Kfold', length(index), 5 );
    interaction = interaction_ori;
    F_ori=F_ori_ori;
for cv = 1:5 
       cv;
       index_2 = find(cv == indices);
       %%%�Ƴ���֪��ϵ
       interaction(index(index_2)) = 0;
       %%%����÷־���
%%  ���ݴ���
 [km,kd] = gaussiansimilarity(interaction,nl,nd); 

[M_re,D_re] = K_fusion(disSim,lncSim,kd,km,7,0.4);

%% ������
   F = LP(interaction,D_re,M_re,nl,nd,0.2); 
 
%%
      F_ori(index(index_2)) = F(index(index_2));
      interaction = interaction_ori;
end
%% ��auc���� 
    pre_label_score = F_ori(:);
    label_y = interaction_ori(:);
    auc(k) = roc_1(pre_label_score,label_y,'red'); 
end
%% 
 auc_ave = mean(auc);
 auc_std = std(auc);

