function [] = Mlife_DLC1_2( Y,X,i,normal,SimulationDirectory,mlf,sp )
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
for j=sp.i:length(Y(:,1))
    sp.j=j;
    %%
    cd(Y(j,:))
    mkdir('Results')
    cd('..\')
    %%
    W=dir(Y(j,:));
    W(1:2,:)=[];
    Q=struct2cell(W);
    %%   
    for k=1:length(W)
        if W(k).isdir==0
            M(k,1)=Q(1,k);
        end
    end
    %%
    M = M(cellfun('isclass', M, 'char'));
    Z = char(M);
    n=length(Z(:,1));
    %% Input files
    fid=fopen(mlf,'rt+');
    for k=1:normal
        fgetl(fid);
    end
    fseek(fid,0,'cof');
    fprintf(fid,'%1.0f  1 ',n);
    fgetl(fid);
    fseek(fid,0,'cof');
    for k=1:n
        fprintf(fid,'"%s"\n',Z(k,:));
    end
    fprintf(fid,'%s\n','0  1.1   1.3   1.5   1.7    (Weibull-Weighted Idling: NumIdleFiles, PSF1, PSF2, PSF3, PSF4)');
    fprintf(fid,'%s\n','0  1.2   1.3   1.4   1.6    (Discrete Events: NumDiscFiles, PSF1, PSF2, PSF3, PSF4)');
    fprintf(fid,'%s','==EOF==                             DO NOT REMOVE OR CHANGE.  MUST COME JUST AFTER LAST LINE OF VALID INPUT.');
    fclose(fid);
    %%
    R=strrep(Y(j,:),' ','');
    R=[R,'\Results'];
    %%
    try
        mlife(mlf,Y(j,:),R)
    catch ME
    end
end
sp.j=1;
cd(SimulationDirectory)
end