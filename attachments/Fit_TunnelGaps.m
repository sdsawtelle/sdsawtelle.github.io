% Function simulCurrent for all IV text files in the directory, it sequentially reads in the
% voltage and current data, fits it to the tunneling model as described in
% simulCurrent.m and then generates an IV plot with the experimental data
% and the fit line.

function []=simulCurrent()
clear
savepath='C:\Users\Sonya\Documents\My Box Files\MolT Project\Archived\Data\140830_cryoEMBJ_chipA1-A2\chipA1\TC\test\'

cd(savepath);
currentDirectory = pwd;
[upperPath, Folder, ~] = fileparts(currentDirectory);
filenames=dir(strcat(savepath,'*.txt*'));
names={filenames.name};

for i=1:length(filenames)
    H=figure(i);
    [pathstr,name,ext] = fileparts(names{i}); 
    
    [vds,ids]=textread(names{i},'%f %f','headerlines',1);
    
    % restrict to positive voltages, and reduce the number of data points
    % to speed up fitting - target # data points is around 30
    vTrunc=transpose(vds(vds>=0));
    iTrunc=transpose(ids(vds>=0));
    
    % pull just a subset of the data to fit to, saves time
    increment=floor(length(vTrunc)/30);
    vTrunc=vTrunc(increment*(1:30));
    iTrunc=iTrunc(increment*(1:30));
    
    % options for the fitting algorithm
    options = optimoptions(@lsqcurvefit,'TolX',1e-10,'Display','iter','TolFun',1e-16);

    params0=[0.6,0.5,0.2]; % initial point in parameter space for algorithm
    lb=[0.1,0.01,0.01]; % lower bound in parameter space
    ub=[10,5,5]; % upper bound in parameter space

    % does a least squares fit to the model implemented in SimulCurrent
    [params,resnorm,residual,exitflag,output] = lsqcurvefit(@simulCurrent,params0,-vTrunc,-iTrunc,lb,ub,options);
    iFit=-simulCurrent(params,-vds(vds>=0)); % calculate the fit line from the model using fitted parameters
    
    % plotting data alongside fit
    p0=plot(vds,ids,'r-o','MarkerSize',3);
    hold on;
    p1=plot(vds(vds>=0),iFit,'LineWidth',2);
    xlabel('Vds (V)','FontSize',16);
    ylabel('Ids (A)','FontSize',16);
    titlestr=strcat('Tunneling -',name);
    title(titlestr,'FontSize',15,'interpreter','none');
    set(gca,'fontsize',16);
    axis tight;
    legend([p0,p1],'Experimental IV','Fit Line','Location', 'SouthEast' )
    
    mTextBox=annotation('textbox',[0.2 0.19 0.54 0.59]);
    set(mTextBox,'String',strcat('gap distance =',{' '},num2str(params(1))));
    set(mTextBox,'FitBoxToText','on','FontSize',12);
    
    savename=strcat(savepath,'TC_',name);
    saveas(H, savename,'png');
    saveas(H, savename,'fig');
end
end



% Calculates tunneling current values for a vector of voltage values given
% a fixed tunneling gap width and two fixed asymmetric tunnel barriers.
% Uses a model of trapezoidal tunneling potential and the WKB approximation
% for transmission probabilities for such a potential. Uses a
% zero-temperature approximation (justified for LN2 Temp with kT ~ 6meV)
% and neglects any structure of the DOS at the tunneling tip.

% Please note, simulCurrent expects to receive gap distance in nanometers,
% work function values in electron volts, and voltage bias in volts. It
% will return current in amperes.

function current = simulCurrent(params,voltage)
    % convert to SI units from the user-input units of nanometers and eV
    d=params(1)*10^-9;
    psiS=params(2)*1.06*10^-19;
    psiD=params(3)*1.06*10^-19;

    % universal physical constants
    echarge = 1.60e-19;
    hbar = 1.05e-34;
    mass = 9.11e-31;
    
    for i=1:length(voltage)    
        current(i)=2*echarge/hbar*outerIntegral(voltage(i)); 
    end

    
    function curr = outerIntegral(volt)
        curr=integral(@outerIntegrand,0,echarge*volt,'ArrayValued',true);

        function outer = outerIntegrand(E)
            % prevent complex-values outputs by controlling integration
            % limit of the inner integral
            intlimit=min([d,d*(E-psiS)/(psiD-psiS+echarge*volt)]);   
%             intlimit
            transmission=integral(@innerIntegrand,0,intlimit,'ArrayValued',true);
            outer=exp(-transmission);
%             outer

            function inner = innerIntegrand(x)
                inner=sqrt(8*mass/hbar^2*(psiS+(psiD-psiS+echarge*volt)*(x/d)-E));

            end
        end
    end
end
