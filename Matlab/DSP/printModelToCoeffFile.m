% Prints filters required for a given timbremodel
function printModelToCoeffFile(n,model,filterType,fs)

    warning('off','all');

    switch filterType
        case 'fdfir'
            dsp = dspTypeFdfir(n);
        case 'fir'
            dsp = dspTypeFir(n);
        case 'firmin'
            dsp = dspTypeFirmin(n);
        case 'fdfirmin'
            dsp = dspTypeFdfirmin(n);
        case 'iiryw'
            dsp = dspTypeIirYuleWalk(n);
        case 'iirywsos'
            dsp = dspTypeIirYuleWalkSos(n);
        case 'iir'
            dsp = dspTypeIir(n);
    end

    nOfFilters = size(model.gains,1);
    filterData = [];
    
    % Render filter data
    for atten = 1:nOfFilters
        filt = dsp.getFilter(model.freqs, model.gains(atten,:), fs);
        filt.N = n;
        filterData = [filterData;filt];
    end
    
    disp(['Printing ' dsp.label]);
    
    % Print filter file
    coeffFormatter(filterData, dsp.label);
    
end

function coeffFormatter(data, label)
    filename = ['CoefficientsOut/uatcDsp' label 'Coefficients.cpp'];
    h = fopen(filename,'w');
    
    p(h,['#include "uatcMatlab.h"\n\n']);
    
    headerString = [];
    
    formats = cellstr(['Double' ; 'Float ']);
    
    for format = 1:numel(formats)
        fields = fieldnames(data(1));
        for f = 1:numel(fields)

            % Variable declaration
            headerString = ['const ' lower(formats{format}) ' ' label fields{f} formats{format} ];
            headerString = [headerString '[' num2str(numel(data)) ']'];

            nDims = ndims(data(1).(fields{f}));
            dimSize = zeros(1,nDims);

            % Array size
            for i = 1:nDims
                dimSize(i) = size(data(1).(fields{f}),i);
            end

            % Remove stray 1-dimension
            if (dimSize(end) == 1)
                dimSize = dimSize(1:(end-1));
                nDims = nDims - 1;
            end

            %Print array size
            for i = 1:nDims
                headerString = [headerString '[' num2str(dimSize(i)) ']'];
            end

            appendIncludeList(['extern ' headerString ';']);
            
            p(h,headerString)
            
            p(h,'={');

            for fil = 1:numel(data)

                cDim = 0;
                dimCounter = zeros(1,nDims);
                count = 0;
                done = 0;

                % Invert array for indexing reasons
                data(fil).(fields{f}) = permute(data(fil).(fields{f}),ndims(data(fil).(fields{f})):-1:1);
                invDimSize = fliplr(dimSize());

                % Print data
                while(~done)
                    if (cDim == nDims)
                        %Write value
                        while (dimCounter(cDim) < dimSize(cDim))
                            count = count + 1;
                            dimCounter(cDim) = dimCounter(cDim) + 1;
                            p(h,sprintf('%0.30e',data(fil).(fields{f})(ind2sub(invDimSize,count))));
                            if (dimCounter(cDim) < dimSize(cDim))
                                p(h,',');
                            end
                        end
                        while (dimCounter(cDim) == dimSize(cDim))
                            %Has finished writing dim, step up
                            dimCounter(cDim) = 0;
                            cDim = cDim - 1;
                            if (cDim > 0)
                                dimCounter(cDim) = dimCounter(cDim) + 1;
                            else
                                p(h,'}');
                                done = 1;
                                break;
                            end
                            p(h,'}');
                            if (dimCounter(cDim) < dimSize(cDim))
                                p(h,',');
                            end
                        end
                    else
                        %Drop in a dimension
                        cDim = cDim + 1;
                        p(h,'{');
                    end
                end
                if (fil < numel(data))
                    p(h,',')
                end
            end
           p(h,'};\n\n') 
        end
    end
    fclose(h);
end

function [] = p(h,d)
    fprintf(h,d);
end %Shortcut function 'print(handle,data)'