function appendIncludeList(theString)

    h = fopen('CoefficientsOut/uatcMatlab.h','r');
    
    tline = '.';
    
    while (ischar(tline))
        tline = fgetl(h);
        if (strcmp(tline,theString))
            return;
        end
    end
    
    fclose(h);

    h = fopen('CoefficientsOut/uatcMatlab.h','a');
    fprintf(h,theString);
    fprintf(h,'\n');
    
    fclose(h);
    
end