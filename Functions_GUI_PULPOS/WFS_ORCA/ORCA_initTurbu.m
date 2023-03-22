%% Turbulence Generator on SLM
r0 = 1;
atmSLM = atmosphere(photometry.V,r0,30,...
    'altitude',[0],...
    'fractionnalR0',[1],...
    'windSpeed',[10],...
    'windDirection',[0]);
telSLM = telescope(8,'fieldOfViewInArcmin',2,'resolution',360,'samplingTime',1/500);
telSLM = telSLM + atmSLM;
ngsSLM = source;
ngsSLM = ngsSLM.*telSLM;
+telSLM;
ngsSLM = ngsSLM.*telSLM;