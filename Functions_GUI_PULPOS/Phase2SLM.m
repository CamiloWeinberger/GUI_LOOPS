function modalBasis = Phase2SLM(app,input)
phaseTotal  = exp(i*(pi*input + app.im_corr -pi));
modalBasis  = app.ampFactor*(angle(phaseTotal)/pi+1)/2;
SLM_write(app,modalBasis);
return