function [] = ResetParameters()
%%
sp = matfile('SaveParameters','Writable',true);
sp.dlc=1;
sp.pp=1;
sp.m=1;
sp.i=1;
sp.j=1;
sp.k=1;
end