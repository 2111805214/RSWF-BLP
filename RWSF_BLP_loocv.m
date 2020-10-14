clc;clear;
% format long
%% ԭʼ����
lncSim = load('D:\MATLAB\Bidirectional_label_propagation\data\lncRNAsimilarity.txt');   %lncRNA ���������
disSim = load('D:\MATLAB\Bidirectional_label_propagation\data\diseasesimilarity.txt');  % disease ����������
interaction = load('D:\MATLAB\Bidirectional_label_propagation\data\known_lncRNA_disease_interaction.txt');

%% ���ݴ�����

[nl,nd] = size(interaction);
interaction_ori = interaction; 
  n=1;
  m=1;

 [km,kd] = gaussiansimilarity(interaction_ori,nl,nd);
 [M_re,D_re] = K_fusion(disSim,lncSim,kd,km,7,0.4);

%% ������

F_ori = LP(interaction_ori,D_re,M_re,nl,nd,0.2);

index=find(interaction_ori==1); 
%%  ��һ������֤��LOOCV��
for u=1:length(index)
     u   
    interaction(index(u))=0;
   

%% ���ݴ�����
%% computing Gaussian interaction profile kernel of lncRNAs

[km,kd] = gaussiansimilarity(interaction,nl,nd); 


[M_re,D_re] = K_fusion(disSim,lncSim,kd,km,7,0.4);

%% ������
  
F = LP(interaction,D_re,M_re,nl,nd,0.2);

%%

F_ori(index(u))=F(index(u));
interaction = interaction_ori;
    
end
 pre_label_score = F_ori(:);
 label_y = interaction_ori(:);
 auc=roc_1(pre_label_score,label_y,'red');

