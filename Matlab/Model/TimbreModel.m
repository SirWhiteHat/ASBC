classdef TimbreModel
    %Approximation Provides curve-fitting functionality for contour approximation
    
    properties
        freqs % Reference frequencies
        linearContourScalar % Current contour scalar
        fMin = 20;
        fMax = 12500;
        freqPoints = 50;
    end
    
    properties (SetAccess = private)
    end
    
    methods
        function obj = TimbreModel(phonMin,phonMax,varargin)
            obj.freqs = obj.createFrequencyRange();
            obj.linearContourScalar = obj.fitLinearContourScalar(phonMin,phonMax);
        end
        
        function gains = createFilterSpec(obj,phon)
            gains = -obj.linearContourScalar.*(phon);
        end
        
        function obj = createFrequencyRange(self)
            % Create a logarithmic frequency range
            low = log2(self.fMin);
            high = log2(self.fMax);
            obj = 2.^(low:(high-low)/(self.freqPoints-1):high);
        end
    end
    
    methods (Access = private)
        function bestFit = fitLinearContourScalar(self, lowPhonRef, highPhonRef)
            contourRef = ISO226();
            phonRefLevels = 10;
            phonRef = lowPhonRef:((highPhonRef-lowPhonRef)/(phonRefLevels-1)):highPhonRef;
            contours = zeros(self.freqPoints,phonRefLevels);
            bestFit = zeros(1,self.freqPoints);
            
            for phon = 1:phonRefLevels
                contours(:,phon) = contourRef.getSPL(phonRef(phon),self.freqs);
            end
            
            for f = 1:self.freqPoints
                % To use weights, replace "polyfit" with "wlinfit". May
                % cause code generation issues.
                fit = polyfit(phonRef,contours(f,:),1);
                bestFit(f) = fit(1);
            end
            
            % Fudge.
            Fudge = 1.0; % If 1, no fudge.
            bestFit = ((bestFit - 1) * Fudge) + 1;
        end
    end
end