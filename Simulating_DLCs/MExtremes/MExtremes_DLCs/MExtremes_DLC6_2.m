function [] = MExtremes_DLC6_2( Y,SimulationDirectory,mef,sp  )
%%
cf=[SimulationDirectory,'\Simulating_DLCs\Unchanged\',mef];
copyfile(cf)
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
    R=strrep(Y(j,:),' ','');
    %% Input files
    fid=fopen(mef,'rt+');
    for k=1:42
        fgetl(fid);
    end
    fseek(fid,0,'cof');
    fprintf(fid,'%1.0f  %s\n',n,'1.1   1.3   1.5   1.7  0  "DLC 6.2"         (NumDLCfiles, PSF1, PSF2, PSF3, PSF4, BinModel, DLC_Name)');
    for k=1:n
        InputFile=['.\',R,'\',Z(k,:)];
        fprintf(fid,'"%s"\n',InputFile);
    end
    fprintf(fid,'%s','==EOF==                             DO NOT REMOVE OR CHANGE.  MUST COME JUST AFTER LAST LINE OF VALID INPUT.');
    fclose(fid);
    %% If an output file has no data inside and gives an error, this will ignore it
    try
        MExtremes(mef)
    catch ME
    end
    %%
    S=[R,'.extr'];
    T=[R,'\Results'];
    m=[mef(1:end-4),'extr'];
    movefile(m,S)
    movefile(S,T)
end
sp.j=1;
cd(SimulationDirectory)
end