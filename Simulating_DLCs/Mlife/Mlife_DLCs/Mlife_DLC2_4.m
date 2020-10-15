function [] = Mlife_DLC2_4(Y,X,i,discrete,SimulationDirectory,mlf,sp )
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
for j=sp.j:length(Y(:,1))
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
    %%
    fid=fopen(mlf,'rt+');
    for k=1:discrete
        fgetl(fid);
    end
    fseek(fid,0,'cof');
    fprintf(fid,'%1.0f  1 ',n);
    fgetl(fid);
    fseek(fid,0,'cof');
    for k=1:n
        fprintf(fid,'%2.0f "%s"\n',50,Z(k,:));
    end
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