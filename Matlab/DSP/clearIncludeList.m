function clearIncludeList()
    
    h = fopen('CoefficientsOut/uatcMatlab.h','w');
    fprintf(h,'');
    fclose(h);
    
end