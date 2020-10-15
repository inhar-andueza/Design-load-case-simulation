function [] = CreateResults()
%% Create Results Folder
mkdir('Results');
cd('Results')

for i=1:7
    if i<2
        for j=1:5
            x=['DLC',num2str(i),'_',num2str(j)];            
            mkdir(x);
        end
    end
    if i>1 && i<3
        for j=1:4
            x=['DLC',num2str(i),'_',num2str(j)];            
            mkdir(x);
        end
    end
    if i>2 && i<4
        for j=1:3
            x=['DLC',num2str(i),'_',num2str(j)];           
            mkdir(x);
        end
    end
    if i>3 && i<5
        for j=1:2
            x=['DLC',num2str(i),'_',num2str(j)];            
            mkdir(x);
        end
    end
    if i>4 && i<6
        for j=1
            x=['DLC',num2str(i),'_',num2str(j)];           
            mkdir(x);
        end
    end
    if i>5 && i<7
        for j=1:4
            x=['DLC',num2str(i),'_',num2str(j)];           
            mkdir(x);
        end
    end
    if i>6
        for j=1
            x=['DLC',num2str(i),'_',num2str(j)];           
            mkdir(x);
        end
    end
end
end