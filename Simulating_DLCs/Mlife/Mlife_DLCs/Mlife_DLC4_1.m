function [] = Mlife_DLC4_1( X,i,discrete,SimulationDirectory,mlf )
%%
cf=[SimulationDirectory,'\Simulating_DLCs\Unchanged\',mlf];
copyfile(cf)
%%
fid=fopen(mlf,'rt+');
for j=1:7
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'"%s"',X(i,:));%DLC
fclose(fid);
%%
mkdir('Results')
cd('..\')
%%
W=dir(X(i,:));
W(1:2,:)=[];
Q=struct2cell(W);
%%
for k=1:length(W)
    if W(k).isdir==0
        M(k,1)=Q(1,k);
    end
end
M = M(cellfun('isclass', M, 'char'));
Z = char(M);
%% Input files
fid=fopen(mlf,'rt+');
for k=1:discrete
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'%1.0f  1 ',n);
fgetl(fid);
fseek(fid,0,'cof');
for k=1:n
    fprintf(fid,'%4.0f "%s"\n',3600,Z(k,:));
end
%fprintf(fid,'%s\n','0  1.1   1.3   1.5   1.7    (Weibull-Weighted Idling: NumIdleFiles, PSF1, PSF2, PSF3, PSF4)');
%fprintf(fid,'%s\n','0  1.2   1.3   1.4   1.6    (Discrete Events: NumDiscFiles, PSF1, PSF2, PSF3, PSF4)');
fprintf(fid,'%s','==EOF==                             DO NOT REMOVE OR CHANGE.  MUST COME JUST AFTER LAST LINE OF VALID INPUT.');
fclose(fid);
%%
R=strrep(X(i,:),' ','');
R=[R,'\Results'];
%%
try
    mlife(mlf,X(i,:),R)
catch ME
end

cd(SimulationDirectory)
end